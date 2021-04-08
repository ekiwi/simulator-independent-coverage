// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage.passes

import firrtl._
import firrtl.analyses.InstanceKeyGraph
import firrtl.analyses.InstanceKeyGraph.InstanceKey

import scala.collection.mutable

/** Analyses which signals in a module always have the same value (are aliases of each other).
 *  @note will only work on low firrtl!
 *  @note right now this isn't an actual firrtl pass, but an analysis called into from a firrtl pass.
 */
object AliasAnalysis {
  type Aliases = Seq[List[String]]
  type Result = Map[String, Aliases]

  /** @return map from module name to signals in the module that alias */
  def findAliases(c: ir.Circuit): Result = {
    // analyze each module in isolation
    val local = c.modules.map(m => m.name -> findAliases(m)).toMap

    // compute global results
    val iGraph = InstanceKeyGraph(c)
    val moduleOrderBottomUp = iGraph.moduleOrder.reverseIterator
    val childInstances = iGraph.getChildInstances.toMap
    val portAliases = mutable.HashMap[String, PortAliases]()

    val aliases = moduleOrderBottomUp.map {
      case m: ir.Module =>
        val groups = resolveAliases(m, local(m.name), portAliases, childInstances(m.name))
        val isPort = m.ports.map(_.name).toSet
        portAliases(m.name) = computePortAliases(groups, isPort)
        m.name -> groups
      case other =>
        portAliases(other.name) = List()
        other.name -> List()
    }

    aliases.toMap
  }

  private type PortAliases = List[(String, String)]

  // Incorporate the alias information from all sub modules.
  // This matters if the submodule has an input and an output that aliases.
  private def resolveAliases(m: ir.Module, local: LocalInfo, portAliases: String => PortAliases,
    instances: Seq[InstanceKey]): Seq[List[String]] = {
    // compute any port aliases for all child modules
    val instancePortAliases = instances.flatMap { case InstanceKey(name, module) =>
      portAliases(module).map { case (a,b) =>
        (name + "." + a) -> (name + "." + b)
      }
    }.toMap

    // if there are no port aliases in the children, nothing is going to change
    if(instancePortAliases.isEmpty) return local.groups

    // build a map from (aliasing) instance port to group id
    val instPortToGroupId = local.groups.zipWithIndex.flatMap { case (g, ii) =>
      val ips = g.filter(instancePortAliases.contains)
      ips.map(i => i -> ii)
    }.toMap

    // check to see if there are any groups that need to be merged
    val merges = findMerges(instancePortAliases, instPortToGroupId)
    val updatedGroups = mergeGroups(local.groups, merges)

    updatedGroups
  }

  private def computePortAliases(groups: Seq[List[String]], isPort: String => Boolean): PortAliases = {
    groups.flatMap { g =>
      val ports = g.filter(isPort)
      assert(ports.length < 4, s"Unexpected exponential blowup! Redesign the data-structure! $ports")
      ports.flatMap { a =>
        ports.flatMap { b =>
          if(a == b) None else Some(a -> b)
        }
      }
    }.toList
  }

  private def findMerges(aliases: Iterable[(String, String)], signalToGroupId: Map[String, Int]): List[Set[Int]] = {
    // check to see if there are any groups that need to be merged
    var merges = List[Set[Int]]()
    aliases.foreach { case (a,b) =>
      val (aId, bId) = (signalToGroupId(a), signalToGroupId(b))
      if(aId != bId) {
        val merge = Set(aId, bId)
        // update merges
        val bothNew = !merges.exists(s => (s & merge).nonEmpty)
        if(bothNew) {
          merges = merge +: merges
        } else {
          merges = merges.map { old =>
            if((old & merge).nonEmpty) { old | merge } else { old }
          }.distinct
        }
      }
    }
    merges
  }

  private def mergeGroups(groups: Seq[List[String]], merges: List[Set[Int]]): Seq[List[String]] = {
    if(merges.isEmpty) { groups } else {
      val merged = merges.map { m =>
        m.toList.sorted.flatMap(i => groups(i))
      }
      val wasMerged = merges.flatten.toSet
      val unmerged = groups.indices.filterNot(wasMerged).map(i => groups(i))
      merged ++ unmerged
    }
  }


  private def findAliases(m: ir.DefModule): LocalInfo = m match {
    case mod: ir.Module => findAliasesM(mod)
    case _ => LocalInfo(List())
  }

  private type Connects = mutable.HashMap[String, String]
  private def findAliasesM(m: ir.Module): LocalInfo = {
    // find all signals inside the module that alias
    val cons = new Connects()
    m.foreachStmt(onStmt(_, cons))
    val groups = groupSignals(cons)
    //groups.foreach(g => println(g.mkString(" <-> ")))
    LocalInfo(groups)
  }
  private def groupSignals(cons: Connects): Seq[List[String]] = {
    val signalToGroup = mutable.HashMap[String, Int]()
    val groups = mutable.ArrayBuffer[List[String]]()
    val signals = (cons.keys.toSet | cons.values.toSet).toSeq
    signals.foreach { sig =>
      signalToGroup.get(sig) match {
        case Some(groupId) =>
          // we have seen this signal before, so all alias info is up to date and we just need to add it to the group!
          groups(groupId) = sig +: groups(groupId)
        case None =>
          // check to see if any group exists under any alias name
          val aliases = getAliases(sig, cons)
          val groupId = aliases.find(a => signalToGroup.contains(a)) match {
            case Some(key) => signalToGroup(key)
            case None => groups.append(List()) ; groups.length - 1
          }
          groups(groupId) = sig +: groups(groupId)
          aliases.foreach(a => signalToGroup(a) = groupId)
      }
    }
    groups
  }
  private def getAliases(name: String, cons: Connects): List[String] = cons.get(name) match {
    case None => List(name)
    case Some(a) => name +: getAliases(a, cons)
  }

  import coverage.midas.Builder.getKind
  private def onStmt(s: ir.Statement, cons: Connects): Unit = s match {
    case ir.DefNode(_, lhs, rhs: ir.RefLikeExpression) =>
      cons(lhs) = rhs.serialize
    case ir.Connect(_, lhs: ir.RefLikeExpression, rhs: ir.RefLikeExpression) if getKind(lhs) != RegKind =>
      cons(lhs.serialize) = rhs.serialize
    case other => other.foreachStmt(onStmt(_, cons))
  }

}

private case class LocalInfo(groups: Seq[List[String]])

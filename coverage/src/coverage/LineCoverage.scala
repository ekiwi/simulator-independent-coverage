// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package coverage

import coverage.midas.Builder
import chiseltest.coverage._
import firrtl._
import firrtl.annotations.{Annotation, CircuitTarget, ModuleTarget, ReferenceTarget, SingleTargetAnnotation}
import firrtl.options.Dependency
import firrtl.passes.{ExpandWhens, ExpandWhensAndCheck}
import firrtl.stage.{Forms, RunFirrtlTransformAnnotation}
import firrtl.stage.TransformManager.TransformDependency
import firrtl.transforms.DedupModules

import scala.collection.mutable

object LineCoverage {
  def annotations: AnnotationSeq = Seq(
    RunFirrtlTransformAnnotation(Dependency(LineCoveragePass)),
    RunFirrtlTransformAnnotation(Dependency(ModuleInstancesPass))
  )

  def processCoverage(annos: AnnotationSeq): LineCoverageData = {
    val cov = Coverage.collectTestCoverage(annos).toMap
    val moduleToInst = Coverage.collectModuleInstances(annos).groupBy(_._2).mapValues(_.map(_._1))
    val infos = annos.collect { case a: LineCoverageAnnotation => a }

    val counts = infos.flatMap { case LineCoverageAnnotation(target, lines) =>
      val insts = moduleToInst(target.module)
      val counts = insts.map { i =>
        val path = Coverage.path(i, target.ref)
        cov(path)
      }
      val total = counts.sum

      lines.flatMap { case (filename, ll) =>
        ll.map { line =>
          (filename, line) -> total
        }
      }
    }

    val files = counts
      .groupBy(_._1._1)
      .map { case (filename, entries) =>
        val lines = entries.map(e => (e._1._2, e._2)).sortBy(_._1).toList
        LineCoverageInFile(filename, lines)
      }
      .toList
      .sortBy(_.name)

    LineCoverageData(files)
  }

  private val Count = "Cnt"
  private val LineNr = "Line"
  def textReport(code: CodeBase, file: LineCoverageInFile): Iterable[String] = {
    val sourceLines = code.getSource(file.name).getOrElse {
      throw new RuntimeException(s"Unable to find file ${file.name} in ${code}")
    }
    val counts: Map[Int, Long] = file.lines.toMap

    // we output a table with Line, Exec, Source
    val lineNrWidth = (file.lines.map(_._1.toString.length) :+ LineNr.length).max
    val countWidth = (file.lines.map(_._2.toString.length) :+ Count.length).max
    val countBlank = " " * countWidth
    val srcWidth = sourceLines.map(_.length).max

    val header = pad(LineNr, lineNrWidth) + " | " + pad(Count, countWidth) + " | " + "Source"
    val headerLine = "-" * (lineNrWidth + 3 + countWidth + 3 + srcWidth)

    val body = sourceLines.zipWithIndex.map { case (line, ii) =>
      val lineNo = ii + 1 // lines are 1-indexed
      val lineNoStr = pad(lineNo.toString, lineNrWidth)
      val countStr = counts.get(lineNo).map(c => pad(c.toString, countWidth)).getOrElse(countBlank)
      lineNoStr + " | " + countStr + " | " + line
    }
    Seq(header, headerLine) ++ body
  }

  private def pad(str: String, to: Int): String = {
    assert(str.length <= to)
    str.reverse.padTo(to, ' ').reverse
  }
}

case class LineCoverageData(files: List[LineCoverageInFile])
case class LineCoverageInFile(name: String, lines: List[(Int, Long)])

case class LineCoverageAnnotation(target: ReferenceTarget, lines: Coverage.Lines)
    extends SingleTargetAnnotation[ReferenceTarget]
    with CoverageInfo {
  override def duplicate(n: ReferenceTarget) = copy(target = n)
}

object LineCoveragePass extends Transform with DependencyAPIMigration {
  val Prefix = "l"

  override def prerequisites: Seq[TransformDependency] = Forms.Checks
  // we can run after deduplication which should make things faster
  override def optionalPrerequisites: Seq[TransformDependency] = Seq(Dependency[DedupModules])
  // line coverage does not work anymore after whens have been expanded
  override def optionalPrerequisiteOf: Seq[TransformDependency] =
    Seq(Dependency[ExpandWhensAndCheck], Dependency(ExpandWhens))
  override def invalidates(a: Transform): Boolean = false

  override protected def execute(state: CircuitState): CircuitState = {
    val newAnnos = mutable.ListBuffer[Annotation]()
    val c = CircuitTarget(state.circuit.main)
    val ignoreMods = Coverage.collectModulesToIgnore(state)
    val circuit = state.circuit.mapModule(onModule(_, c, newAnnos, ignoreMods))
    val annos = newAnnos.toList ++ state.annotations
    CircuitState(circuit, annos)
  }

  private case class ModuleCtx(
    annos:     mutable.ListBuffer[Annotation],
    namespace: Namespace,
    m:         ModuleTarget,
    clk:       ir.Expression)

  private def onModule(m: ir.DefModule, c: CircuitTarget, annos: mutable.ListBuffer[Annotation], ignore: Set[String]): ir.DefModule =
    m match {
      case mod: ir.Module if !ignore(mod.name) =>
        val namespace = Namespace(mod)
        namespace.newName(Prefix)
        val ctx = ModuleCtx(annos, namespace, c.module(mod.name), Builder.findClock(mod))
        val bodyInfo = onStmt(mod.body, ctx)
        val body = addCover(bodyInfo, ctx)
        mod.copy(body = body)
      case other => other
    }

  private def onStmt(s: ir.Statement, ctx: ModuleCtx): (ir.Statement, Boolean, Seq[ir.Info]) = s match {
    case c @ ir.Conditionally(_, _, conseq, alt) =>
      val truInfo = onStmt(conseq, ctx)
      val falsInfo = onStmt(alt, ctx)
      val doCover = truInfo._2 || falsInfo._2
      val stmt = c.copy(conseq = addCover(truInfo, ctx), alt = addCover(falsInfo, ctx))
      (stmt, doCover, List(c.info))
    case ir.Block(stmts) =>
      val s = stmts.map(onStmt(_, ctx))
      val block = ir.Block(s.map(_._1))
      val doCover = s.map(_._2).foldLeft(false)(_ || _)
      val infos = s.flatMap(_._3)
      (block, doCover, infos)
    case ir.EmptyStmt                                        => (ir.EmptyStmt, false, List())
    case v @ ir.Verification(ir.Formal.Cover, _, _, _, _, _) => (v, false, List(v.info))
    case other: ir.HasInfo => (other, true, List(other.info))
    case other => (other, false, List())
  }

  private def addCover(info: (ir.Statement, Boolean, Seq[ir.Info]), ctx: ModuleCtx): ir.Statement = {
    val (stmt, doCover, infos) = info
    if (!doCover) { stmt }
    else {
      val name = ctx.namespace.newName(Prefix)
      val lines = Coverage.infosToLines(infos)
      ctx.annos.prepend(LineCoverageAnnotation(ctx.m.ref(name), lines))
      val cover =
        ir.Verification(ir.Formal.Cover, ir.NoInfo, ctx.clk, Utils.True(), Utils.True(), ir.StringLit(""), name)
      ir.Block(cover, stmt)
    }
  }
}

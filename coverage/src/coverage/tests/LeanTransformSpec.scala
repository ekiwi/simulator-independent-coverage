// SPDX-License-Identifier: Apache-2.0

// copied from firrtl testutils

package coverage.tests

import firrtl.options.Dependency
import firrtl.passes.RemoveEmpty
import firrtl.stage.TransformManager.TransformDependency
import firrtl.{AnnotationSeq, CircuitState, EmitCircuitAnnotation, ir}
import logger.LazyLogging
import org.scalatest.flatspec.AnyFlatSpec

class VerilogTransformSpec extends LeanTransformSpec(Seq(Dependency[firrtl.VerilogEmitter]))
class LowFirrtlTransformSpec extends LeanTransformSpec(Seq(Dependency[firrtl.LowFirrtlEmitter]))

/** The new cool kid on the block, creates a custom compiler for your transform. */
class LeanTransformSpec(protected val transforms: Seq[TransformDependency])
    extends AnyFlatSpec
    with LazyLogging {
  private val compiler = new firrtl.stage.transforms.Compiler(transforms)
  private val emitterAnnos = LeanTransformSpec.deriveEmitCircuitAnnotations(transforms)

  protected def compile(src: String): CircuitState = compile(src, Seq())
  protected def compile(src: String, annos: AnnotationSeq): CircuitState = compile(firrtl.Parser.parse(src), annos)
  protected def compile(c:   ir.Circuit): CircuitState = compile(c, Seq())
  protected def compile(c:   ir.Circuit, annos: AnnotationSeq): CircuitState =
    compiler.transform(CircuitState(c, emitterAnnos ++ annos))
  protected def execute(input: String, check: String): CircuitState = execute(input, check, Seq())
  protected def execute(input: String, check: String, inAnnos: AnnotationSeq): CircuitState = {
    val finalState = compiler.transform(CircuitState(parse(input), inAnnos))
    val actual = RemoveEmpty.run(parse(finalState.getEmittedCircuit.value)).serialize
    val expected = parse(check).serialize
    logger.debug(actual)
    logger.debug(expected)
    assert(actual == expected)
    finalState
  }
  private def parse(src: String): ir.Circuit = firrtl.Parser.parse(src)
}

private object LeanTransformSpec {
  private def deriveEmitCircuitAnnotations(transforms: Iterable[TransformDependency]): AnnotationSeq = {
    val emitters = transforms.map(_.getObject()).collect { case e: firrtl.Emitter => e }
    emitters.map(e => EmitCircuitAnnotation(e.getClass)).toSeq
  }
}

/** Use this if you just need to create a standard compiler and want to save some typing. */
trait MakeCompiler {
  protected def makeVerilogCompiler(transforms: Seq[TransformDependency] = Seq()) =
    new firrtl.stage.transforms.Compiler(Seq(Dependency[firrtl.VerilogEmitter]) ++ transforms)
  protected def makeMinimumVerilogCompiler(transforms: Seq[TransformDependency] = Seq()) =
    new firrtl.stage.transforms.Compiler(Seq(Dependency[firrtl.MinimumVerilogEmitter]) ++ transforms)
  protected def makeLowFirrtlCompiler(transforms: Seq[TransformDependency] = Seq()) =
    new firrtl.stage.transforms.Compiler(Seq(Dependency[firrtl.LowFirrtlEmitter]) ++ transforms)
}
// Copyright 2021 The Regents of the University of California
// released under BSD 3-Clause License
// author: Kevin Laeufer <laeufer@cs.berkeley.edu>

package firrtl.annotations

// small hack to be able to create a PresetRegAnnotation from outside of firrtl
object MakePresetRegAnnotation {
  def apply(target: ReferenceTarget): Annotation = PresetRegAnnotation(target)
}

name := "coverage"
version := "0.5.5"
scalaVersion := "2.13.10"

scalacOptions := Seq("-deprecation", "-unchecked", "-language:reflectiveCalls")

// SNAPSHOT repositories
libraryDependencies += "edu.berkeley.cs" %% "chisel3" % "3.5.5"
libraryDependencies += "edu.berkeley.cs" %% "chiseltest" % "0.5.5"
addCompilerPlugin("edu.berkeley.cs" % "chisel3-plugin" % "3.5.5" cross CrossVersion.full)

Compile / scalaSource := baseDirectory.value / "src"
Compile / resourceDirectory := baseDirectory.value / "src" / "resources"
Test / scalaSource := baseDirectory.value / "test"
Test / resourceDirectory := baseDirectory.value / "test" / "resources"

// use `sbt assembly` to build a fat jar
assembly / assemblyJarName := "firrtl.jar"
assembly / test := {}
assembly / assemblyOutputPath := file("./utils/bin/firrtl.jar")

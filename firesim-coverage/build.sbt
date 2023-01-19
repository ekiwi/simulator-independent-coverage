name := "firesim-coverage"
version := "0.5.3"
scalaVersion := "2.13.6"
crossScalaVersions := Seq("2.13.6", "2.12.15")

scalacOptions := Seq("-deprecation", "-unchecked", "-language:reflectiveCalls")

lazy val coverage = ProjectRef(file("../coverage"), "coverage")


libraryDependencies += "edu.berkeley.cs" %% "chisel3" % "3.5.3"
libraryDependencies += "edu.berkeley.cs" %% "chiseltest" % "0.5.3"
addCompilerPlugin("edu.berkeley.cs" % "chisel3-plugin" % "3.5.3" cross CrossVersion.full)
dependsOn(coverage)

Compile / scalaSource := baseDirectory.value / "src"
Compile / resourceDirectory := baseDirectory.value / "src" / "resources"
Test / scalaSource := baseDirectory.value / "test"
Test / resourceDirectory := baseDirectory.value / "test" / "resources"



// use `sbt assembly` to build a fat jar
assembly / assemblyJarName := "firrtl.jar"
assembly / test := {}
assembly / assemblyOutputPath := file("./utils/bin/firrtl.jar")

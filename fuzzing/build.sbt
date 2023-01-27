name := "rtl-fuzz-lab"
version := "0.1"
scalaVersion := "2.12.15"
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

// do not run tests before generating JAR
assembly / test := {}

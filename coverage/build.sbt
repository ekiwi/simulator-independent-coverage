name := "coverage"
version := "0.1"
scalaVersion := "2.12.13"

scalacOptions := Seq("-deprecation", "-unchecked", "-Xsource:2.11")

// SNAPSHOT repositories
resolvers += Resolver.sonatypeRepo("snapshots")

libraryDependencies += "edu.berkeley.cs" %% "chisel3" % "3.5-SNAPSHOT"
libraryDependencies += "edu.berkeley.cs" %% "chiseltest" % "0.5-SNAPSHOT"
libraryDependencies += "org.scalatest" %% "scalatest" % "3.2.6" % Test

scalaSource in Compile := baseDirectory.value / "src"
resourceDirectory in Compile := baseDirectory.value / "src" / "resources"
scalaSource in Test := baseDirectory.value / "test"

// use `sbt assembly` to build a fat jar
assemblyJarName in assembly := "firrtl.jar"
test in assembly := {}
assemblyOutputPath in assembly := file("./utils/bin/firrtl.jar")

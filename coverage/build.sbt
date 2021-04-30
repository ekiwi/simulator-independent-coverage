name := "coverage"
version := "0.5-SNAPSHOT"
scalaVersion := "2.13.5"

scalacOptions := Seq("-deprecation", "-unchecked", "-language:reflectiveCalls")

// SNAPSHOT repositories
resolvers += Resolver.sonatypeRepo("snapshots")
libraryDependencies += "edu.berkeley.cs" %% "chisel3" % "3.5-SNAPSHOT"
libraryDependencies += "edu.berkeley.cs" %% "chiseltest" % "0.5-SNAPSHOT"
libraryDependencies += "org.scalatest" %% "scalatest" % "3.2.6" % Test
addCompilerPlugin("edu.berkeley.cs" % "chisel3-plugin" % "3.5-SNAPSHOT" cross CrossVersion.full)

scalaSource in Compile := baseDirectory.value / "src"
resourceDirectory in Compile := baseDirectory.value / "src" / "resources"
scalaSource in Test := baseDirectory.value / "test"
resourceDirectory in Test := baseDirectory.value / "test" / "resources"

// use `sbt assembly` to build a fat jar
assemblyJarName in assembly := "firrtl.jar"
test in assembly := {}
assemblyOutputPath in assembly := file("./utils/bin/firrtl.jar")

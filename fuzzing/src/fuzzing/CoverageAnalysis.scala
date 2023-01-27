package fuzzing

/** Analyzes coverage produced from running fuzzer.
  * Generates JSON file which can be plotted.
  */

object CoverageAnalysis {

  def run(target: FuzzTarget, outFolder: os.Path, feedbackCap: Int): Unit = {
    val queue = outFolder / "queue"
    val endTimeFile = outFolder / "end_time"
    val outputJSON = outFolder / "coverage.json"

    println("Generating coverage from provided inputs. Output to file " + outputJSON)

    //Read in inputs files from queue and generate list of input-coverage pairs (ignores invalid coverage)
    val queue_files = os.list(queue).filter(os.isFile)
    val startTime = getCreationTime(queue_files.head.toString)

    var invalid_files: Int = 0
    val coverageCounts: Seq[(os.Path, Seq[Byte])] = queue_files.flatMap { inputFile =>
      val in = os.read.inputStream(inputFile)
      val (coverage, valid) = target.run(in, feedbackCap)
      in.close()

      if (valid) {
        Some((inputFile, coverage))
      } else {
        invalid_files += 1
        None
      }
    }

    //Prints proportion of invalid files
    assert(
      invalid_files / queue_files.length != 1,
      s"""No inputs in ${queue} are valid! \nAre the analysis arguments reasonable for the fuzzing run being analyzed?"""
    )
    println(s"""Proportion of invalid files is ${invalid_files}/${queue_files.length}""")

    //Builds JSON file from coverage data (old)
    val out = new StringBuilder("{")
    appendCoverageDataOld(out, startTime, coverageCounts)
    out.append(", \n")
    appendEndTimeOld(out, endTimeFile, startTime)
    out.append("}")
    os.write.over(outputJSON, out.substring(0))

    println("Done!")
  }

  //Get the creation time of a produced AFL input given its filename
  def getCreationTime(filename: String): Long = {
    filename.split(',').last.toLong
  }

  //Append coverage data to JSON file
  def appendCoverageDataOld(out: StringBuilder, startTime: Long, coverageCounts: Seq[(os.Path, Seq[Byte])]): Unit = {
    var overallCoverage = Set[Int]()
    var previous_time = startTime

    out.append(s""""coverage_data": \n[""")

    val filesCovIter = coverageCounts.iterator
    while (filesCovIter.hasNext) {
      val (file, count) = filesCovIter.next()

      out.append("\t{")

      //Add filename to JSON file
      val input_name = file.toString.split("/").last
      out.append(s""""filename": "${input_name}", """)

      //Add relative creation time (seconds) to JSON file
      val creation_time = getCreationTime(file.toString())
      assert(creation_time >= previous_time, "Input creation times are not monotonically increasing")
      previous_time = creation_time

      val relative_creation_time = (creation_time - startTime) / 1000.0
      out.append(s""""creation_time": ${relative_creation_time.toString}, """)

      //Add newly covered points to current set of covered points.
      overallCoverage = overallCoverage.union(processMuxToggleCoverage(count))
      //Calculate total coverage reached cumulatively up to now. Add cumulative coverage to JSON file
      val coverPoints =
        count.size //TODO: This needs to be divided by 2 when using PseudoMuxToggleCoverage. Handle this?
      val cumulativeCoverage = overallCoverage.size.toDouble / coverPoints
      out.append(s""""cumulative_coverage": ${cumulativeCoverage.toString}""")

      out.append("}")

      if (cumulativeCoverage == 1.0 && filesCovIter.hasNext) {
        println(s"""Cumulative coverage reached 100% early. Stopping on file: $input_name""")
        return
      }

      if (filesCovIter.hasNext) {
        out.append(", \n")
      }
    }
    out.append("\n]")
  }

  //Append end time to JSON file
  def appendEndTimeOld(out: StringBuilder, endTimeFile: os.Path, startTime: Long): Unit = {
    val endTime = os.read(endTimeFile).trim.toLong
    out.append(s""""end_time": ${(endTime - startTime) / 1000.0}""")
  }

  //Handles MuxToggleCoverage. Converts COUNTS (number of times each signal toggled) to
  // COVEREDPOINTS (the set of signals which have been toggled for this input)
  def processMuxToggleCoverage(counts: Seq[Byte]): Set[Int] = {
    var coveredPoints = Set[Int]()
    for (i <- counts.indices) {
      if (counts(i) >= 1) {
        coveredPoints += i
      }
    }
    coveredPoints
  }

  //Handles PseudoMuxToggleCoverage. Converts COUNTS (number of times each signal is on or off for the given input)
  // to COVEREDPOINTS (the set of signals which were both on and off for the given input)
  def processPseudoMuxToggleCoverage(counts: Seq[Byte]): Set[Int] = {
    var coveredPoints = Set[Int]()
    for (i <- 0 until counts.length / 2) {
      if (counts(i * 2) >= 1 && counts(i * 2 + 1) >= 1) {
        coveredPoints += i
      }
    }
    coveredPoints
  }

}
# FPGA Notes

Some note that might help us re-create the FPGA flow for our artifact.


Kevin's FireSim fork: https://github.com/ekiwi/firesim/tree/coverage
 - currently based on FireSim from Jan 2021
 - 21 extra commits

## Metasim Instructions from May 17th 2021

1. download and setup chipyard on the master branch
2. add my firesim fork as a new remote and checkout the coverage branch (https://github.com/ekiwi/firesim/tree/coverage)
3. checkout the coverage repo next to chipyard: https://github.com/ekiwi/simulator-independent-coverage
4. change the default firesim design to be single clock (like you showed me some weeks ago)
5. in chipyard/sims/firesim/sim start make verilator-debug, kill the process once GoldenGate starts running
6. manually launch sbt in the chipyard root directory, like:

```
java -Xmx32G -Xss8M -jar /home/kevin/chipyard/generators/rocket-chip/sbt-launch.jar -Dsbt.sourcemode=true -Dsbt.workspace=/home/kevin/chipyard/tools
```

7. switch to firechip project firechip
8. run GoldenGate on the instrumented firrtl from our repository, like:


```
runMain midas.stage.GoldenGateMain  -o /home/kevin/chipyard/sims/firesim/sim/generated-src/f1/FireSim-FireSimRocketConfig-BaseF1Config/FPGATop.v -i /home/kevin/simulator-independent-coverage/benchmarks/chipyard/FireSim-FireSimRocketConfig-BaseF1Config/firesim.firesim.FireSim.FireSimRocketConfig.instrumented.fir -td /home/kevin/chipyard/sims/firesim/sim/generated-src/f1/FireSim-FireSimRocketConfig-BaseF1Config -faf /home/kevin/simulator-independent-coverage/benchmarks/chipyard/FireSim-FireSimRocketConfig-BaseF1Config/firesim.firesim.FireSim.FireSimRocketConfig.instrumented.anno.json -ggcp firesim.firesim -ggcs BaseF1Config --no-dedup  -E verilog 
```

There are files for different counter sizes. The default is 32-bit.

```
firesim.firesim.FireSim.FireSimRocketConfig.instrumented_16bit.fir.lo.fir  firesim.firesim.FireSim.FireSimRocketConfig.instrumented_4bit.fir.lo.fir
firesim.firesim.FireSim.FireSimRocketConfig.instrumented_1bit.fir.lo.fir   firesim.firesim.FireSim.FireSimRocketConfig.instrumented_8bit.fir.lo.fir
firesim.firesim.FireSim.FireSimRocketConfig.instrumented_2bit.fir.lo.fir   firesim.firesim.FireSim.FireSimRocketConfig.instrumented.fir
firesim.firesim.FireSim.FireSimRocketConfig.instrumented_3bit.fir.lo.firNow after we overwrote the Verilog file
```


Now after we overwrite the verilog file:

9. add the plus arg parser, like: 

```
cat ../../../generators/rocket-chip/src/main/resources/vsrc/plusarg_reader.v >> /home/kevin/chipyard/sims/firesim/sim/generated-src/f1/FireSim-FireSimRocketConfig-BaseF1Config/FPGATop.v
```

10. rerun the make command: make verilator-debug (this should not run any Scala code, but just pickup after the stage that runs GoldenGate)
11. test on the asm tests: make run-asm-tests

Afterwards you should be able to find coverage data as a JSON file in the output folder.

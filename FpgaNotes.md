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


## David's Repos

Chipyard: https://github.com/ucb-bar/chipyard/commits/firesim-coverage
- changed submodules + added new configurations


## Changes

### FireSim

[Comparison on Github](https://github.com/ekiwi/firesim/compare/ekiwi:firesim:coverage-base...coverage)

- add `sim/midas/src/main/scala/coverage/midas/CoverageBridge.scala`
- add `sim/midas/src/main/cc/bridges/coverage.cc`
- add `sim/midas/src/main/cc/bridges/coverage.h`
- change `sim/src/main/cc/firesim/firesim_top.cc` to create coverage bridge and
  add signals between serial and coverage bridge
- change `sim/firesim-lib/src/main/cc/bridges/serial.cc` and
  `sim/firesim-lib/src/main/cc/bridges/serial.h` to coordinate with coverage bridge
- change `sim/src/main/makefrag/firesim/Makefrag` to add `+cover-json` argument


In the new version of FireSim, `sim/src/main/makefrag/firesim/Makefrag`
was moved to `sim/scripts/main/makefrag/firesim/Makefrag`


[New DMA implementation](https://github.com/firesim/firesim/commit/0f5d83e37682bb664a797157ce7e00c237868f78#diff-389c41dc81ff01dda937080b6f22d2b5f6c555659b803427010757f10f10c209)

The [RemovePlusArgReader pass](https://github.com/firesim/firesim/commit/710e617ba41964baa2cfa9c64cec3ebf9bb87e04)
was removed without replacement.


Instrumentation call for FireSim:

```
/home/centos/firesim/target-design/chipyard/tools/coverage/coverage//utils/bin/firrtl \
--remove-blackbox-annos \
--remove-statement-names \
--emit-cover-info \
--cover-scan-chain 16 \
--line-coverage \
-ll info \
-i /home/centos/firesim/sim/generated-src/f1/FireSim-FireSimRocketConfig-BaseF1Config/firesim.firesim.FireSim.FireSimRocketConfig.fir \
-faf /home/centos/firesim/sim/generated-src/f1/FireSim-FireSimRocketConfig-BaseF1Config/firesim.firesim.FireSim.FireSimRocketConfig.anno.json \
-E low \
--no-dedup \
-foaf /home/centos/firesim/sim/generated-src/f1/FireSim-FireSimRocketConfig-BaseF1Config/firesim.firesim.FireSim.FireSimRocketConfig.instrumented.anno.json \
-o /home/centos/firesim/sim/generated-src/f1/FireSim-FireSimRocketConfig-BaseF1Config/firesim.firesim.FireSim.FireSimRocketConfig.instrumented.fir.lo.fir
```

Reproduce in local `sbt` shell:

```
runMain firrtl.stage.FirrtlMain --remove-blackbox-annos --emit-cover-info --cover-scan-chain 16 --line-coverage -ll info -i ../benchmarks/chipyard/FireSim-FireSimRocketConfig-BaseF1Config_NEW_1.15.1/firesim.firesim.FireSim.FireSimRocketConfig.fir -faf ../benchmarks/chipyard/FireSim-FireSimRocketConfig-BaseF1Config_NEW_1.15.1/firesim.firesim.FireSim.FireSimRocketConfig.anno.json -E low --no-dedup
```

## FireSim Flow

1. Setup AWS as described in: https://docs.fires.im/en/latest/Initial-Setup/index.html

Clone [ekiwi fork](https://github.com/ekiwi/firesim) and switch to `coverage-asplos2023` branch.

2. Build Linux: https://docs.fires.im/en/latest/Running-Simulations-Tutorial/Running-a-Single-Node-Simulation.html#building-target-software



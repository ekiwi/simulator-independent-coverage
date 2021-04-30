Obtained from chipyard `master` by executing `make verilator` in `sims/firesim/sim`.

We ensured that there is only a single clock domain by changing the config slightly:
```.diff
--- a/generators/firechip/src/main/scala/TargetConfigs.scala
+++ b/generators/firechip/src/main/scala/TargetConfigs.scala
@@ -78,7 +78,7 @@ class WithFireSimConfigTweaks extends Config(
   // at the pbus freq (above, 3.2 GHz), which is outside the range of valid DDR3 speedgrades.
   // 1 GHz matches the FASED default, using some other frequency will require
   // runnings the FASED runtime configuration generator to generate faithful DDR3 timing values.
-  new chipyard.config.WithMemoryBusFrequency(1000.0) ++
+  // new chipyard.config.WithMemoryBusFrequency(1000.0) ++
   new chipyard.config.WithAsynchrousMemoryBusCrossing ++
   new testchipip.WithAsynchronousSerialSlaveCrossing ++
   // Required: Existing FAME-1 transform cannot handle black-box clock gates
```

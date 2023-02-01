# Simulator Independent Coverage

This repository contains code to reproduce results from our ASPLOS'23
paper on "Simulator Independent Coverage for RTL Hardware Languages".
Most results can be reproduced on a standard x86 Linux computer, however,
for the FireSim performance and area/frequency results a more complicated setup
on AWS cloud FPGAs is necessary.

_Hint_: The CI runs the equivalent of the reduced Kick the Tires tests. Feel free to have a look
at the [test.yml](.github/workflows/test.yml) in case you get stuck.

## Verilator Benchmarks (Figure 7 and Table 2)


### Install Verilator

**Kick the Tires**: Do all.

The measurements for the paper were taken with Verilator version `4.034`.
While our benchmarks should work with newer Verilator versions (at least in the `4.x` generation),
they will lead to different results since various optimizations have made their way into
Verilator since we conducted our experiments.

We provide the source code for Verilator `v4.034` as part of our artifact. More info can be found [in corresponding the Readme](ext/Readme.md). To build you need to first install all build requirements.
On Ubuntu this would be:

```{.sh}
sudo apt-get install -y git make autoconf g++ flex bison libfl2 libfl-dev
```

Now you can build a local copy of Verilator. The following assumes that
`$ROOT` points to the root of the artifact repository:

```{.sh}
cd ext/verilator-4.034-src/
autoconf
./configure --prefix=$ROOT/ext/verilator-4.034
make -j8 # adjust number according to the number of cores on your machine
make install
```

To be able to use this verilator version you need to add
`ROOT/ext/verilator-4.034/bin` to your `PATH`.
When you now run `verilator --version` you should see the following output:

```{.sh}
Verilator 4.034 2020-05-03 rev UNKNOWN_REV
```

If you already have a different version of verilator installed on
your machine, please make sure to check the version every time before
you run an experiment.

### Install Hyperfine

**Kick the Tires**: Do all.

Please install `hyperfine` [following its documentation](https://github.com/sharkdp/hyperfine#installation).


### Table 2

**Kick the Tires**: run a shorter version of the script by adding `HYPERFINE_OPTS="--warmup=0 --runs=1"` to the `make` invocation

To re-create table 2, please run the following commands:

```{.sh}
verilator --version # make sure it is 4.034
cd benchmarks
make table2
cat build/table2.csv
```

Running the full version should take between 10 and 20min.

Please compare the data in the CSV file with table 2 in the paper.
Note that most numbers will be slightly off since our artifact is using
a newer version of the firrtl compiler which might include different 
optimizations. The purpose of table 2 is to give the reader a feel for
the benchmarks used. Please make sure that we accurately did that.


### Figure 7

**Kick the Tires**: run a shorter version of the script by adding `HYPERFINE_OPTS="--warmup=0 --runs=1"` to the `make` invocation

To re-create figure 7, please run the following commands:

```{.sh}
verilator --version # make sure it is 4.034
cd benchmarks
make figure7
cat build/figure7.csv
```

Running the full version should take between 1h and 2h.

Please compare the data in the CSV file with figure 7 in the paper.
Note that the CSV file contains percentage overhead in runtime when
adding the instrumentation.
Make sure that our main conclusion from Section 5.1 is supported by the numbers:
> We find that in general our instrumentation causes the same or slightly less overhead compared to Verilator's built-in coverage.

## Fuzzing (Figure 10)

### Install matplotlib and scipy

**Kick the Tires**: Do all.


On Ubuntu you can install them like this:

```{.sh}
sudo apt-get install -y python3-matplotlib python3-scipy
```

### Figure 10

**Kick the Tires**: run a shorter version of the script by adding `TIME_MIN=1 REPS=1` to the `make` invocation

Our artifact comes with a copy of the AFL source code which should be built automatically
by our Makefile:

```{.sh}
cd fuzzing
make figure10
```

This should take around `20min * 5 = 1h 40min` since we fuzz for 20 minutes and do
that 5 times in order to compute the average coverage over time.
Please open the `fuzzing.png` file and compare it to Figure 10. There will be some variation
since fuzzing is a stochastic process. Also note that Figure 10 cuts of the y-axis
bellow 70% while `fuzzing.png` shows the full y-axis.

## FireSim Integration

To reproduce our FireSim Integration results you need access to an AWS account.
While it is probably possible to reproduce our results using your [own on premise FPGAs](https://docs.fires.im/en/1.15.1/Advanced-Usage/Vitis.html)
instead of AWS, but that flow is **not officially supported** by this artifact.


### Basic AWS Setup


**Kick the Tires**: Try logging into the manager instance provided.

Please follow the following guides from the FireSim documentation:
- [1.1. First-time AWS User Setup](https://docs.fires.im/en/1.15.1/Initial-Setup/First-time-AWS-User-Setup.html)
- [1.2. Configuring Required Infrastructure in Your AWS Account](https://docs.fires.im/en/1.15.1/Initial-Setup/Configuring-Required-Infrastructure-in-Your-AWS-Account.html)
- [1.3.1. Launching a “Manager Instance”](https://docs.fires.im/en/1.15.1/Initial-Setup/Setting-up-your-Manager-Instance.html#launching-a-manager-instance) _Important:_
 **do not** setup the FireSim Repo yet, as we will be using our fork

_Note to ASPLOS'23 Reviewers:_ You can **skip the above steps** as you will be provided with the `ssh` login credentials
for a manager node that has already been setup for you.

### FireSim Download and MetaSimulation

**Kick the Tires**: Do all but stop the asm tests early.

First we need to download a fork of FireSim onto the manager node.
This fork is based on the `1.15.1` release of FireSim and contains
our extensions which adds support for the `cover` statement to `firesim`.

```{.sh}
git clone https://github.com/ekiwi/firesim.git
cd firesim
git checkout coverage-asplos2023 # make sure we are on the branch with our modifications
./build-setup.sh # answer with `y` when asked whether you want to setup an unofficial version of FireSim
```

Running the `build-setup.sh` will take several minutes.

Now we are ready to ran a simple "MetaSimulation" to check that things are working:
```{.sh}
# in the firesim directory:
source sourceme-f1-full.sh
cd sim
# generate FireSim RTL and Verilator simulation binary
make TARGET_CONFIG=CCW32_WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.QuadRocketConfig verilator
# run tests, feel free to cancel (Ctrl + C) after a couple of tests
make TARGET_CONFIG=CCW32_WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.QuadRocketConfig run-asm-tests
```

These commands will generate a FireSim simulation of a RocketChip CPU
with line coverage instrumentation and our scan-chain implementation.
The FireSim RTL is then simulated with several small RISC-V tests
using the open-source Verilator simulator.

During the test simulation you will see status messages from the coverage
implementation, like:

```
[SERIAL] starting to scan out coverage
[COVERAGE] starting to scan
[COVERAGE] done scanning
[COVERAGE] 0.497458s (14.1043% of total 3.527s simulation time) spent scanning out coverage
[SERIAL] done scanning
```

Afterwards you can see coverage counts (`*.cover.json`) in `output/f1/FireSim-FireSimRocketConfig-BaseF1Config/`.
These coverage counts were used together with the `scripts/merge_cov.py` script in this repository to reduce
the number of cover points synthesized for FireSim as described in section 5.3.
Unfortunately this process is _not automated_.

### FireSim Utilization Numbers (Figures 8 and 9)


**Kick the Tires**: Skip. This takes several hours and is only for the full evaluation.

In order to reproduce Figures 8 and 9, we need to setup the firesim manager.
You can find more information on how to enter your AWS credentials [in the FireSim documentation](https://docs.fires.im/en/1.15.1/Initial-Setup/Setting-up-your-Manager-Instance.html#completing-setup-using-the-manager).

```{.sh}
# in a fresh shell in the `firesim` directory:
source sourceme-f1-manager.sh
firesim managerinit --platform f1
```

Now we need to build an FPGA image for our instrumented Rocket and BOOM cores with different coverage counter
widths in order to determine the utilization and `f_max` numbers.

We are going to use a four core RocketChip and a single core BOOM SoC.
Please add their build configurations to `deploy/config_build_recipes.yaml`:

```
coverage_rocket_48:
    DESIGN: FireSim
    TARGET_CONFIG: CCW48_WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.QuadRocketConfig
    PLATFORM_CONFIG: WithAutoILA_F90MHz_BaseF1Config
    deploy_triplet: null
    post_build_hook: null
    metasim_customruntimeconfig: null
    bit_builder_recipe: bit-builder-recipes/f1.yaml

coverage_rocket_32:
    DESIGN: FireSim
    TARGET_CONFIG: CCW32_WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.QuadRocketConfig
    PLATFORM_CONFIG: WithAutoILA_F90MHz_BaseF1Config
    deploy_triplet: null
    post_build_hook: null
    metasim_customruntimeconfig: null
    bit_builder_recipe: bit-builder-recipes/f1.yaml

coverage_rocket_16:
    DESIGN: FireSim
    TARGET_CONFIG: CCW16_WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.QuadRocketConfig
    PLATFORM_CONFIG: WithAutoILA_F90MHz_BaseF1Config
    deploy_triplet: null
    post_build_hook: null
    metasim_customruntimeconfig: null

coverage_rocket_8:
    DESIGN: FireSim
    TARGET_CONFIG: CCW8_WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.QuadRocketConfig
    PLATFORM_CONFIG: WithAutoILA_F90MHz_BaseF1Config
    deploy_triplet: null
    post_build_hook: null
    metasim_customruntimeconfig: null
    bit_builder_recipe: bit-builder-recipes/f1.yaml

coverage_rocket_4:
    DESIGN: FireSim
    TARGET_CONFIG: CCW4_WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.QuadRocketConfig
    PLATFORM_CONFIG: WithAutoILA_F90MHz_BaseF1Config
    deploy_triplet: null
    post_build_hook: null
    metasim_customruntimeconfig: null
    bit_builder_recipe: bit-builder-recipes/f1.yaml

coverage_rocket_2:
    DESIGN: FireSim
    TARGET_CONFIG: CCW2_WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.QuadRocketConfig
    PLATFORM_CONFIG: WithAutoILA_F90MHz_BaseF1Config
    deploy_triplet: null
    post_build_hook: null
    metasim_customruntimeconfig: null
    bit_builder_recipe: bit-builder-recipes/f1.yaml

coverage_rocket_1:
    DESIGN: FireSim
    TARGET_CONFIG: CCW1_WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.QuadRocketConfig
    PLATFORM_CONFIG: WithAutoILA_F90MHz_BaseF1Config
    deploy_triplet: null
    post_build_hook: null
    metasim_customruntimeconfig: null
    bit_builder_recipe: bit-builder-recipes/f1.yaml

coverage_rocket_baseline:
    DESIGN: FireSim
    TARGET_CONFIG: WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.QuadRocketConfig
    PLATFORM_CONFIG: WithAutoILA_F90MHz_BaseF1Config
    deploy_triplet: null
    post_build_hook: null
    metasim_customruntimeconfig: null
    bit_builder_recipe: bit-builder-recipes/f1.yaml

coverage_boom_48:
    DESIGN: FireSim
    TARGET_CONFIG: CCW48_WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.LargeBoomConfig
    PLATFORM_CONFIG: WithAutoILA_F65MHz_BaseF1Config
    deploy_triplet: null
    post_build_hook: null
    metasim_customruntimeconfig: null
    bit_builder_recipe: bit-builder-recipes/f1.yaml

coverage_boom_32:
    DESIGN: FireSim
    TARGET_CONFIG: CCW32_WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.LargeBoomConfig
    PLATFORM_CONFIG: WithAutoILA_F65MHz_BaseF1Config
    deploy_triplet: null
    post_build_hook: null
    metasim_customruntimeconfig: null
    bit_builder_recipe: bit-builder-recipes/f1.yaml

coverage_boom_16:
    DESIGN: FireSim
    TARGET_CONFIG: CCW16_WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.LargeBoomConfig
    PLATFORM_CONFIG: WithAutoILA_F65MHz_BaseF1Config
    deploy_triplet: null
    post_build_hook: null
    metasim_customruntimeconfig: null
    bit_builder_recipe: bit-builder-recipes/f1.yaml

coverage_boom_8:
    DESIGN: FireSim
    TARGET_CONFIG: CCW8_WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.LargeBoomConfig
    PLATFORM_CONFIG: WithAutoILA_F65MHz_BaseF1Config
    deploy_triplet: null
    post_build_hook: null
    metasim_customruntimeconfig: null
    bit_builder_recipe: bit-builder-recipes/f1.yaml

coverage_boom_4:
    DESIGN: FireSim
    TARGET_CONFIG: CCW4_WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.LargeBoomConfig
    PLATFORM_CONFIG: WithAutoILA_F65MHz_BaseF1Config
    deploy_triplet: null
    post_build_hook: null
    metasim_customruntimeconfig: null
    bit_builder_recipe: bit-builder-recipes/f1.yaml

coverage_boom_2:
    DESIGN: FireSim
    TARGET_CONFIG: CCW2_WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.LargeBoomConfig
    PLATFORM_CONFIG: WithAutoILA_F65MHz_BaseF1Config
    deploy_triplet: null
    post_build_hook: null
    metasim_customruntimeconfig: null
    bit_builder_recipe: bit-builder-recipes/f1.yaml

coverage_boom_1:
    DESIGN: FireSim
    TARGET_CONFIG: CCW1_WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.LargeBoomConfig
    PLATFORM_CONFIG: WithAutoILA_F65MHz_BaseF1Config
    deploy_triplet: null
    post_build_hook: null
    metasim_customruntimeconfig: null
    bit_builder_recipe: bit-builder-recipes/f1.yaml

coverage_boom_baseline:
    DESIGN: FireSim
    TARGET_CONFIG: WithDefaultFireSimBridges_WithFireSimConfigTweaks_chipyard.LargeBoomConfig
    PLATFORM_CONFIG: WithAutoILA_F65MHz_BaseF1Config
    deploy_triplet: null
    post_build_hook: null
    metasim_customruntimeconfig: null
    bit_builder_recipe: bit-builder-recipes/f1.yaml
```

Now add all the configs in `deploy/config_build.yaml` under `builds_to_run:` and comment out the 
once that were already in the file.
To start building all designs, run the following command: `firesim buildbitstream`
You will be notified via email once the virtual machine with the RTL design is built.

You should compare the utilization and frequency numbers to the ones presented in Figures 8 and 9 in the paper.
In case there are any problems, you can find more info on building AFIs in
[the FireSim documentation](https://docs.fires.im/en/1.15.1/Building-a-FireSim-AFI.html).


### Linux Boot Speed

We are still ironing out some bugs in order to allow you to reproduce the following claim:
> We used our instrumented SoCs with 16-bit coverage counters to boot Linux and obtained line coverage results. For the RocketChip design the simulation executed 3.3B cycles in 50.4s (65 MHz). Scanning out the 8060 cover counts at the end of the simulation took 12ms. For the BOOM design the simulation executed 1.7B cycles in 42.6s (40 MHz). Scanning out the 12059 cover counts at the end of the simulation took 17ms.
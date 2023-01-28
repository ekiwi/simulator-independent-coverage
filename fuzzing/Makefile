# change the time and repetition to make things faster
TIME_MIN := 20
REPS := 5

# our fork of AFL
AFL_PATH := ../ext/afl
AFL = $(AFL_PATH)/afl-fuzz

$(AFL):
	cd $(AFL_PATH) && make afl-fuzz

# AFL proxy to interface our JVM code with AFL
# copied over from the JQF project
AFL_PROXY = afl-proxy/afl-proxy

$(AFL_PROXY): afl-proxy/afl-proxy.c afl-proxy/afl-proxy.h
	cd afl-proxy && make

# Scala JAR that contains the instrumentation and fuzzing adapter code
SCALA_SRC = $(shell find ../coverage/src -type f) $(shell find src -type f)
JAR = target/scala-2.12/rtl-fuzz-lab-assembly-0.1.jar

$(JAR): $(SCALA_SRC)
	sbt assembly


# we use fifos to communicate between JVM fuzz server and the native AFL proxy
a2j:
	mkfifo a2j
j2a:
	mkfifo j2a

FIFOS = a2j j2a

# all fuzzing dependencies
FUZZ_DEPS = $(JAR) $(AFL) $(AFL_PROXY) $(FIFOS)


i2c-mux-toggle: $(FUZZ_DEPS)
	rm -rf $@
	./fuzz.py --time=$(TIME_MIN) --folder=$@ --iterations=$(REPS) --afl-path=$(AFL_PATH) --seed=RFUZZ_longSeed.hwf -- \
	--FIRRTL=benchmarks/TLI2C.fir --Harness=rfuzz --mux-toggle-coverage --Feedback=255 --Directed

i2c-line-cov: $(FUZZ_DEPS)
	rm -rf $@
	./fuzz.py --time=$(TIME_MIN) --folder=$@ --iterations=$(REPS) --afl-path=$(AFL_PATH) --seed=RFUZZ_longSeed.hwf -- \
	--FIRRTL=benchmarks/TLI2C.fir --Harness=rfuzz --line-coverage --Feedback=255 --Directed

i2c-mux-and-line-cov: $(FUZZ_DEPS)
	rm -rf $@
	./fuzz.py --time=$(TIME_MIN) --folder=$@ --iterations=$(REPS) --afl-path=$(AFL_PATH) --seed=RFUZZ_longSeed.hwf -- \
	--FIRRTL=benchmarks/TLI2C.fir --Harness=rfuzz --line-coverage --mux-toggle-coverage --Feedback=255 --Directed

figure10: i2c-mux-toggle i2c-line-cov i2c-mux-and-line-cov
	echo "TODO"


.PHONY: figure10

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

# small fuzzing run to make sure everything works
kick_the_tires: $(FUZZ_DEPS)
	rm -rf out
	./fuzz.py --time=1 --folder=out --iterations=1 --afl-path=$(AFL_PATH) --seed=RFUZZ_longSeed.hwf -- \
	--FIRRTL=benchmarks/TLI2C.fir --Harness=rfuzz --mux-toggle-coverage --Feedback=255

.PHONY: kick_the_tires

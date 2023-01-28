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
COVERAGE = java -cp $(JAR) fuzzing.FuzzLab 

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

# run fuzzer with different coverage
CONFIGS = i2c-mux-toggle i2c-line-cov i2c-mux-and-line-cov

# the number of fuzzer outputs depends on the number of reps
REPS_MINUS_ONE = $(shell echo ${REPS}-1 | bc)
OUT_SEQ = $(shell seq 0 $(REPS_MINUS_ONE))
OUTS = $(addsuffix .out, $(OUT_SEQ))

MUX_TOGGLE = $(addprefix i2c-mux-toggle/, $(OUTS))
LINE_COV = $(addprefix i2c-line-cov/, $(OUTS))
MUX_AND_LINE = $(addprefix i2c-mux-and-line-cov/, $(OUTS))

$(MUX_TOGGLE): $(FUZZ_DEPS)
	rm -rf i2c-mux-toggle
	./fuzz.py --time=$(TIME_MIN) --folder=i2c-mux-toggle --iterations=$(REPS) --afl-path=$(AFL_PATH) --seed=RFUZZ_longSeed.hwf -- \
	--FIRRTL=benchmarks/TLI2C.fir --Harness=rfuzz --mux-toggle-coverage --Feedback=255 --Directed

$(LINE_COV): $(FUZZ_DEPS)
	rm -rf i2c-line-cov
	./fuzz.py --time=$(TIME_MIN) --folder=i2c-line-cov --iterations=$(REPS) --afl-path=$(AFL_PATH) --seed=RFUZZ_longSeed.hwf -- \
	--FIRRTL=benchmarks/TLI2C.fir --Harness=rfuzz --line-coverage --Feedback=255 --Directed

$(MUX_AND_LINE): $(FUZZ_DEPS)
	rm -rf i2c-mux-and-line-cov
	./fuzz.py --time=$(TIME_MIN) --folder=i2c-mux-and-line-cov --iterations=$(REPS) --afl-path=$(AFL_PATH) --seed=RFUZZ_longSeed.hwf -- \
	--FIRRTL=benchmarks/TLI2C.fir --Harness=rfuzz --line-coverage --mux-toggle-coverage --Feedback=255 --Directed

# analyze fuzzer generated inputs, all using line coverage
%.out/coverage.json: %.out $(FUZZ_DEPS)
	$(COVERAGE) --analysis --Folder=$(dir $@) --FIRRTL=benchmarks/TLI2C.fir --Harness=rfuzz --line-coverage --Feedback=255 --Directed


# the number of coverage JSONs depends on the repetitions
ALL_COVERAGE_DIRS = $(MUX_TOGGLE) $(LINE_COV) $(MUX_AND_LINE)
ALL_COVERAGE_JSONS = $(addsuffix /coverage.json, $(ALL_COVERAGE_DIRS))

fuzzing.csv fuzzing.png: $(ALL_COVERAGE_JSONS)
	./plot_coverage.py --do-average --plot-file=fuzzing.png --csv=fuzzing.csv $(CONFIGS)


figure10: fuzzing.csv
	echo "TODO"


clean: # does not actually clean external dependencies!
	rm -rf i2c-mux-toggle
	rm -rf i2c-line-cov
	rm -rf i2c-mux-and-line-cov
	rm -f fuzzing.png fuzzing.csv

.PHONY: figure10 clean

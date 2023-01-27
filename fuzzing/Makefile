AFL_PATH := ../../AFL_rtl_fuzz_lab



# small fuzzing run to make sure everything works
kick_the_tires:
	rm -rf out
	./fuzz.py --time=1 --folder=out --iterations=1 --afl-path=$(AFL_PATH) --seed=RFUZZ_longSeed.hwf -- \
	--FIRRTL=benchmarks/TLI2C.fir --Harness=rfuzz --mux-toggle-coverage --Feedback=255

.PHONY: kick_the_tires

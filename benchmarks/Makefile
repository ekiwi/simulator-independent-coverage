LL := warn
BUILD_DIR := build
firrtl_jar = ../coverage/utils/bin/firrtl.jar
firrtl_bin = ../coverage/utils/bin/firrtl -ll ${LL}
firrtl_bin_info = ../coverage/utils/bin/firrtl -ll info
firrtl_srcs = $(shell find ../coverage/src -type f)
$(firrtl_jar): $(firrtl_srcs)
	cd ../coverage && sbt assembly
firrtl: $(firrtl_jar)

# user coverage is awlays enabled since the baseline has no user cover points and the firrtl instrumentation adds user cover points
VERILATOR = verilator -Wno-WIDTH --coverage-user --cc --exe --build

ALL_COV = --line-coverage --toggle-coverage --fsm-coverage --ready-valid-coverage --emit-cover-info
LINE_COV = --line-coverage --emit-cover-info
TOGGLE_COV = --toggle-coverage --emit-cover-info
READY_VALID_COV = --ready-valid-coverage --emit-cover-info
FSM_COV = --fsm-coverage --emit-cover-info


BENCH_OPTS = baseline firrtl_line native_line firrtl_toggle native_toggle firrtl_all firrtl_fsm firrtl_ready_valid
CIRCUIT_NAMES = NeuromorphicProcessor TLRAM serv riscv_mini


$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)/*


### Neurmorphic Processor

# different coverage instrumentation
$(BUILD_DIR)/NeuromorphicProcessor_baseline.sv: NeuromorphicProcessor/NeuromorphicProcessor.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog -o $@

$(BUILD_DIR)/NeuromorphicProcessor_firrtl_line.sv: NeuromorphicProcessor/NeuromorphicProcessor.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(LINE_COV) -o $@

$(BUILD_DIR)/NeuromorphicProcessor_firrtl_toggle.sv: NeuromorphicProcessor/NeuromorphicProcessor.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(TOGGLE_COV) -o $@

$(BUILD_DIR)/NeuromorphicProcessor_firrtl_ready_valid.sv: NeuromorphicProcessor/NeuromorphicProcessor.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(READY_VALID_COV) -o $@

$(BUILD_DIR)/NeuromorphicProcessor_firrtl_fsm.sv: NeuromorphicProcessor/NeuromorphicProcessor.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(FSM_COV) -o $@

$(BUILD_DIR)/NeuromorphicProcessor_firrtl_all.sv: NeuromorphicProcessor/NeuromorphicProcessor.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(ALL_COV) -o $@

# print some info on coverage instrumentation
$(BUILD_DIR)/NeuromorphicProcessor_coverage.txt: NeuromorphicProcessor/NeuromorphicProcessor.fir $(firrtl_jar)
	$(firrtl_bin_info) -i $< -E sverilog $(ALL_COV) -o $(BUILD_DIR)/NeuromorphicProcessor_firrtl_all.sv > $@


# copy over testbench file (somehow verilator has trouble with input files in different directories)
$(BUILD_DIR)/NeuromorphicProcessor.cc: NeuromorphicProcessor/testbench.cc
	cp $< $@

# build executable simulation of instrumented files with verilator
$(BUILD_DIR)/NeuromorphicProcessor_baseline.bin: $(BUILD_DIR)/NeuromorphicProcessor_baseline.sv $(BUILD_DIR)/NeuromorphicProcessor.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../NeuromorphicProcessor --top-module NeuromorphicProcessor -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

$(BUILD_DIR)/NeuromorphicProcessor_firrtl_%.bin: $(BUILD_DIR)/NeuromorphicProcessor_firrtl_%.sv $(BUILD_DIR)/NeuromorphicProcessor.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../NeuromorphicProcessor --top-module NeuromorphicProcessor -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

# build the baseline Verilog with native verilator instrumentation for comparison
$(BUILD_DIR)/NeuromorphicProcessor_native_line.bin: $(BUILD_DIR)/NeuromorphicProcessor_baseline.sv $(BUILD_DIR)/NeuromorphicProcessor.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../NeuromorphicProcessor --top-module NeuromorphicProcessor --coverage-line -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

$(BUILD_DIR)/NeuromorphicProcessor_native_toggle.bin: $(BUILD_DIR)/NeuromorphicProcessor_baseline.sv $(BUILD_DIR)/NeuromorphicProcessor.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../NeuromorphicProcessor --top-module NeuromorphicProcessor --coverage-toggle -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

$(BUILD_DIR)/NeuromorphicProcessor_native_all.bin: $(BUILD_DIR)/NeuromorphicProcessor_baseline.sv $(BUILD_DIR)/NeuromorphicProcessor.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../NeuromorphicProcessor --top-module NeuromorphicProcessor --coverage-line --coverage-toggle -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

# extract inputs for benchmarking
$(BUILD_DIR)/NeuromorphicProcessor_inputs.txt: NeuromorphicProcessor/inputs.txt.gz
	gzip -dk $<
	mv NeuromorphicProcessor/inputs.txt $@

# pseudo target to compile all binaries
NeuromorphicProcessor_all_bin: $(addsuffix .bin, $(addprefix $(BUILD_DIR)/NeuromorphicProcessor_, $(BENCH_OPTS))) $(BUILD_DIR)/NeuromorphicProcessor_inputs.txt
	echo "done"



#### TL-RAM Benchmark

# different coverage instrumentation
$(BUILD_DIR)/TLRAM_baseline.sv: TLRAM/TLRAMStandalone.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog -o $@

$(BUILD_DIR)/TLRAM_firrtl_line.sv: TLRAM/TLRAMStandalone.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(LINE_COV) -o $@

$(BUILD_DIR)/TLRAM_firrtl_toggle.sv: TLRAM/TLRAMStandalone.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(TOGGLE_COV) -o $@

$(BUILD_DIR)/TLRAM_firrtl_ready_valid.sv: TLRAM/TLRAMStandalone.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(READY_VALID_COV) -o $@

$(BUILD_DIR)/TLRAM_firrtl_fsm.sv: TLRAM/TLRAMStandalone.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(FSM_COV) -o $@

$(BUILD_DIR)/TLRAM_firrtl_all.sv: TLRAM/TLRAMStandalone.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(ALL_COV) -o $@

# print some info on coverage instrumentation
$(BUILD_DIR)/TLRAM_coverage.txt: TLRAM/TLRAMStandalone.fir $(firrtl_jar)
	$(firrtl_bin_info) -i $< -E sverilog $(ALL_COV) -o $(BUILD_DIR)/TLRAM_firrtl_all.sv > $@

# copy over testbench file (somehow verilator has trouble with input files in different directories)
$(BUILD_DIR)/TLRAM.cc: TLRAM/TLRAMStandalone.cpp
	cp $< $@

# build executable simulation of instrumented files with verilator
$(BUILD_DIR)/TLRAM_baseline.bin: $(BUILD_DIR)/TLRAM_baseline.sv $(BUILD_DIR)/TLRAM.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../TLRAM --top-module TLRAMStandalone -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

$(BUILD_DIR)/TLRAM_firrtl_%.bin: $(BUILD_DIR)/TLRAM_firrtl_%.sv $(BUILD_DIR)/TLRAM.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../TLRAM --top-module TLRAMStandalone -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

# build the baseline Verilog with native verilator instrumentation for comparison
$(BUILD_DIR)/TLRAM_native_line.bin: $(BUILD_DIR)/TLRAM_baseline.sv $(BUILD_DIR)/TLRAM.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../TLRAM --top-module TLRAMStandalone --coverage-line -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

$(BUILD_DIR)/TLRAM_native_toggle.bin: $(BUILD_DIR)/TLRAM_baseline.sv $(BUILD_DIR)/TLRAM.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../TLRAM --top-module TLRAMStandalone --coverage-toggle -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

$(BUILD_DIR)/TLRAM_native_all.bin: $(BUILD_DIR)/TLRAM_baseline.sv $(BUILD_DIR)/TLRAM.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../TLRAM --top-module TLRAMStandalone --coverage-line --coverage-toggle -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

# extract inputs for benchmarking
$(BUILD_DIR)/TLRAM_inputs.txt: TLRAM/inputs.txt.gz $(BUILD_DIR)
	gzip -dk $<
	mv TLRAM/inputs.txt $@

# pseudo target to compile all binaries
TLRAM_all_bin: $(addsuffix .bin, $(addprefix $(BUILD_DIR)/TLRAM_, $(BENCH_OPTS))) $(BUILD_DIR)/TLRAM_inputs.txt
	echo "done"


#### serv Benchmark

# different coverage instrumentation
$(BUILD_DIR)/serv_baseline.sv: serv-chisel/ServTopWithRam.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog -o $@

$(BUILD_DIR)/serv_firrtl_line.sv: serv-chisel/ServTopWithRam.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(LINE_COV) -o $@

$(BUILD_DIR)/serv_firrtl_toggle.sv: serv-chisel/ServTopWithRam.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(TOGGLE_COV) -o $@

$(BUILD_DIR)/serv_firrtl_ready_valid.sv: serv-chisel/ServTopWithRam.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(READY_VALID_COV) -o $@

$(BUILD_DIR)/serv_firrtl_fsm.sv: serv-chisel/ServTopWithRam.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(FSM_COV) -o $@

$(BUILD_DIR)/serv_firrtl_all.sv: serv-chisel/ServTopWithRam.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(ALL_COV) -o $@

# print some info on coverage instrumentation
$(BUILD_DIR)/serv_coverage.txt: serv-chisel/ServTopWithRam.fir $(firrtl_jar)
	$(firrtl_bin_info) -i $< -E sverilog $(ALL_COV) -o $(BUILD_DIR)/serv_firrtl_all.sv > $@

# copy over testbench file (somehow verilator has trouble with input files in different directories)
$(BUILD_DIR)/serv.cc: serv-chisel/testbench.cc
	cp $< $@

# build executable simulation of instrumented files with verilator
$(BUILD_DIR)/serv_baseline.bin: $(BUILD_DIR)/serv_baseline.sv $(BUILD_DIR)/serv.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../serv --top-module ServTopWithRam -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

$(BUILD_DIR)/serv_firrtl_%.bin: $(BUILD_DIR)/serv_firrtl_%.sv $(BUILD_DIR)/serv.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../serv --top-module ServTopWithRam -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

# build the baseline Verilog with native verilator instrumentation for comparison
$(BUILD_DIR)/serv_native_line.bin: $(BUILD_DIR)/serv_baseline.sv $(BUILD_DIR)/serv.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../serv --top-module ServTopWithRam --coverage-line -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

$(BUILD_DIR)/serv_native_toggle.bin: $(BUILD_DIR)/serv_baseline.sv $(BUILD_DIR)/serv.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../serv --top-module ServTopWithRam --coverage-toggle -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

$(BUILD_DIR)/serv_native_all.bin: $(BUILD_DIR)/serv_baseline.sv $(BUILD_DIR)/serv.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../serv --top-module ServTopWithRam --coverage-line --coverage-toggle -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

# extract inputs for benchmarking
$(BUILD_DIR)/serv_inputs.txt: serv-chisel/inputs.txt.gz
	gzip -dk $<
	mv serv-chisel/inputs.txt $@

# pseudo target to compile all binaries
serv_all_bin: $(addsuffix .bin, $(addprefix $(BUILD_DIR)/serv_, $(BENCH_OPTS))) $(BUILD_DIR)/serv_inputs.txt
	echo "done"



#### RISCV-Mini Benchmark

# different coverage instrumentation
$(BUILD_DIR)/riscv_mini_baseline.sv: riscv-mini/TileTester_BmarkTestsmedian.riscv/TileTester.fir riscv-mini/TileTester_BmarkTestsmedian.riscv/TileTester.anno.json $(firrtl_jar)
	$(firrtl_bin) -i $< -faf $(filter %.anno.json, $^) -E sverilog -o $@

$(BUILD_DIR)/riscv_mini_firrtl_line.sv: riscv-mini/TileTester_BmarkTestsmedian.riscv/TileTester.fir riscv-mini/TileTester_BmarkTestsmedian.riscv/TileTester.anno.json  $(firrtl_jar)
	$(firrtl_bin) -i $< -faf $(filter %.anno.json, $^) -E sverilog $(LINE_COV) -o $@

$(BUILD_DIR)/riscv_mini_firrtl_toggle.sv: riscv-mini/TileTester_BmarkTestsmedian.riscv/TileTester.fir riscv-mini/TileTester_BmarkTestsmedian.riscv/TileTester.anno.json  $(firrtl_jar)
	$(firrtl_bin) -i $< -faf $(filter %.anno.json, $^) -E sverilog $(TOGGLE_COV) -o $@

$(BUILD_DIR)/riscv_mini_firrtl_ready_valid.sv: riscv-mini/TileTester_BmarkTestsmedian.riscv/TileTester.fir riscv-mini/TileTester_BmarkTestsmedian.riscv/TileTester.anno.json  $(firrtl_jar)
	$(firrtl_bin) -i $< -faf $(filter %.anno.json, $^) -E sverilog $(READY_VALID_COV) -o $@

$(BUILD_DIR)/riscv_mini_firrtl_fsm.sv: riscv-mini/TileTester_BmarkTestsmedian.riscv/TileTester.fir riscv-mini/TileTester_BmarkTestsmedian.riscv/TileTester.anno.json  $(firrtl_jar)
	$(firrtl_bin) -i $< -faf $(filter %.anno.json, $^) -E sverilog $(FSM_COV) -o $@

$(BUILD_DIR)/riscv_mini_firrtl_all.sv: riscv-mini/TileTester_BmarkTestsmedian.riscv/TileTester.fir riscv-mini/TileTester_BmarkTestsmedian.riscv/TileTester.anno.json  $(firrtl_jar)
	$(firrtl_bin) -i $< -faf $(filter %.anno.json, $^) -E sverilog $(ALL_COV) -o $@

# print some info on coverage instrumentation
$(BUILD_DIR)/riscv_mini_coverage.txt:  riscv-mini/TileTester_BmarkTestsmedian.riscv/TileTester.fir riscv-mini/TileTester_BmarkTestsmedian.riscv/TileTester.anno.json  $(firrtl_jar)
	$(firrtl_bin_info) -i $< -faf $(filter %.anno.json, $^) -E sverilog $(ALL_COV) -o $(BUILD_DIR)/riscv_mini_firrtl_all.sv > $@


# # copy over testbench file (somehow verilator has trouble with input files in different directories)
$(BUILD_DIR)/riscv_mini.cc: riscv-mini/testbench.cc
	cp $< $@

# build executable simulation of instrumented files with verilator
$(BUILD_DIR)/riscv_mini_baseline.bin: $(BUILD_DIR)/riscv_mini_baseline.sv $(BUILD_DIR)/riscv_mini.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) -CFLAGS "-DVL_USER_FINISH" --Mdir $(notdir $(basename $@)) -I../riscv_mini --top-module TileTester -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

$(BUILD_DIR)/riscv_mini_firrtl_%.bin: $(BUILD_DIR)/riscv_mini_firrtl_%.sv $(BUILD_DIR)/riscv_mini.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) -CFLAGS "-DVL_USER_FINISH" --Mdir $(notdir $(basename $@)) -I../riscv_mini --top-module TileTester -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

# build the baseline Verilog with native verilator instrumentation for comparison
$(BUILD_DIR)/riscv_mini_native_line.bin: $(BUILD_DIR)/riscv_mini_baseline.sv $(BUILD_DIR)/riscv_mini.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) -CFLAGS "-DVL_USER_FINISH" --Mdir $(notdir $(basename $@)) -I../riscv_mini --top-module TileTester --coverage-line -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

$(BUILD_DIR)/riscv_mini_native_toggle.bin: $(BUILD_DIR)/riscv_mini_baseline.sv $(BUILD_DIR)/riscv_mini.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) -CFLAGS "-DVL_USER_FINISH" --Mdir $(notdir $(basename $@)) -I../riscv_mini --top-module TileTester --coverage-toggle -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

$(BUILD_DIR)/riscv_mini_native_all.bin: $(BUILD_DIR)/riscv_mini_baseline.sv $(BUILD_DIR)/riscv_mini.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) -CFLAGS "-DVL_USER_FINISH" --Mdir $(notdir $(basename $@)) -I../riscv_mini --top-module TileTester --coverage-line --coverage-toggle -o sim
	rm -f $@ && ln -s $(notdir $(basename $@))/sim $@

# create a dummy inputs file (riscv-mini is a self contained testbench)
$(BUILD_DIR)/riscv_mini_inputs.txt:
	echo "" > $@

# pseudo target to compile all binaries
riscv_mini_all_bin: $(addsuffix .bin, $(addprefix $(BUILD_DIR)/riscv_mini_, $(BENCH_OPTS))) $(BUILD_DIR)/riscv_mini_inputs.txt
	echo "done"


############ Benchmarking with Hyperfine
# # https://stackoverflow.com/questions/5618615/check-if-a-program-exists-from-a-makefile
HYPERFINE := $(shell command -v hyperfine 2> /dev/null)


$(BUILD_DIR)/%_results.csv: $(addsuffix .bin, $(addprefix $(BUILD_DIR)/%_, $(BENCH_OPTS))) $(BUILD_DIR)/%_inputs.txt
ifndef HYPERFINE
	$(error "install hyperfine: https://github.com/sharkdp/hyperfine")
endif
	cd $(BUILD_DIR) && \
	hyperfine --export-csv $(notdir $@) $(addprefix ./, $(filter %.bin, $(notdir $^)))


# run once for a quick test
%_run_once: $(addsuffix .bin, $(addprefix $(BUILD_DIR)/%_, $(BENCH_OPTS))) $(BUILD_DIR)/%_inputs.txt
ifndef HYPERFINE
	$(error "install hyperfine: https://github.com/sharkdp/hyperfine")
endif
	cd $(BUILD_DIR) && \
	hyperfine --warmup 0 --max-runs 1 $(addprefix ./, $(filter %.bin, $(notdir $^)))


# figure 7
BENCH_RESULTS = $(addprefix $(BUILD_DIR)/,$(addsuffix _results.csv, $(CIRCUIT_NAMES)))
$(BUILD_DIR)/figure7_verilator_overhead_small.csv $(BUILD_DIR)/figure7_verilator_overhead_large.csv: $(BENCH_RESULTS) figure7.py
	./figure7.py

figure7: $(BUILD_DIR)/figure7_verilator_overhead_small.csv $(BUILD_DIR)/figure7_verilator_overhead_large.csv


# cycle count
$(BUILD_DIR)/%_cycles.txt: $(BUILD_DIR)/%_baseline.bin $(BUILD_DIR)/%_inputs.txt
	cd $(BUILD_DIR) && ./$(filter %.bin, $(notdir $^)) > $(notdir $@)

# table 2
$(BUILD_DIR)/%_baseline_results.csv: $(BUILD_DIR)/%_baseline.bin $(BUILD_DIR)/%_inputs.txt
ifndef HYPERFINE
	$(error "install hyperfine: https://github.com/sharkdp/hyperfine")
endif
	cd $(BUILD_DIR) && \
	hyperfine --export-csv $(notdir $@) $(addprefix ./, $(filter %.bin, $(notdir $^)))


COVERAGE_TXT = $(addprefix $(BUILD_DIR)/,$(addsuffix _coverage.txt, $(CIRCUIT_NAMES))) 
BASELINE_PERF = $(addprefix $(BUILD_DIR)/,$(addsuffix _baseline_results.csv, $(CIRCUIT_NAMES)))
CYCLE_COUNTS = $(addprefix $(BUILD_DIR)/,$(addsuffix _cycles.txt, $(CIRCUIT_NAMES)))
$(BUILD_DIR)/table2.csv: $(COVERAGE_TXT) $(BASELINE_PERF) $(CYCLE_COUNTS) table2.py
	./table2.py

table2: $(BUILD_DIR)/table2.csv



.PHONY: firrtl clean $(addsuffix _all_bin, $(CIRCUIT_NAMES)) figure7 table2
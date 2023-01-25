LL := warn
BUILD_DIR := build
firrtl_jar = ../coverage/utils/bin/firrtl.jar
firrtl_bin = ../coverage/utils/bin/firrtl -ll ${LL}
firrtl_srcs = $(shell find ../coverage/src -type f)
$(firrtl_jar): $(firrtl_srcs)
	cd ../coverage && sbt assembly
firrtl: $(firrtl_jar)

# user coverage is awlays enabled since the baseline has no user cover points and the firrtl instrumentation adds user cover points
VERILATOR = verilator -Wno-WIDTH --coverage-user --cc --exe --build

ALL_COV = --line-coverage --toggle-coverage --fsm-coverage --ready-valid-coverage --emit-cover-info
LINE_COV = --line-coverage --emit-cover-info
TOGGLE_COV = --toggle-coverage --emit-cover-info

BENCH_OPTS = baseline firrtl_line native_line firrtl_toggle native_toggle firrtl_all

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)


### Neurmorphic Processor

# different coverage instrumentation
$(BUILD_DIR)/NeuromorphicProcessor_baseline.sv: NeuromorphicProcessor/NeuromorphicProcessor.fir $(firrtl_jar) $(BUILD_DIR)
	$(firrtl_bin) -i $< -E sverilog -o $@

$(BUILD_DIR)/NeuromorphicProcessor_firrtl_line.sv: NeuromorphicProcessor/NeuromorphicProcessor.fir $(firrtl_jar) $(BUILD_DIR)
	$(firrtl_bin) -i $< -E sverilog $(LINE_COV) -o $@

$(BUILD_DIR)/NeuromorphicProcessor_firrtl_toggle.sv: NeuromorphicProcessor/NeuromorphicProcessor.fir $(firrtl_jar) $(BUILD_DIR)
	$(firrtl_bin) -i $< -E sverilog $(TOGGLE_COV) -o $@

$(BUILD_DIR)/NeuromorphicProcessor_firrtl_all.sv: NeuromorphicProcessor/NeuromorphicProcessor.fir $(firrtl_jar) $(BUILD_DIR)
	$(firrtl_bin) -i $< -E sverilog $(ALL_COV) -o $@

# copy over testbench file (somehow verilator has trouble with input files in different directories)
$(BUILD_DIR)/NeuromorphicProcessor.cc: NeuromorphicProcessor/testbench.cc $(BUILD_DIR)
	cp $< $@

# build executable simulation of instrumented files with verilator
$(BUILD_DIR)/NeuromorphicProcessor_baseline.bin: $(BUILD_DIR)/NeuromorphicProcessor_baseline.sv $(BUILD_DIR)/NeuromorphicProcessor.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../NeuromorphicProcessor --top-module NeuromorphicProcessor
	rm -f $@ && ln -s $(notdir $(basename $@))/VNeuromorphicProcessor $@

$(BUILD_DIR)/NeuromorphicProcessor_firrtl_%.bin: $(BUILD_DIR)/NeuromorphicProcessor_firrtl_%.sv $(BUILD_DIR)/NeuromorphicProcessor.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../NeuromorphicProcessor --top-module NeuromorphicProcessor
	rm -f $@ && ln -s $(notdir $(basename $@))/VNeuromorphicProcessor $@

# build the baseline Verilog with native verilator instrumentation for comparison
$(BUILD_DIR)/NeuromorphicProcessor_native_line.bin: $(BUILD_DIR)/NeuromorphicProcessor_baseline.sv $(BUILD_DIR)/NeuromorphicProcessor.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../NeuromorphicProcessor --top-module NeuromorphicProcessor --coverage-line
	rm -f $@ && ln -s $(notdir $(basename $@))/VNeuromorphicProcessor $@

$(BUILD_DIR)/NeuromorphicProcessor_native_toggle.bin: $(BUILD_DIR)/NeuromorphicProcessor_baseline.sv $(BUILD_DIR)/NeuromorphicProcessor.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../NeuromorphicProcessor --top-module NeuromorphicProcessor --coverage-toggle
	rm -f $@ && ln -s $(notdir $(basename $@))/VNeuromorphicProcessor $@

$(BUILD_DIR)/NeuromorphicProcessor_native_all.bin: $(BUILD_DIR)/NeuromorphicProcessor_baseline.sv $(BUILD_DIR)/NeuromorphicProcessor.cc
	cd $(BUILD_DIR) && \
	 $(VERILATOR) $(notdir $^) --Mdir $(notdir $(basename $@)) -I../NeuromorphicProcessor --top-module NeuromorphicProcessor --coverage-line --coverage-toggle
	rm -f $@ && ln -s $(notdir $(basename $@))/VNeuromorphicProcessor $@

# extract inputs for benchmarking
$(BUILD_DIR)/NeuromorphicProcessor_inputs.txt: NeuromorphicProcessor/inputs.txt.gz $(BUILD_DIR)
	gzip -dk $<
	mv NeuromorphicProcessor/inputs.txt $@

# pseudo target to compile all binaries
NeuromorphicProcessor_all_bin: $(addsuffix .bin, $(addprefix $(BUILD_DIR)/NeuromorphicProcessor_, $(BENCH_OPTS)))
	echo "done"

############ Benchmarking with Hyperfine
# # https://stackoverflow.com/questions/5618615/check-if-a-program-exists-from-a-makefile
HYPERFINE := $(shell command -v hyperfine 2> /dev/null)


$(BUILD_DIR)/%_results.csv: $(addsuffix .bin, $(addprefix $(BUILD_DIR)/%_, $(BENCH_OPTS))) $(BUILD_DIR)/%_inputs.txt
ifndef HYPERFINE
	$(error "install hyperfine: https://github.com/sharkdp/hyperfine")
endif
	cd $(BUILD_DIR) && \
	hyperfine --warmup 1 --max-runs 100 --export-csv $(notdir $@) $(addprefix ./, $(filter %.bin, $(notdir $^)))



.PHONY: firrtl clean NeuromorphicProcessor_all_bin
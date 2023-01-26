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
$(BUILD_DIR)/NeuromorphicProcessor_baseline.sv: NeuromorphicProcessor/NeuromorphicProcessor.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog -o $@

$(BUILD_DIR)/NeuromorphicProcessor_firrtl_line.sv: NeuromorphicProcessor/NeuromorphicProcessor.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(LINE_COV) -o $@

$(BUILD_DIR)/NeuromorphicProcessor_firrtl_toggle.sv: NeuromorphicProcessor/NeuromorphicProcessor.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(TOGGLE_COV) -o $@

$(BUILD_DIR)/NeuromorphicProcessor_firrtl_all.sv: NeuromorphicProcessor/NeuromorphicProcessor.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(ALL_COV) -o $@

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

$(BUILD_DIR)/TLRAM_firrtl_all.sv: TLRAM/TLRAMStandalone.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(ALL_COV) -o $@

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

$(BUILD_DIR)/serv_firrtl_all.sv: serv-chisel/ServTopWithRam.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog $(ALL_COV) -o $@

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

############ Benchmarking with Hyperfine
# # https://stackoverflow.com/questions/5618615/check-if-a-program-exists-from-a-makefile
HYPERFINE := $(shell command -v hyperfine 2> /dev/null)


$(BUILD_DIR)/%_results.csv: $(addsuffix .bin, $(addprefix $(BUILD_DIR)/%_, $(BENCH_OPTS))) $(BUILD_DIR)/%_inputs.txt
ifndef HYPERFINE
	$(error "install hyperfine: https://github.com/sharkdp/hyperfine")
endif
	cd $(BUILD_DIR) && \
	hyperfine --warmup 1 --max-runs 100 --export-csv $(notdir $@) $(addprefix ./, $(filter %.bin, $(notdir $^)))


# run once for a quick test
%_run_once: $(addsuffix .bin, $(addprefix $(BUILD_DIR)/%_, $(BENCH_OPTS))) $(BUILD_DIR)/%_inputs.txt
ifndef HYPERFINE
	$(error "install hyperfine: https://github.com/sharkdp/hyperfine")
endif
	cd $(BUILD_DIR) && \
	hyperfine --warmup 0 --max-runs 1 $(addprefix ./, $(filter %.bin, $(notdir $^)))

.PHONY: firrtl clean NeuromorphicProcessor_all_bin TLRAM_all_bin
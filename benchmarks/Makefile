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
$(BUILD_DIR)/NeuromorphicProcessor_%.bin: $(BUILD_DIR)/NeuromorphicProcessor_%.sv $(BUILD_DIR)/NeuromorphicProcessor.cc
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
$(BUILD_DIR)/NeuromorphicProcessor_inputs.txt: NeuromorphicProcessor/inputs.txt.gz
	gzip -dk $<
	mv NeuromorphicProcessor/inputs.txt $@

############ Benchmarking with Hyperfine
# # https://stackoverflow.com/questions/5618615/check-if-a-program-exists-from-a-makefile
HYPERFINE := $(shell command -v hyperfine 2> /dev/null)

BENCH_OPTS = baseline firrtl_line native_line firrtl_toggle native_toggle firrtl_all


$(BUILD_DIR)/NeuromorphicProcessor_results.csv: $(addsuffix .bin, $(addprefix $(BUILD_DIR)/NeuromorphicProcessor_, $(BENCH_OPTS))) $(BUILD_DIR)/NeuromorphicProcessor_inputs.txt
ifndef HYPERFINE
	$(error "install hyperfine: https://github.com/sharkdp/hyperfine")
endif
	cd $(BUILD_DIR) && \
	hyperfine --warmup 1 --max-runs 100 --export-csv $(notdir $@) $(addprefix ./, $(filter %.bin, $(notdir $^)))




# %_baseline.sv: %.fir $(firrtl_jar)
# 	$(firrtl_bin) -i $< -E sverilog -o $@

# %_line.sv: %.fir $(firrtl_jar)
# 	# hack to ignore the top level module
# 	$(firrtl_bin) -i $< -E sverilog -o $@ --line-coverage --emit-cover-info --do-not-cover $(shell head -n 1 $< | cut -d' ' -f 2):$(shell head -n 1 $< | cut -d' ' -f 2)

# %_line.lo.fir: %.fir $(firrtl_jar)
# 	# hack to ignore the top level module
# 	$(firrtl_bin) -i $< -E low -o %_line --line-coverage --emit-cover-info --do-not-cover $(shell head -n 1 $< | cut -d' ' -f 2):$(shell head -n 1 $< | cut -d' ' -f 2)


# %_toggle.sv: %.fir $(firrtl_jar)
# 	# hack to ignore the top level module
# 	$(firrtl_bin) -i $< -E sverilog -o $@ --toggle-coverage --emit-cover-info --do-not-cover $(shell head -n 1 $< | cut -d' ' -f 2):$(shell head -n 1 $< | cut -d' ' -f 2)
	
# %_toggle.lo.fir: %.fir $(firrtl_jar)
# 	# hack to ignore the top level module
# 	$(firrtl_bin) -i $< -E low -o %_toggle --toggle-coverage --emit-cover-info --do-not-cover $(shell head -n 1 $< | cut -d' ' -f 2):$(shell head -n 1 $< | cut -d' ' -f 2)

# # Testbench top (same for all simulator binaries)
# %.cpp: %.fir template.cpp
# 	TOP=$(basename $(notdir $<)) envsubst < template.cpp > $@

# %TB.sv: %.fir
# 	TOP=$(basename $(notdir $<)) envsubst < template.sv > $@

# verilator = verilator -Wno-WIDTH --cc --exe --build
# vcs = vcs -full64 -sverilog

# %_baseline: %_baseline.sv %.cpp
# 	cd $(dir $(basename $@)) && \
# 		$(verilator) \
# 		$(notdir $^) \
# 		--top-module $(basename $(notdir $(word 2,$^))) \
# 		-Mdir baseline
# 	ln -s baseline/V$(subst _baseline,,$(notdir $@)) $@

# %_baseline-vcs: %TB.sv %_baseline.sv
# 	mkdir -p $(dir $(basename $@))baseline-vcs && \
# 		cd $(dir $(basename $@))baseline-vcs && \
# 		$(vcs) $(addprefix ../,$(notdir $^))
# 	ln -s baseline-vcs/simv $@
# 	# both symbolic or hard links don't work for running simv outside VCS's build directory
# 	# just using the link so Make knows the target is up to date

# # todo: extract this incantation into a Makefile function
# %_line_native: %_baseline.sv %.cpp
# 	cd $(dir $(basename $@)) && \
# 		$(verilator) --coverage-line \
# 		$(notdir $^) \
# 		--top-module $(basename $(notdir $(word 2,$^))) \
# 		-Mdir line_native
# 	ln -s line_native/V$(subst _line_native,,$(notdir $@)) $@

# %_line_native-vcs: %TB.sv %_baseline.sv
# 	mkdir -p $(dir $(basename $@))line_native-vcs && \
# 		cd $(dir $(basename $@))line_native-vcs && \
# 		$(vcs) -cm line $(addprefix ../,$(notdir $^))
# 	ln -s line_native-vcs/simv $@

# %_toggle_native: %_baseline.sv %.cpp
# 	cd $(dir $(basename $@)) && \
# 		$(verilator) --coverage-toggle \
# 		$(notdir $^) \
# 		--top-module $(basename $(notdir $(word 2,$^))) \
# 		-Mdir toggle_native
# 	ln -s toggle_native/V$(subst _toggle_native,,$(notdir $@)) $@

# %_toggle_native-vcs: %TB.sv %_baseline.sv
# 	mkdir -p $(dir $(basename $@))toggle_native-vcs && \
# 		cd $(dir $(basename $@))toggle_native-vcs && \
# 		$(vcs) -cm tgl $(addprefix ../,$(notdir $^))
# 	ln -s toggle_native-vcs/simv $@

# %_line_firrtl: %_line.sv %.cpp
# 	cd $(dir $(basename $@)) && \
# 		$(verilator) --coverage-user \
# 		$(notdir $^) \
# 		--top-module $(basename $(notdir $(word 2,$^))) \
# 		-Mdir line_firrtl
# 	ln -s line_firrtl/V$(subst _line_firrtl,,$(notdir $@)) $@

# %_line_firrtl-vcs: %TB.sv %_line.sv
# 	mkdir -p $(dir $(basename $@))line_firrtl-vcs && \
# 		cd $(dir $(basename $@))line_firrtl-vcs && \
# 		$(vcs) -cm assert $(addprefix ../,$(notdir $^))
# 	ln -s line_firrtl-vcs/simv $@

# %_toggle_firrtl: %_toggle.sv %.cpp
# 	cd $(dir $(basename $@)) && \
# 		$(verilator) --coverage-user \
# 		$(notdir $^) \
# 		--top-module $(basename $(notdir $(word 2,$^))) \
# 		-Mdir toggle_firrtl
# 	ln -s toggle_firrtl/V$(subst _toggle_firrtl,,$(notdir $@)) $@

# %_toggle_firrtl-vcs: %TB.sv %_toggle.sv
# 	mkdir -p $(dir $(basename $@))toggle_firrtl-vcs && \
# 		cd $(dir $(basename $@))toggle_firrtl-vcs && \
# 		$(vcs) -cm assert $(addprefix ../,$(notdir $^))
# 	ln -s toggle_firrtl-vcs/simv $@

# # https://stackoverflow.com/questions/5618615/check-if-a-program-exists-from-a-makefile
# HYPERFINE := $(shell command -v hyperfine 2> /dev/null)

# %_results.csv: %_baseline %_line_native %_toggle_native %_line_firrtl %_toggle_firrtl
# ifndef HYPERFINE
# 	$(error "install hyperfine: https://github.com/sharkdp/hyperfine")
# endif
# 	hyperfine --warmup 1 --max-runs 100 --export-csv $@ $^

# %_results-vcs.csv: %_baseline-vcs %_line_native-vcs %_toggle_native-vcs %_line_firrtl-vcs %_toggle_firrtl-vcs
# ifndef HYPERFINE
# 	$(error "install hyperfine: https://github.com/sharkdp/hyperfine")
# endif
# 	hyperfine --max-runs 10 --export-csv $@ \
# 		"cd $(dir $(basename $@))baseline-vcs && ./simv" \
# 		"cd $(dir $(basename $@))line_native-vcs && ./simv -cm line" \
# 		"cd $(dir $(basename $@))toggle_native-vcs && ./simv -cm tgl" \
# 		"cd $(dir $(basename $@))line_firrtl-vcs && ./simv -cm assert" \
# 		"cd $(dir $(basename $@))toggle_firrtl-vcs && ./simv -cm assert" \

# designs = $(shell find . -mindepth 2 -type f -name '*.fir')
# baseline_sims = $(patsubst %.fir,%_baseline,$(designs))
# native_line_sims = $(patsubst %.fir,%_line_native,$(designs))
# native_toggle_sims = $(patsubst %.fir,%_toggle_native,$(designs))
# firrtl_line_sims = $(patsubst %.fir,%_line_firrtl,$(designs))
# firrtl_toggle_sims = $(patsubst %.fir,%_toggle_firrtl,$(designs))
# results = $(patsubst %.fir,%_results.csv,$(designs))

# build: $(baseline_sims) $(native_line_sims) $(native_toggle_sims) $(firrtl_line_sims) $(firrtl_toggle_sims)

# benchmark: $(results)

# clean:
# 	find . -mindepth 2 -type f -name '*.sv' -delete;
# 	find . -mindepth 2 -type f -name '*.cover.json' -delete;
# 	find . -mindepth 2 -type f -name '*.cpp' -delete;
# 	find . -mindepth 2 -type f -name '*.csv' -delete;
# 	find . -type f -name 'ucli.key' -delete;
# 	find . -type f -name 'coverage.dat' -delete;
# 	find . -mindepth 2 -type l -name '*_baseline*' -delete;
# 	find . -mindepth 2 -type l -name '*_line_native*' -delete;
# 	find . -mindepth 2 -type l -name '*_line_firrtl*' -delete;
# 	find . -mindepth 2 -type l -name '*_toggle_native*' -delete;
# 	find . -mindepth 2 -type l -name '*_toggle_firrtl*' -delete;
# 	find . -depth -mindepth 2 -type d -name 'baseline*' -exec rm -r {} \;
# 	find . -depth -mindepth 2 -type d -name 'line_firrtl*' -exec rm -r {} \;
# 	find . -depth -mindepth 2 -type d -name 'line_native*' -exec rm -r {} \;
# 	find . -depth -mindepth 2 -type d -name 'toggle_native*' -exec rm -r {} \;
# 	find . -depth -mindepth 2 -type d -name 'toggle_firrtl*' -exec rm -r {} \;

# .PHONY: firrtl clean build benchmark
# .PRECIOUS: %_baseline.sv %_line.sv %_toggle.sv %.cpp %TB.sv %_baseline %_line_native %_line_firrtl %_toggle_native %_toggle_firrtl

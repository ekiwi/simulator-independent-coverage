firrtl_jar = ../coverage/utils/bin/firrtl.jar
firrtl_bin = ../coverage/utils/bin/firrtl
firrtl_srcs = $(shell find ../coverage/src -type f)
$(firrtl_jar): $(firrtl_srcs)
	cd ../coverage && sbt assembly
firrtl: $(firrtl_jar)

%_baseline.sv: %.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog -o $@

%_line.sv: %.fir $(firrtl_jar)
	# hack to ignore the top level module
	$(firrtl_bin) -i $< -E sverilog -o $@ --line-coverage --do-not-cover $(shell head -n 1 $< | cut -d' ' -f 2):$(shell head -n 1 $< | cut -d' ' -f 2)

%_toggle.sv: %.fir $(firrtl_jar)
	# hack to ignore the top level module
	$(firrtl_bin) -i $< -E sverilog -o $@ --toggle-coverage --do-not-cover $(shell head -n 1 $< | cut -d' ' -f 2):$(shell head -n 1 $< | cut -d' ' -f 2)

# Testbench top (same for all simulator binaries)
%.cpp: %.fir template.cpp
	TOP=$(basename $(notdir $<)) envsubst < template.cpp > $@

verilator = verilator -Wno-WIDTH --cc --exe --build

%_baseline: %_baseline.sv %.cpp
	cd $(dir $(basename $@)) && \
		$(verilator) \
		$(notdir $<) \
		$(notdir $(word 2,$^)) \
		--top-module $(basename $(notdir $(word 2,$^))) \
		-Mdir baseline
	ln -s baseline/V$(subst _baseline,,$(notdir $@)) $@

# todo: extract this incantation into a Makefile function
%_line_native: %_baseline.sv %.cpp
	cd $(dir $(basename $@)) && \
		$(verilator) --coverage-line \
		$(notdir $<) \
		$(notdir $(word 2,$^)) \
		--top-module $(basename $(notdir $(word 2,$^))) \
		-Mdir line_native
	ln -s line_native/V$(subst _line_native,,$(notdir $@)) $@

%_toggle_native: %_baseline.sv %.cpp
	cd $(dir $(basename $@)) && \
		$(verilator) --coverage-toggle \
		$(notdir $<) \
		$(notdir $(word 2,$^)) \
		--top-module $(basename $(notdir $(word 2,$^))) \
		-Mdir toggle_native
	ln -s toggle_native/V$(subst _toggle_native,,$(notdir $@)) $@

%_line_firrtl: %_line.sv %.cpp
	cd $(dir $(basename $@)) && \
		$(verilator) --coverage-user \
		$(notdir $<) \
		$(notdir $(word 2,$^)) \
		--top-module $(basename $(notdir $(word 2,$^))) \
		-Mdir line_firrtl
	ln -s line_firrtl/V$(subst _line_firrtl,,$(notdir $@)) $@

%_toggle_firrtl: %_toggle.sv %.cpp
	cd $(dir $(basename $@)) && \
		$(verilator) --coverage-user \
		$(notdir $<) \
		$(notdir $(word 2,$^)) \
		--top-module $(basename $(notdir $(word 2,$^))) \
		-Mdir toggle_firrtl
	ln -s toggle_firrtl/V$(subst _toggle_firrtl,,$(notdir $@)) $@

# https://stackoverflow.com/questions/5618615/check-if-a-program-exists-from-a-makefile
HYPERFINE := $(shell command -v hyperfine 2> /dev/null)

%_results.csv: %_baseline %_line_native %_toggle_native %_line_firrtl %_toggle_firrtl
ifndef HYPERFINE
	$(error "install hyperfine: https://github.com/sharkdp/hyperfine")
endif
	hyperfine --warmup 1 --max-runs 100 --export-csv $@ $^

designs = $(shell find . -mindepth 2 -type f -name '*.fir')
baseline_sims = $(patsubst %.fir,%_baseline,$(designs))
native_line_sims = $(patsubst %.fir,%_line_native,$(designs))
native_toggle_sims = $(patsubst %.fir,%_toggle_native,$(designs))
firrtl_line_sims = $(patsubst %.fir,%_line_firrtl,$(designs))
firrtl_toggle_sims = $(patsubst %.fir,%_toggle_firrtl,$(designs))
results = $(patsubst %.fir,%_results.csv,$(designs))

build: $(baseline_sims) $(native_line_sims) $(native_toggle_sims) $(firrtl_line_sims) $(firrtl_toggle_sims)

benchmark: $(results)

clean:
	find . -mindepth 2 -type f -name '*.sv' -delete;
	find . -mindepth 2 -type f -name '*.cpp' -delete;
	find . -mindepth 2 -type f -name '*.csv' -delete;
	find . -type f -name 'coverage.dat' -delete;
	find . -mindepth 2 -type l -name '*_baseline' -delete;
	find . -mindepth 2 -type l -name '*_line_native' -delete;
	find . -mindepth 2 -type l -name '*_line_firrtl' -delete;
	find . -mindepth 2 -type l -name '*_toggle_native' -delete;
	find . -mindepth 2 -type l -name '*_toggle_firrtl' -delete;
	find . -depth -mindepth 2 -type d -name 'baseline' -exec rm -r {} \;
	find . -depth -mindepth 2 -type d -name 'line_firrtl' -exec rm -r {} \;
	find . -depth -mindepth 2 -type d -name 'line_native' -exec rm -r {} \;
	find . -depth -mindepth 2 -type d -name 'toggle_native' -exec rm -r {} \;
	find . -depth -mindepth 2 -type d -name 'toggle_firrtl' -exec rm -r {} \;

.PHONY: firrtl clean build benchmark
.PRECIOUS: %_baseline.sv %_line.sv %.cpp %_baseline %_line_native %_line_firrtl %_toggle_native %_toggle_firrtl

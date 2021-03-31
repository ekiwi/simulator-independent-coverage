designs = $(shell find . -mindepth 2 -type f -name '*.fir')
verilator_src = $(patsubst %.fir,verilator/%.v,$(designs))

firrtl_jar = ../coverage/utils/bin/firrtl.jar
firrtl_bin = ../coverage/utils/bin/firrtl
firrtl_srcs = $(shell find ../coverage/src -type f)
$(firrtl_jar): $(firrtl_srcs)
	cd ../coverage && sbt assembly
firrtl: $(firrtl_jar)

%_plain.sv: %.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog -o $@

# hack to ignore the top level module
%_line.sv: %.fir $(firrtl_jar)
	$(firrtl_bin) -i $< -E sverilog -o $@ --line-coverage --do-not-cover $(shell head -n 1 $< | cut -d' ' -f 2):$(shell head -n 1 $< | cut -d' ' -f 2)

%_plain.cpp: %.fir
	TOP=$(basename $(notdir $<))_plain envsubst < top.cpp > $@

%_plain: %_plain.sv %_plain.cpp
	cd $(dir $(basename $@)) && \
	verilator --cc --exe --build \
		$(notdir $<) \
		$(notdir $(word 2,$^)) \
		-Mdir plain && \
		ln -s plain/V$(notdir $@) $(notdir $@)


clean:
	$(shell find . -mindepth 2 -type f -name '*.sv' -exec rm -f {} \;)

.PHONY: firrtl clean
.PRECIOUS: %_plain.sv %_line.sv %_plain.cpp %_plain

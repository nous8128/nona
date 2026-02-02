#===================================================================================================
# config
#---------------------------------------------------------------------------------------------------
max_cycles          :=
mem_file            :=

-include config.mk

#===================================================================================================
# sources
#---------------------------------------------------------------------------------------------------
pkg_dir             := src/include
pkgs                += $(pkg_dir)/nona_pkg.sv

src_dir             := src
srcs                += $(wildcard $(addprefix $(src_dir)/,*.v *.sv))

test_src_dir        := test
test_srcs           += $(wildcard $(addprefix $(test_src_dir)/,*.v *.sv))

#===================================================================================================
# verilator
#---------------------------------------------------------------------------------------------------
verilator           ?= verilator

topname             := nona
top_module          := top

# see verilator Arguments (https://verilator.org/guide/latest/exe_verilator.html)
verilator_flags     += --binary
verilator_flags     += --prefix $(topname)
verilator_flags     += --top-module $(top_module)

verilator_input     += $(pkgs) $(test_srcs) $(srcs)

#---------------------------------------------------------------------------------------------------
plusargs            += $(if $(max_cycles),+max_cycles="$(max_cycles)")
plusargs            += $(if $(mem_file),+mem_file="$(mem_file)")

#===================================================================================================
# build rules
#---------------------------------------------------------------------------------------------------
.PHONY: default build run clean
default: build run

build:
	$(verilator) $(verilator_flags) $(verilator_input)

run:
	obj_dir/$(topname) $(plusargs)

clean:
	rm -rf obj_dir

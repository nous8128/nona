#===================================================================================================
# config
#---------------------------------------------------------------------------------------------------
xlen                := 64

tgt                 := template
bld_dir             := build
blk_sz              := 16KiB

#---------------------------------------------------------------------------------------------------
ifeq ($(filter 32 64,$(xlen)),)
$(error xlen must be 32 or 64 (current: $(xlen)))
endif

riscv_arch          := rv$(xlen)i
riscv_arch          := $(riscv_arch)_zicntr_zicsr_zifencei

ifeq ($(xlen),32)
riscv_abi           := ilp32
else ifeq ($(xlen),64)
riscv_abi           := lp64
endif

-include config.mk

#===================================================================================================
# sources
#---------------------------------------------------------------------------------------------------
srcs-to-objs         = $(patsubst %.s,%.o,$(filter %.s,$1)) \
                       $(patsubst %.S,%.o,$(filter %.S,$1)) \
                       $(patsubst %.c,%.o,$(filter %.c,$1))

src_dir             := src
srcs                := $(wildcard $(addprefix $(src_dir)/,*.s *.S *.c))
objs                := $(call srcs-to-objs,$(srcs))

inc_dir             += $(src_dir)

#===================================================================================================
# riscv
#---------------------------------------------------------------------------------------------------
riscv_prefix        ?= riscv$(xlen)-unknown-elf-
riscv_gcc           := $(riscv_prefix)gcc
riscv_cflags        += -O2 -march=$(riscv_arch) -mabi=$(riscv_abi) $(addprefix -I,$(inc_dir))
riscv_ldflags       += -nostartfiles -T$(src_dir)/link.ld
riscv_objcopy       := $(riscv_prefix)objcopy
riscv_objdump       := $(riscv_prefix)objdump

#===================================================================================================
# build rules
#---------------------------------------------------------------------------------------------------
.PHONY: default
default: $(bld_dir) $(addprefix $(bld_dir)/$(tgt),.elf .bin .32.mem .64.mem .128.mem .dump)

%.dump: %.elf
	$(riscv_objdump) -d $< > $@

%.128.mem: %.64.mem
	awk '{if (NR % 2) { buf = $$0 } else {print $$0 buf; buf = ""}}' $< > $@

%.64.mem: %.bin
	od -v -An -tx8 -w8 $< | sed 's/^ *\([0-9a-f]\+\)/\1/' > $@

%.32.mem: %.bin
	od -v -An -tx4 -w4 $< | sed 's/^ *\([0-9a-f]\+\)/\1/' > $@

%.bin: %.elf
	$(riscv_objcopy) -O binary $< $@.tmp
	dd if=$@.tmp of=$@ bs=$(blk_sz) conv=sync
	rm -f $@.tmp

%.elf: $(objs)
	$(riscv_gcc) $(riscv_cflags) $(riscv_ldflags) -o $@ $^

%.o: %.c
	$(riscv_gcc) $(riscv_cflags) -c -o $@ $<

%.o: %.S
	$(riscv_gcc) $(riscv_cflags) -c -o $@ $<

%.o: %.s
	$(riscv_gcc) $(riscv_cflags) -c -o $@ $<

$(bld_dir):
	mkdir -p $@

.PHONY: clean
clean:
	find . \( \
		   -name '*.dump' \
		-o -name '*.mem'  \
		-o -name '*.bin'  \
		-o -name '*.elf'  \
		-o -name '*.o'    \
		-o -name '*.tmp'  \
	\) -delete
	rm -rf $(bld_dir)

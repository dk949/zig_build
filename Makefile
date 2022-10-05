ZIG_PREFIX := $(PWD)/zig
LLVM_PREFIX := $(PWD)/llvm
ZSTD_PREFIX := $(PWD)/zstd

all: zig

$(ZIG_PREFIX): llvm
	ZSTD_PREFIX=$(ZSTD_PREFIX) \
	LLVM_PREFIX=$(LLVM_PREFIX) \
	ZIG_PREFIX=$(ZIG_PREFIX) \
	$(MAKE) -f zig.mk

$(LLVM_PREFIX): zstd
	LLVM_PREFIX=$(LLVM_PREFIX) \
	$(MAKE) -f llvm.mk

$(ZSTD_PREFIX):
	ZSTD_PREFIX=$(ZSTD_PREFIX) \
	$(MAKE) -f zstd.mk


.PHONY: all clean

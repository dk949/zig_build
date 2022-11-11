ZIG_PREFIX      ?= $(PWD)/zig
LLVM_PREFIX     ?= $(PWD)/llvm
GENERATOR       ?= Ninja
ZIG_BUILD_MODE  ?= Debug
LLVM_BUILD_MODE ?= Debug

all: progress/zig

progress/zig: progress/llvm
	LLVM_PREFIX=$(LLVM_PREFIX)       \
	ZIG_PREFIX=$(ZIG_PREFIX)         \
	ZIG_BUILD_MODE=$(ZIG_BUILD_MODE) \
	GENERATOR=$(GENERATOR)           \
	$(MAKE) -f zig.mk

progress/llvm: progress
	LLVM_PREFIX=$(LLVM_PREFIX)        \
	LLVM_BUILD_MODE=$(LLVM_BUILD_MODE) \
	GENERATOR=$(GENERATOR)            \
	$(MAKE) -f llvm.mk

progress:
	mkdir -p progress

clean-zig:
	$(MAKE) -f zig.mk clean

clean-comp-zig:
	$(MAKE) -f zig.mk clean-comp

clean-cmake-zig:
	$(MAKE) -f zig.mk clean-cmake

clean-deep-zig:
	$(MAKE) -f zig.mk clean-deep

clean-llvm:
	$(MAKE) -f llvm.mk clean

clean-comp-llvm:
	$(MAKE) -f llvm.mk clean-comp

clean-cmake-llvm:
	$(MAKE) -f llvm.mk clean-cmake

clean-deep-llvm:
	$(MAKE) -f llvm.mk clean-deep

clean-all: clean-zig clean-llvm

clean-comp-all: clean-comp-zig clean-comp-llvm

clean-cmake-all: clean-cmake-zig clean-cmake-llvm

clean-deep-all: clean-deep-zig clean-deep-llvm

clean: clean-zig

clean-comp: clean-comp-zig

clean-cmake: clean-cmake-zig

clean-deep: clean-deep-zig

.PHONY: all clean-zig clean-comp-zig clean-cmake-zig clean-deep-zig clean-llvm clean-comp-llvm clean-cmake-llvm clean-deep-llvm clean-all clean-comp-all clean-cmake-all clean-deep-all clean clean-comp clean-cmake clean-deep

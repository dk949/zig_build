include utils.mk

$(call undef_info,GENERATOR,"CMake generator to use",Ninja)
$(call undef_info,LLVM_BRANCH,"Git branch for llvm","release/15.x")
$(call undef_info,LLVM_BUILD_MODE,"Which mode to build LLVM in [Debug|Release]",Debug)
$(call undef_info,LLVM_PREFIX,"LLVM install location",$(PWD)/llvm)
$(call undef_info,LLVM_REMOTE,"Git remote to pull llvm from","https://github.com/llvm/llvm-project")
$(call undef_info,USE_CCACHE,"Use ccache to cache build files [ON|OFF]",ON)
$(call undef_info,ZIG_BUILD_MODE,"Which mode to build Zig in [Debug|Release]",Debug)
$(call undef_info,ZIG_PREFIX,"Zig install location",$(PWD)/zig)
$(call undef_info,ZIG_REMOTE,"Git remote to pull zig from","https://github.com/ziglang/zig.git")

GENERATOR       ?= Ninja
LLVM_BRANCH     ?= "release/15.x"
LLVM_BUILD_MODE ?= Release
LLVM_PREFIX     ?= $(PWD)/llvm
LLVM_REMOTE     ?= "https://github.com/llvm/llvm-project"
USE_CCACHE      ?= ON
ZIG_BUILD_MODE  ?= Debug
ZIG_PREFIX      ?= $(PWD)/zig
ZIG_REMOTE      ?= "https://github.com/ziglang/zig.git"

all: progress/zig

ZIG_MK_FLAGS = LLVM_PREFIX=$(LLVM_PREFIX)       \
			   ZIG_PREFIX=$(ZIG_PREFIX)         \
			   ZIG_BUILD_MODE=$(ZIG_BUILD_MODE) \
			   GENERATOR=$(GENERATOR)           \
			   USE_CCACHE=$(USE_CCACHE)         \
			   ZIG_REMOTE=$(ZIG_REMOTE)

LLVM_MK_FLAGS = LLVM_PREFIX=$(LLVM_PREFIX)         \
				LLVM_BUILD_MODE=$(LLVM_BUILD_MODE) \
				GENERATOR=$(GENERATOR)             \
				USE_CCACHE=$(USE_CCACHE)           \
			    LLVM_REMOTE=$(LLVM_REMOTE)         \
			    LLVM_BRANCH=$(LLVM_BRANCH)

MAKE_ZIG  = $(MAKE) $(ZIG_MK_FLAGS)  -f zig.mk
MAKE_LLVM = $(MAKE) $(LLVM_MK_FLAGS) -f llvm.mk

progress/zig: progress/llvm
	$(MAKE_ZIG)

progress/llvm: progress
	$(MAKE_LLVM)

progress:
	mkdir -p progress

clean-zig:
	$(MAKE_ZIG) clean

clean-comp-zig:
	$(MAKE_ZIG) clean-comp

clean-cmake-zig:
	$(MAKE_ZIG) clean-cmake

clean-deep-zig:
	$(MAKE_ZIG) clean-deep

clean-llvm:
	$(MAKE_LLVM) clean

clean-comp-llvm:
	$(MAKE_LLVM) clean-comp

clean-cmake-llvm:
	$(MAKE_LLVM) clean-cmake

clean-deep-llvm:
	$(MAKE_LLVM) clean-deep

clean-all: clean-zig clean-llvm

clean-comp-all: clean-comp-zig clean-comp-llvm

clean-cmake-all: clean-cmake-zig clean-cmake-llvm

clean-deep-all: clean-deep-zig clean-deep-llvm

clean: clean-zig

clean-comp: clean-comp-zig

clean-cmake: clean-cmake-zig

clean-deep: clean-deep-zig

.PHONY: all clean-zig clean-comp-zig clean-cmake-zig clean-deep-zig clean-llvm clean-comp-llvm clean-cmake-llvm clean-deep-llvm clean-all clean-comp-all clean-cmake-all clean-deep-all clean clean-comp clean-cmake clean-deep

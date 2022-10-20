ZIG_BUILD_MODE ?= Debug
ZIG_PREFIX     ?= $(PWD)/zig
LLVM_PREFIX    ?= $(PWD)/llvm
ZSTD_PREFIX    ?= $(PWD)/zstd

all: progress/zig

progress/zig-clone:
	git clone --recursive https://github.com/dk949/zig.git zig-source
	touch $@


progress/zig-cmake-config: progress/zig-clone
	cmake -B zig-source/build-$(ZIG_BUILD_MODE) -S zig-source \
	  -DCMAKE_INSTALL_PREFIX=$(ZIG_PREFIX) \
	  -DCMAKE_PREFIX_PATH="$(LLVM_PREFIX)" \
	  -DZIG_USE_LLVM_CONFIG=On \
	  -DZIG_FIX_SYSTEM_LIBS=On \
	  -DZIG_USE_CCACHE=On \
	  -DCMAKE_BUILD_TYPE=$(ZIG_BUILD_MODE)
	touch $@

progress/zig-build: progress/zig-cmake-config
	cmake --build zig-source/build-$(ZIG_BUILD_MODE)
	touch $@

progress/zig: progress/zig-build
	@echo "installing zig into $(ZIG_PREFIX)"
	@sleep 5
	mkdir -p $(ZIG_PREFIX)
	cmake --install zig-source/build-$(ZIG_BUILD_MODE)
	touch $@


clean:
	rm -f progress/zig progress/zig-build

clean-comp: clean
	cmake --build zig-source/build-$(ZIG_BUILD_MODE) --target clean

clean-cmake: clean
	rm -f progress/zig-cmake-config
	rm -rf zig-source/build-$(ZIG_BUILD_MODE)

clean-deep:
	rm -f progress/zig*
	rm -rf zig-source
	rm -rf zig

.PHONY: all clean clean-comp clean-cmake clean-deep

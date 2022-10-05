all: $(ZIG_PREFIX)

zig-source:
	git clone --recursive https://github.com/ziglang/zig.git zig-source

zig-source/build-release: zig-source
	mkdir -p zig-source/build-release
	git -C zig-source apply ../zsdt_fix.patch
	cmake -B zig-source/build-release -S zig-source \
	  -DCMAKE_INSTALL_PREFIX=$(ZIG_PREFIX) \
	  -DCMAKE_PREFIX_PATH="$(LLVM_PREFIX);$(ZSTD_PREFIX)" \
	  -DZIG_USE_LLVM_CONFIG=Yes \
	  -DZIG_FIX_SYSTEM_LIBS=Yes \
	  -DCMAKE_BUILD_TYPE=Release

	cmake --build zig-source/build-release

$(ZIG_PREFIX): zig-source/build-release
	@echo "installing into $(ZIG_PREFIX)"
	@sleep 5
	mkdir -p $(ZIG_PREFIX)
	cmake --install zig-source/build-release

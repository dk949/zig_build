all: progress/llvm

progress/llvm-clone:
	git clone --depth 1 --branch release/15.x https://github.com/llvm/llvm-project llvm-source
	touch $@

progress/llvm-checkout: progress/llvm-clone
	git -C llvm-source checkout release/15.x
	touch $@

progress/llvm-cmake-config: progress/llvm-clone
	cmake -B llvm-source/build-release -S llvm-source/llvm \
	  -DCMAKE_INSTALL_PREFIX=$(LLVM_PREFIX) \
	  -DCMAKE_PREFIX_PATH=$(LLVM_PREFIX) \
	  -DCMAKE_BUILD_TYPE=Release \
	  -DLLVM_ENABLE_PROJECTS="lld;clang" \
	  -DLLVM_ENABLE_LIBXML2=OFF \
	  -DLLVM_ENABLE_TERMINFO=OFF \
	  -DLLVM_ENABLE_LIBEDIT=OFF \
	  -DLLVM_ENABLE_ASSERTIONS=ON \
	  -DLLVM_CCACHE_BUILD=ON \
	  -G Ninja \
	  -DLLVM_PARALLEL_LINK_JOBS=1
	touch $@


progress/llvm-build: progress/llvm-cmake-config
	cmake --build llvm-source/build-release
	touch $@

progress/llvm: progress/llvm-build
	@echo "installing llvm into $(LLVM_PREFIX)"
	@sleep 5
	mkdir -p $(LLVM_PREFIX)
	cmake --install llvm-source/build-release
	touch $@



clean:
	rm -f progress/llvm progress/llvm-build

clean-comp: clean
	cmake --build llvm-source/build-release --target clean

clean-cmake: clean
	rm -f progress/llvm-cmake-config
	rm -rf llvm-source/build-release

clean-deep:
	rm -f progress/llvm*
	rm -rf llvm-source
	rm -rf llvm

.PHONY: all clean clean-comp clean-cmake clean-deep

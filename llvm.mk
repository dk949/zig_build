all: $(LLVM_PREFIX)

llvm-source:
	git clone --depth 1 --branch release/15.x https://github.com/llvm/llvm-project llvm-source


llvm-source/build-release: llvm-source
	git -C llvm-source checkout release/15.x
	mkdir -p llvm-source/build-release
	cmake -B llvm-source/build-release -S llvm-source/llvm \
	  -DCMAKE_INSTALL_PREFIX=$(LLVM_PREFIX) \
	  -DCMAKE_PREFIX_PATH=$(LLVM_PREFIX) \
	  -DCMAKE_BUILD_TYPE=Release \
	  -DLLVM_ENABLE_PROJECTS="lld;clang" \
	  -DLLVM_ENABLE_LIBXML2=OFF \
	  -DLLVM_ENABLE_TERMINFO=OFF \
	  -DLLVM_ENABLE_LIBEDIT=OFF \
	  -DLLVM_ENABLE_ASSERTIONS=ON \
	  -G Ninja \
	  -DLLVM_PARALLEL_LINK_JOBS=1
	cmake --build llvm-source/build-release

$(LLVM_PREFIX): llvm-source/build-release
	@echo "installing into $(LLVM_PREFIX)"
	@sleep 5
	mkdir -p $(LLVM_PREFIX)
	cmake --install llvm-source/build-release

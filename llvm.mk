include utils.mk
LLVM_BUILD_MODE ?= Release

$(call undef_err, GENERATOR, "Which generator should be used with cmake")
$(call undef_err, LLVM_BUILD_MODE, "Which mode to build llvm in [Debug|Release]")
$(call undef_err, LLVM_PREFIX, "Where to install compiled LLVM")

all: progress/llvm

progress/llvm-clone:
	git clone --depth 1 --branch release/15.x https://github.com/llvm/llvm-project llvm-source
	touch $@

progress/llvm-checkout: progress/llvm-clone
	git -C llvm-source checkout release/15.x
	touch $@

progress/llvm-cmake-config: progress/llvm-checkout
	cmake -B llvm-source/build-$(LLVM_BUILD_MODE) -S llvm-source/llvm \
		-DCMAKE_INSTALL_PREFIX=$(LLVM_PREFIX)                         \
		-DCMAKE_PREFIX_PATH=$(LLVM_PREFIX)                            \
		-DCMAKE_BUILD_TYPE=$(LLVM_BUILD_MODE)                         \
		-DLLVM_ENABLE_PROJECTS="lld;clang"                            \
		-DLLVM_ENABLE_LIBXML2=OFF                                     \
		-DLLVM_ENABLE_TERMINFO=OFF                                    \
		-DLLVM_ENABLE_LIBEDIT=OFF                                     \
		-DLLVM_ENABLE_ASSERTIONS=ON                                   \
		-DLLVM_CCACHE_BUILD=ON                                        \
		-G $(GENERATOR)                                               \
		-DLLVM_PARALLEL_LINK_JOBS=1
	touch $@


progress/llvm-build: progress/llvm-cmake-config
	cmake --build llvm-source/build-$(LLVM_BUILD_MODE)
	touch $@

progress/llvm: progress/llvm-build
	@echo "installing llvm into $(LLVM_PREFIX)"
	@sleep 5
	mkdir -p $(LLVM_PREFIX)
	cmake --install llvm-source/build-$(LLVM_BUILD_MODE)
	touch $@

clean:
	rm -f progress/llvm progress/llvm-build

clean-comp: clean
	cmake --build llvm-source/build-$(LLVM_BUILD_MODE) --target clean

clean-cmake: clean
	rm -f progress/llvm-cmake-config
	rm -rf llvm-source/build-$(LLVM_BUILD_MODE)

clean-deep:
	rm -f progress/llvm*
	rm -rf llvm-source
	rm -rf llvm

.PHONY: all clean clean-comp clean-cmake clean-deep

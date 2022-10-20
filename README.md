# zig build

Build zig from source. WARNING: takes a lot of time and memory.

## Build

* Ensure you have an internet connection (for cloning repositories).
* Requires:
  * C and C++ compilers
  * GNU make
  * zstd (typically installed as a dependency for GCC and/or clang)
  * (optional) ninja
    * Set `$GENERATOR` to the CMake generator which will be used to build LLVM
      and Zig
      * E.g. `GENERATOR='Unix Makefiles'`

**Run make**

```sh
export GENERATOR='Preferred CMake generator' # Defaults to "Ninja" if unset
export LLVM_PREFIX=/path/to/llvm/prefix # Defaults to "$PWD/llvm" if unset
export ZIG_PREFIX=/path/to/zig/prefix #  Defaults to "$PWD/zig" if unset
make
```

**This should:**

* Clone, configure and build LLVM
  * Source code is cloned into `$PWD/llvm-source`
  * Compiled artifacts will be installed in `$LLVM_PREFIX` (or `$PWD/llvm` by
    default)
* Clone, configure and build Zig (`stage1`, `stage2` and `stage3`)
  * Source code is cloned into `$PWD/zig-source`
  * Compiled artifacts will be installed in `$ZIG_PREFIX` (or `$PWD/zig` by
    default)

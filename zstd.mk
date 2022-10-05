all: $(ZSTD_PREFIX)

zstd-source:
	git clone --recursive https://github.com/facebook/zstd.git zstd-source

zstd-source/zstd: zstd-source
	$(MAKE) -C zstd-source -j16

$(ZSTD_PREFIX): zstd-source/zstd
	@echo "installing into $(ZSTD_PREFIX)"
	@sleep 5
	mkdir -p $(ZSTD_PREFIX)
	PREFIX=$(ZSTD_PREFIX) $(MAKE) -C zstd-source install

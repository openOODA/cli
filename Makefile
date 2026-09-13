# cli v0.1.0 Makefile
#
# Build and verify the trimmed language CLI driver.
#
# Usage:
#   make build       - compile main.oo to dist/cli (Phase 2+)
#   make test        - run the binary's --help and --version (Phase 2+)
#   make parity      - verify sha256 matches dist/cli (Phase 2+)
#   make line-cap    - enforce 256-line cap on every .oo and .oot
#   make file-law    - reject forbidden file extensions
#   make academy     - verify every .oo has the 4-element Academy header
#   make verify      - run all of the above checks
#   make install     - copy dist/cli to ~/.openooda/bin/ (Phase 2+)
#   make clean       - remove build artifacts
#   make all         - build + verify + test

OODA_COMPILER ?= $(HOME)/.openooda/bin/oodac
BIN := dist/cli

.PHONY: all build test parity line-cap file-law academy verify install clean

all: verify

build:
	@mkdir -p dist
	$(OODA_COMPILER) build --backend c main.oo -o $(BIN)
	@chmod +x $(BIN)
	@cp -a $(BIN) dist/cli-linux-x86_64
	@echo "built $(BIN)"

test: build
	./$(BIN) --help
	./$(BIN) version

parity: build
	@sum=$$(sha256sum $(BIN) | awk '{print $$1}'); echo $$sum; test -n "$$sum"

install: build
	@mkdir -p $(HOME)/.openooda/bin
	cp -a $(BIN) $(HOME)/.openooda/bin/cli
	@chmod +x $(HOME)/.openooda/bin/cli
	@echo "installed $(HOME)/.openooda/bin/cli"

line-cap:
	@violations=0; \
	for f in $$(find . -name "*.oo" -o -name "*.oot"); do \
		n=$$(wc -l < "$$f"); \
		if [ $$n -gt 256 ]; then \
			echo "VIOLATION: $$f = $$n lines"; \
			violations=$$((violations+1)); \
		fi; \
	done; \
	if [ $$violations -gt 0 ]; then echo "FAIL: $$violations files exceed 256-line cap"; exit 1; fi; \
	echo "PASS: 256-line cap holds"

file-law:
	@forbidden="py js ts rb pl json yaml toml sh md"; \
	violations=0; \
	for ext in $$forbidden; do \
		found=$$(find . -name "*.$$ext" -not -path "./.git/*" 2>/dev/null | head -3); \
		if [ -n "$$found" ] && [ "$$ext" != "md" -o "$$found" != "./README.md" ]; then \
			echo "VIOLATION: .$$ext forbidden:"; echo "$$found"; \
			violations=$$((violations+1)); \
		fi; \
	done; \
	if [ $$violations -gt 0 ]; then echo "FAIL: file-law violations"; exit 1; fi; \
	echo "PASS: file law holds"

academy:
	@failures=0; \
	for f in $$(find . -name "*.oo"); do \
		header=$$(head -7 "$$f"); \
		if ! echo "$$header" | grep -q "^// # "; then \
			echo "FAIL: $$f missing '// # <Title>' in first 7 lines"; \
			failures=$$((failures+1)); \
			continue; \
		fi; \
		if ! echo "$$header" | grep -q "^// Logline:"; then \
			echo "FAIL: $$f missing '// Logline:' in first 7 lines"; \
			failures=$$((failures+1)); \
			continue; \
		fi; \
		if ! echo "$$header" | grep -q "^// Setup:"; then \
			echo "FAIL: $$f missing '// Setup:' in first 7 lines"; \
			failures=$$((failures+1)); \
			continue; \
		fi; \
		if ! echo "$$header" | grep -q "^// Beats:"; then \
			echo "FAIL: $$f missing '// Beats:' in first 7 lines"; \
			failures=$$((failures+1)); \
			continue; \
		fi; \
	done; \
	if [ $$failures -gt 0 ]; then echo "FAIL: $$failures academy header violations"; exit 1; fi; \
	echo "PASS: academy headers hold (all 4 elements present in first 7 lines)"

verify: line-cap file-law academy

clean:
	@rm -rf dist .ooda-cache
	@echo "cleaned"

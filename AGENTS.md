# cli: Agent Engineering Standards (v1)

This repository houses the sovereign language CLI driver for openOODA (`build`, `run`, `test`, `fmt`, `install`, `update`, `qa`, `context`, `fix`).
All work in this repository strictly defers to the organization standards in [`openOODA/AGENTS.md`](file:///home/ubermetroid/Projects/openOODA/openOODA/AGENTS.md).

---

## 1. Domain Responsibilities & Architecture
- **Primary CLI Surface**: `cli` owns direct developer commands. It does not wrap `ooda`; `ooda` forwards to `cli`.
- **N-Binary Coordination**: Spawns external binaries (`oodac`, `opm`, `tui`) strictly via unforgeable `&ProcessCap`.
- **Zero Ambient Authority**: Requires explicit capability tokens (`&ProcessCap`, `&FsReadCap`, `&FsWriteCap`, `&EnvCap`).

---

## 2. Invariants & Quality Standards
- **The Page Rule**: Every `.oo` page must be between 16 and 256 lines. Pure import shims skip the floor.
- **Directory Density**: At most 8 `.oo` pages per directory.
- **4-Element Academy Header**: Mandatory on every `.oo` page (`// #`, `// Logline:`, `// Setup:`, `// Beats:`).
- **Double-Run Determinism**: All `qa/*.oo` verification probes must pass sequentially in fresh processes.
- **Banned File Names**: Prohibit generic drawer names (`util.oo`, `helpers.oo`, `common.oo`).

---

## 3. Local Verification Commands
```bash
cli build main.oo -o dist/cli
cli qa
```

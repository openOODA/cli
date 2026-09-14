# cli

The openOODA language CLI driver. Replaces the language surface of the
legacy `ooda` binary. Forwards no work — every verb is in-process.

## Install

```sh
curl -fsSL https://openooda.org/install.sh | bash
```

The installer places `cli` in `~/.openooda/bin/`. `oodac` (the compiler)
and `ooda-mcp` / `ooda-lsp` / `opm` (the operational drivers) must also
be installed for full functionality.

## Usage

```sh
cli build <file> [flags]      # compile a .oo file with oodac
cli run <file> [flags]        # compile and execute a .oo file
cli test <file> [--json]      # build and run a .oo test
cli fmt <file> [--check]      # reformat a .oo file in place
cli install [--to PATH]       # install the cli pack to a prefix
cli update                    # refresh stale binaries vs GitHub latest (sha256)
cli update --check            # report current vs latest, no writes
cli update --bootstrap        # full reinstall via install.sh (escape hatch)
cli init [name]               # scaffold a new project layout
cli qa [--all]                # run the local qa suite
cli context [dir] [--json]    # list .oo files under a directory
cli fix <file> [--yes]        # auto-fix common compile errors
cli token <sub>               # LLM token telemetry (forwards to ooda-tui)
cli version                   # print cli version
cli help                      # print usage
```

## Where each verb came from

`cli` is the trimmed surface of the legacy `ooda` binary. The full
redistribution is documented in `openOODA/audit/cli_split_2026_09_13.oot`
once Phase 8 lands. Quick map:

| Legacy `ooda <sub>` | New home |
|---|---|
| `build`, `run`, `test`, `fmt`, `install`, `update`, `upgrade`, `init`, `qa`, `context` (file listing), `fix`, `version`, `help` | `cli <sub>` |
| `token <sub>` | `cli token <sub>` (forwards to `ooda-tui /token <sub>`) |
| `opm`, `lsp`, `mcp`, `mcp-merge` | `ooda <sub>` (router unchanged) |
| `eval`, `repl` | (dead) — use `ooda-tui` shell |
| `bench`, `digest`, `health`, `sandbox status`, `swarm status` | `blackbox <sub>` |
| `gen` | `opm gen <sub>` |
| `sandbox run` | `ooda-tui /sandbox run` |
| `swarm init\|run` | `ooda-tui /teamwork init\|run` |
| `context --llm` | (dead) — `LLMS.oot` auto-loads in `ooda-tui` session start |

## Build from source

```sh
export OODA_COMPILER="$HOME/.openooda/bin/oodac"
ooda build main.oo -o dist/cli
```

## The Polyrepo

`cli` is one of 14 repos in the openOODA polyrepo.

| Repo | Purpose |
|------|---------|
| [openOODA/openOODA](https://github.com/openOODA/openOODA) | Governance, RFCs, laws |
| [openOODA/oodar](https://github.com/openOODA/oodar) | Runtime substrate |
| [openOODA/oodac](https://github.com/openOODA/oodac) | Compiler |
| [openOODA/std](https://github.com/openOODA/std) | Standard library |
| [openOODA/ooda](https://github.com/openOODA/ooda) | Back-compat router |
| [openOODA/cli](https://github.com/openOODA/cli) | This repo |
| [openOODA/install](https://github.com/openOODA/install) | How the toolchain lands |
| [openOODA/opm](https://github.com/openOODA/opm) | Package manager |
| [openOODA/catalog](https://github.com/openOODA/catalog) | Public package catalog |
| [openOODA/lsp](https://github.com/openOODA/lsp) | Language server |
| [openOODA/mcp](https://github.com/openOODA/mcp) | MCP server |
| [openOODA/bb](https://github.com/openOODA/bb) | Flight recorder and crash autopsy |
| [openOODA/ooda-tui](https://github.com/openOODA/ooda-tui) | AI harness |
| [openOODA/website](https://github.com/openOODA/website) | Website source |

## License

Dual-licensed under your choice of MIT or Apache 2.0. See `LICENSE`.

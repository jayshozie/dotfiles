# [Jayshozie](https://github.com/jayshozie)'s Development Environment

This repository represents a modular, "no-magic" dotfile management system
tailored for Arch Linux and Dvorak-optimized workflows. It prioritizes absolute
predictability, manual control over core tool versions, and minimal abstraction.

> [!NOTE]
> A thank you to a few incredible people: \
> [ThePrimeagen](https://github.com/ThePrimeagen) and
> [TJ DeVries](https://github.com/tjdevries), thank you guys. I wouldn't have
> been using Linux, Neovim, Tmux, or would've been write this repository if it
> weren't for you.

## Philosophy

* **Absolute Control**: Avoid "magic" managers (like Mason for LSP). Core tools
are often built from source to ensure specific versioning.
* **Modular Architecture**: Configurations are isolated into self-contained
modules.
* **XDG Compliance**: Forcefully adheres to the XDG Base Directory
Specification.
* **Predictable Deployment**: Uses a custom `rsync`-based engine rather than
symlink-heavy tools like GNU Stow to allow for clean directory merges.

## Core Architecture

### Deployment Engine: `run`
The `run` script is the primary entry point for deploying configurations. It
iterates through all directories in `modules/` and performs the following for
each:

1. **Validation**: Executes the module's `.check` script to verify system
dependencies (e.g., binaries, fonts, libraries).
2. **Privilege Check**: Checks for the existence of a `.sudo` file to determine
if root access is required for deployment.
3. **Destination Resolution**: Reads the `.dest` file (supporting environment
variables via `envsubst`) to determine the target path.
4. **Syncing**: Uses `rsync -cau` to sync the `payload/` directory into the
destination. This ensures a strict merge without the volatility of symlinks.

### Module Structure
A module is a directory within `modules/` containing:
* `payload/`: The actual configuration files to be deployed.
* `.dest`: A single line containing the target path (e.g.,
`${XDG_CONFIG_HOME}/nvim`).
* `.check`: An executable bash script that validates if the module's
requirements are met.
* `.sudo`: An empty file indicating the module requires `sudo` for
deployment (e.g., `/etc/` configs).
All of them, except the .dest file, are optional. For example, the module
`bulletty` doesn't contain a payload because of its internal structure; the
`clang-format` module doesn't contain a `.sudo` file because it's not necessary;
the module `asm-lsp` doesn't contain a `.dest` file because I don't use it
anymore, so the files in its `payload/` directory are completely ignored during
sync.

### Automation: `gen-module`
To maintain architectural consistency, the `gen-module` script facilitates the
scaffolding of new modules. It interactively prompts for:
* Module name.
* Payload requirement.
* Destination path.
* Sudo requirements.
* Primary binary for the `.check` script.

## System Bootstrapping

1. **`PISS.sh`**: The Post-Install Setup Script. Handles initial Arch Linux
configuration, including user creation (UID/GID 1000), package installation, and
system-level environment setup. It's incredibly opinionated and completely
written for me and myself only. I do recommend you checking it out if you're
writing something similar, because it handles a lot of edge-cases of an
automated post-installation script.
2. **`dev` script**: A custom build script to compile and install core tools
from source (Neovim, Tmux, Alacritty). This ensures bleeding-edge features and
specific compile-time flags, not that I use any, but it allows me to specify a
version and use that version for a longer time. The reason behind this script's
existence is the fact that I switched to Arch Linux and immediately ran into
issues regarding Neovim and Neovim's Treesitter. So I decided to write a script
that would lock its version as long as I want it to be locked.

## Usage

### Deployment
```bash
# Perform a dry-run to see what commands would be run
./run --dry-run

# Execute full deployment
./run
```

### Creating a New Module
```bash
# This is an interactive script
./gen-module
# Note: It lacks a dry-run currently but it's in progress
```

### System Maintenance
* **`update`**: A custom script located in `modules/scripts/payload/` that runs
`paru` and performs a post-update analysis to determine if a kernel or
system-level reboot is required.

## Libraries (`lib/`)
Shared utilities used by `run`, `gen-module`, and `.check` scripts:
* `log`: Standardized logging with support for `$DRY_RUN` prefixes.
* `ansi-escapes`: Consistent terminal color definitions (all 256 colors,
bold/italic/underline/dim etc., clear screen/line etc., and some definitions for
backwards compatibility, `ERR`, `WARN`, `SUCC`, `INFO`).
* `.check`: The standard template for module validation scripts.

---

# License

This repository is licensed under the GNU Public License v3.0. Please see the
[LICENSE](./LICENSE) file located at the repository root.

---

> [!WARNING]
> This [file](./README.md) is generated by `gemini-3-flash-preview`, because I
> hate writing README's.

---

<!--
# jayshozie's Development Environment

- **WIP:** A lot has changed since this README was last updated, I'll rewrite it
soon.

This is the modularized system configuration for my development environment. I
changed it from a simple Neovim config to a full XDG-compliant setup managed by
`GNU Stow`. Thank you [The Primeagen](https://github.com/theprimeagen) and
[TJ DeVries](https://github.com/tjdevries) for getting me into this stuff in
general.

The philosophy here is **Low-Level Control**:
- **No Mason:** LSP servers are configured manually in `lua/jaysh/lazy/lsp.lua`.
- **XDG Compliance:** All tools (Tmux, Neovim, Alacritty) are forced to respect
`~/.config`.
- **Dvorak:** Keybindings are optimized for the Dvorak layout.

## Architecture

This repository is structured for use with `stow`. Each top-level directory
corresponds to a package:

- **nvim**: Neovim configuration (Lazy.nvim, Manual LSP, Treesitter)
- **tmux**: Tmux 3.4+ configuration (XDG path, TPM, Tokyo Night)
- **bash**: Shell aliases, exports, and rc files
- **git**: Git user config and signing keys
- **alacritty**: Terminal emulator configuration

## Installation

1. **Clone the repo:**
   ```bash
   ~ $ git clone git@github.com:jayshozie/dotfiles.git ~/dotfiles
   ~ $ cd ~/dotfiles
   ```

2. **Bootstrap tmux:**
    ```bash
    ~/dotfiles $ git clone git@github.com/tmux-plugins/tpm ./tmux/.config/tmux/plugins/tpm
    ```

3. **Stow the packages:**
   ```bash
   ~/dotfiles $ stow nvim tmux bash git alacritty
   ```

> [!IMPORTANT]
> Don't forget to `prefix+i` to install the tmux packages.

## System Requirements

### Applications

These are the versions of the apps running on my machine, I can't guarantee that
this config files will work with lower versions, so I recommend you to use this
config with at least these versions of these programs.

| Application |   Version |
|:------------|----------:|
| `Neovim`    | `v0.11.5` |
| `tmux`      |     `3.4` |
| `Alacritty` | `v0.13.2` |
| `git`       |  `2.43.0` |
| `bash`      |  `5.2.21` |

### LSP Binaries

Since **Mason is removed**, you must ensure these binaries are in your `$PATH`
for Neovim features to work:

| Language     | Binary Name                  |                 Version |
|:-------------|:-----------------------------|------------------------:|
| **C/C++**    | `clangd`                     |                `21.1.8` |
| **Lua**      | `lua-language-server`        |                `3.15.0` |
| **Python**   | `pyright-langserver`         |               `1.1.407` |
| **TS/JS**    | `vtsls`                      |                   `IDK` |
| **Bash**     | `bash-language-server`       |                 `5.6.0` |
| **Markdown** | `marksman`, `markdown-oxide` | `2025-12-13`, `v0.25.9` |
| **~LaTeX~**  | `ltex-ls-plus`               |                `18.6.1` |

> [!NOTE]
> `ltex-ls-plus` is not working right now, I'll check the `lsp.lua` when I have
> the time.

## Info

### Neovim
- **Plugin Manager:** [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Plugins:**
    - [CMP](https://github.com/hrsh7th/nvim-cmp) (Completion Engine)
    - [Copilot](https://github.com/github/copilot.vim) (AI Assistant, though I
    - [Flominal](https://github.com/jayshozie/Flominal.nvim) (I wrote that btw.)
    don't use most of the time since I don't have that many tokens.)
    - [Key-Analyzer](https://github.com/jayshozie/key-analyzer.nvim) (I use my
    own fork.)
    - [Lualine](https://github.com/nvim-lualine/lualine.nvim) (Status Line)
    - [Notify](https://github.com/rcarriga/nvim-notify)
    - [Telescope](https://github.com/nvim-telescope/telescope.nvim) (Fuzzy
    Finder)
    - [Tokyo Night](https://github.com/folke/tokyonight.nvim) (Theme)
    - [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (Syntax
    Highlighting)
    - [Trouble](https://github.com/folke/trouble.nvim) (Diagnostics)
    - [Undotree](https://github.com/mbbill/undotree) (Undo History)

### Tmux
- **Plugin Manager:** [TPM](https://github.com/tmux-plugins/tpm)
- **Theme:** [Tokyo Night](https://github.com/janoamaral/tokyo-night-tmux)
- **Features:**
    - `clean_resurrect.sh`: Custom hook to strip NixOS/Vim paths from session
    saves to prevent broken sessions.
    - XDG Compliant (`~/.config/tmux/`).

## TODO

- [ ] Add debugging tools (`nvim-dap` is planned).
- [ ] Write a complete installation script for easy distro hopping.

# License

This repository is licensed under the GNU Public License v3.0. Please see the
[LICENSE](./LICENSE) file located at the repository root.
-->

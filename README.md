# jayshozie's Dotfiles

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

## Installation (Distro Hopping)

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

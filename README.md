# jayshozie's Dotfiles

This is the rewritten version of my old nvim config and some stuff added on it.
Finally got the LSP working for good. Again, many thanks to 
[TJ DeVries](https://github.com/tjdevries) and
[The Primeagen](https://github.com/theprimeagen) for their great videos that
helped me a lot.

> [!IMPORTANT]
> Most remaps are for dvorak, I use dvorak btw.

## Info

- Plugin Manager: [lazy.nvim](https://github.com/folke/lazy.nvim)

### Plugins

- [Flominal](https://github.com/jayshozie/Flominal.nvim) (Thanks, TJ, for the
    starting point.)
- [Indent Blankline](https://github.com/lukas-reineke/indent-blankline.nvim)
- LSP Related Plugins:
    - [Mason](https://github.com/mason-org/mason.nvim)
    - [CMP](https://github.com/hrsh7th/nvim-cmp)
    - [Copilot](https://github.com/github/copilot.vim)
- [Lualine](https://github.com/nvim-lualine/lualine.nvim)
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [Trouble](https://github.com/folke/trouble.nvim)
- [Undotree](https://github.com/mbbill/undotree)


## TODO

- [ ] Add debugging tools.
    - [ ] I'll probably use the helper plugin mason-nvim-dap.nvim, until I can
    solve the C/C++ LSP issue. I couldn't make `clangd` work without Mason, so
    until I figure that out, I'm stuck with Mason. When I fix that, I'll get
    rid of Mason completely.

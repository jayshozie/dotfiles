return {
  dir = "~/src/upstream/nvim-treesitter",
  name = "nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "asm",
        "bash",
        "c",
        "cmake",
        "cpp",
        "gitcommit",
        "gitignore",
        "git_config",
        "git_rebase",
        "hyprlang",
        "latex",
        "lua",
        "make",
        "markdown",
        "python",
        "query",
        "vim",
        "vimdoc",
        "markdown_inline",
        -- 'x86asm',
      },
      sync_install = true,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
  end,
}

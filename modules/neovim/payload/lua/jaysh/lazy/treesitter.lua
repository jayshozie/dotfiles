-- Copyright (C)  2026  Emir Baha YILDIRIM
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
        "git_config",
        "gitignore",
        "git_rebase",
        "hyprlang",
        "latex",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "nasm",
        "python",
        "query",
        "vim",
        "vimdoc",
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

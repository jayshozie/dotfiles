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
  -- dir = "~/src/upstream/nvim-treesitter",
  -- name = "nvim-treesitter",
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({})
    require("nvim-treesitter").install({
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
    }):wait(300000)

    -- Native replacement for the large file highlight disabler
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("large_file_treesitter", { clear = true }),
      callback = function(args)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
        if ok and stats and stats.size > max_filesize then
          vim.cmd("captreesitter stop") -- or vim.treesitter.stop(args.buf) depending on exact 0.12 API
          return true
        end
      end,
    })
  end,
}

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
  "MeanderingProgrammer/render-markdown.nvim",
  tag = "v8.11.0",
  -- if you use the mini.nvim suite
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
  -- if you use standalone mini plugins
  -- dependencies = {
  --   'nvim-treesitter/nvim-treesitter',
  --   'nvim-mini/mini.icons'
  -- },
  -- if you prefer nvim-web-devicons
  -- dependencies = {
  --   'nvim-treesitter/nvim-treesitter',
  --   'nvim-tree/nvim-web-devicons'
  -- },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    max_file_size = 50.0,
    completions = {
      lps = { enabled = true },
    },
  },
}

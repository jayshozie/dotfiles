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

local function Color(color)
  color = color or "tokyonight-moon"
  vim.cmd.colorscheme(color)
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
  {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({
        -- The theme comes in three styles, `storm`, `moon`, a darker variant
        -- `night` and `day`
        style = "moon",
        transparent = true,
        terminal_colors = true,
        styles = {
          -- i hate italic fonts
          comments = { italic = false },
          keywords = { italic = false },

          -- background styles: 'dark', 'transparent', or 'normal'
          sidebars = "dark",
          floats = "dark",
        },
      })
      Color()
    end,
  }
}

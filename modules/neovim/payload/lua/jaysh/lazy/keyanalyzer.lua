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
  -- I use my own version, but you can use the official one, because I'm
  -- not maintaining mine.
  "jayshozie/key-analyzer.nvim",
  branch = "uppercase-layout",
  config = function()
    require("key-analyzer").setup({
      -- Name of the command to use for the plugin
      command_name = "KeyAnalyzer", -- or nil to disable the command

      -- Customize the highlight groups
      highlights = {
        bracket_used = "KeyAnalyzerBracketUsed",
        letter_used = "KeyAnalyzerLetterUsed",
        bracket_unused = "KeyAnalyzerBracketUnused",
        letter_unused = "KeyAnalyzerLetterUnused",
        promo_highlight = "KeyAnalyzerPromo",

        -- Set to false if you want to define highlights manually
        define_default_highlights = true,
      },

      -- Keyboard layout to use
      -- Available options are:
      --   qwerty, colemak, colemak-dh, azerty, qwertz, dvorak
      layout = "dvorak",

      -- Should a link to https://x.com/OtivDev be displayed?
      promotion = false,
    })
  end,
}

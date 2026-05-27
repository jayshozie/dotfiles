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
  {
    "nvim-telescope/telescope.nvim",

    tag = "v0.1.9",

    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    config = function()
      require("telescope").setup({
        pickers = {
          find_files = {
            no_ignore = true,
            hidden = true,
          },
          grep_string = {
            no_ignore = true,
            hidden = true,
          },
          live_grep = {
            no_ignore = true,
            hidden = true,
          },
        },
      })

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
      vim.keymap.set("n", "<C-p>", builtin.git_files, {})
      vim.keymap.set("n", "<leader>pws", function()
        local word = vim.fn.expand("<cword>")
        builtin.live_grep({ search = word })
      end)
      vim.keymap.set("n", "<leader>pWs", function()
        local word = vim.fn.expand("<cWORD>")
        builtin.live_grep({ search = word })
      end)
      vim.keymap.set("n", "<leader>pg", function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end)
      vim.keymap.set("n", "<leader>pl", function()
        builtin.live_grep({})
      end)
      vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
    end,
  },
  {
    "nvim-telescope/telescope-symbols.nvim",
    config = function()
      vim.keymap.set(
        "i",
        "<C-s>",
        "<cmd>Telescope symbols<cr>",
        { desc = "Search Symbols" }
      )
    end,
  },
}

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
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",

  dependencies = { "rafamadriz/friendly-snippets" },

  config = function()
    local ls = require("luasnip")

    local function prepend_include()
      local header = "#include <stdio.h>"
      local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)

      for _, line in ipairs(lines) do
        if line:match(header) then
          return ""
        end
      end

      vim.api.nvim_buf_set_lines(0, 0, 0, false, { header, "" })
      return ""
    end

    -----------------
    -- Snippets --
    -----------------
    local debug_c_cpp = {
      ls.snippet("dberr", {
        ls.function_node(prepend_include, {}),
        ls.text_node('fprintf(stderr, "[DEBUG] '),
        ls.insert_node(1, ""),
        ls.text_node('\\n"'),

        ls.insert_node(2),
        ls.text_node(");"),
      }),
    }

    local emdash = {
      ls.snippet("emdash", {
        ls.text_node("—"),
      }),
    }

    local endash = {
        ls.snippet("endash", {
            ls.text_node("–"),
        }),
    }

    local today = {
      ls.snippet("today", {
        ls.text_node(os.date("%Y-%m-%d")),
      }),
    }

    local gpl3 = {
      ls.snippet("gpl3", {
        ls.text_node({
          "Copyright (C)  2026  Emir Baha YILDIRIM",
          "",
          "This program is free software: you can redistribute it and/or modify",
          "it under the terms of the GNU General Public License as published by",
          "the Free Software Foundation, either version 3 of the License, or",
          "(at your option) any later version.",
          "",
          "This program is distributed in the hope that it will be useful,",
          "but WITHOUT ANY WARRANTY; without even the implied warranty of",
          "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the",
          "GNU General Public License for more details.",
          "",
          "You should have received a copy of the GNU General Public License",
          "along with this program.  If not, see <https://www.gnu.org/licenses/>.",
        }),
      }),
    }

    local blog_more = {
      ls.snippet("blog_more", {
        ls.text_node({ "<!-- more -->" }),
      }),
    }

    local turkey = {
        ls.snippet("turkey", {
            ls.text_node({ "Türkiye" }),
        }),
    }

    ls.add_snippets("c", debug_c_cpp)
    ls.add_snippets("cpp", debug_c_cpp)
    ls.add_snippets("markdown", emdash)
    ls.add_snippets("markdown", endash)
    ls.add_snippets("all", today)
    ls.add_snippets("all", gpl3)
    ls.add_snippets("markdown", blog_more)
    ls.add_snippets("markdown", turkey)

    -------------
    -- Keymaps --
    -------------
    vim.keymap.set({ "i", "s" }, "<C-j>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<C-k>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { silent = true })
  end,
}

return {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
	build = "make install_jsregexp",

    dependencies = { "rafamadriz/friendly-snippets" },

    config = function()
        local ls = require('luasnip')

        local function prepend_include(args, snip, old_state)
            local header = '#include <stdio.h>'
            local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)

            for _, line in ipairs(lines) do
                if line:match(header) then
                    return ""
                end
            end

            vim.api.nvim_buf_set_lines(0, 0, 0, false, { header, '' })
            return ''
        end

        -----------------
        -- Snippets --
        -----------------
        local debug_c_cpp = {
            ls.snippet('dberr', {
                ls.function_node(prepend_include, {}),
                ls.text_node('fprintf(stderr, "[DEBUG] '),
                ls.insert_node(1, ''),
                ls.text_node('\\n"'),

                ls.insert_node(2),
                ls.text_node(');')
            })
        }

        ls.add_snippets('c', debug_c_cpp)
        ls.add_snippets('cpp', debug_c_cpp)

        -------------
        -- Keymaps --
        -------------
        vim.keymap.set({"i", "s"}, "<C-j>", function()
            if ls.expand_or_jumpable() then ls.expand_or_jump() end
        end, { silent = true })

        vim.keymap.set({"i", "s"}, "<C-k>", function()
            if ls.jumpable(-1) then ls.jump(-1) end
        end, { silent = true })
    end,
}

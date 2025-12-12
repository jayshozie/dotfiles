function Color(color)
    color = color or 'tokyonight-moon'
    vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
end

return {
    {
        'folke/tokyonight.nvim',
        config = function()
            require('tokyonight').setup({
                style = "moon", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                transparent = true,
                terminal_colors = true,
                styles = {
                    -- i hate italic fonts
                    comments = { italic = false },
                    keywords = { italic = false },

                    -- background styles: 'dark', 'transparent', or 'normal'
                    sidebars = 'dark',
                    floats = 'dark',
                }
            })
            Color()
        end,
    }
}

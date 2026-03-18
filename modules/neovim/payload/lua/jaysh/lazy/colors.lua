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
        style = "moon", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
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
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        -- List the filetypes you want to enable,
        -- or use '*' to apply these settings to all filetypes.
        "*",
      }, {
        -- These are the actual settings
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features
        css_fn = true, -- Enable all CSS *functions*
        mode = "background", -- Set the display mode
      })
    end,
  },
}

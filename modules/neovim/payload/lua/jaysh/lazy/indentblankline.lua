return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  opts = {},

  config = function()
    require("ibl").setup({
      whitespace = {
        highlight = {
          "Whitespace",
          "NonText",
        },
      },
    })
  end,
}

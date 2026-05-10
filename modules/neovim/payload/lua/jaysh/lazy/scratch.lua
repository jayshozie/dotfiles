return {
  dir = "~/src/upstream/scratch.nvim",
  name = "scratch.nvim",
  lazy = true,
  keys = {
    { "<M-.>", "<cmd>ScratchToggle<cr>", desc = "Toggle Scratch Buffer" },
  },
  cmd = {
    "ScratchToggle",
  },
  opts = {
    width = 0.8,
    height = 0.8,
    local_notes = false,
    global_notes = true,
    win_opts = {
      wrap = true,
      linebreak = true,
      number = true,
      relativenumber = true,
    },
  },
}

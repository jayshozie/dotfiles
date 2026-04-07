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

-------------------------------------SETS---------------------------------------

-- I hate the slim cursor, this looks much better.
vim.opt.guicursor = ""

--
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "81"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- C Stuff
vim.opt.exrc = true
vim.api.nvim_create_augroup("CStuff", {})
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = "CStuff",
  pattern = "c",
  callback = function()
    vim.bo.commentstring = "/* %s */"
  end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = "CStuff",
  pattern = "progress",
  callback = function()
    vim.bo.filetype = "c"
  end,
})

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

-- NETRW

-- Open files in split
-- 0 : re-use the same window (default)
-- 1 : horizontally splitting the window first
-- 2 : vertically   splitting the window first
-- 3 : open file in new tab
-- 4 : act like "P" (ie. open previous window)
vim.g.netrw_browse_split = 0

-- Netrw banner
-- 0 : Disable banner
-- 1 : Enable banner
vim.g.netrw_banner = 0

-- Netew winsize
vim.g.netrw_winsize = 50

-- Human-readable files sizes
vim.g.netrw_sizestyle = "H"

-- Netrw list style
-- 0 : thin listing (one file per line)
-- 1 : long listing (one file per line with timestamp information and file size)
-- 2 : wide listing (multiple files in columns)
-- 3 : tree style listing
vim.g.netrw_liststyle = 0

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.clipboard = "unnamedplus"
vim.opt.winborder = "rounded"

-- whitespace stuff
vim.api.nvim_create_augroup("WhitespaceGroup", {
  clear = true,
})
vim.api.nvim_set_hl(0, "WhitespaceHL", {
  bg = "#f7768e", -- background color will be tokyonight's red
})
vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "TermOpen" }, {
  group = "WhitespaceGroup",
  pattern = "*",
  callback = function()
    local filetype = vim.bo.filetype
    local buftype = vim.bo.buftype
    local matches = vim.fn.getmatches()
    for _, match_dict in ipairs(matches) do
      if match_dict.group == "WhitespaceHL" then
        vim.fn.matchdelete(match_dict.id)
      end
    end
    if filetype ~= "diff" and filetype ~= "lazy" and buftype ~= "terminal" then
      vim.fn.matchadd("WhitespaceHL", [[\s\+$\| \+\ze\t]])
    end
  end,
})

-------------------------------------REMAPS-------------------------------------

-- <space> is the superior leader.
vim.g.mapleader = " "
vim.g.localleader = " "
-- I use this a lot, helps a lot too.
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- I hate using Ctrl for that, and got used to this to switch windows.
vim.keymap.set("n", "<leader>w", "<C-w>")

vim.keymap.set("n", "<leader>g", ":Git<CR>")

-- Thanks a lot Primeagen. These are amazing.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- I forgot this existed, will use more.
vim.keymap.set("n", "J", "mzJ`z")

-- I just love these. Thanks again, Prime.
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Split resizing, makes it a lot faster.
vim.keymap.set("n", "<M-,>", "<c-w>5>")
vim.keymap.set("n", "<M-.>", "<c-w>5<")
vim.keymap.set("n", "<M-t>", "<c-w>5+")
vim.keymap.set("n", "<M-s>", "<c-w>5-")

-- tmux-sessionizer thanks to ThePrimeagen
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")
-- vim.keymap.set("n", "<M-t>", "<cmd>silent !tmux neww tmux-sessionizer -s 1<CR>")
-- vim.keymap.set("n", "<M-n>", "<cmd>silent !tmux neww tmux-sessionizer -s 2<CR>")
-- vim.keymap.set("n", "<M-s>", "<cmd>silent !tmux neww tmux-sessionizer -s 3<CR>")

-- Highlight when yanking, thanks TJ.
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup(
    "kicstart-hightlight-yank",
    { clear = true }
  ),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- To get out of terminal mode in a terminal window, thanks again TJ.
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

-- Never actually use these, but you never know.
-- greatest remap ever
-- vim.keymap.set("x", "<leader>p", [["_dP]])
-- next greatest remap ever : asbjornHaland
-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])
-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- I don't use it, so begone Q.
vim.keymap.set("n", "Q", "<nop>")
-- I'll use it more now that I have an actually working LSP config.
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")

-- Change the word under the cursor in the entire file.
vim.keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
)
-- Just amazing, thanks once again Primeagen.

-- Thanks Prime
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Opens ~/.config/nvim
-- vim.keymap.set('n', '<leader>vpp', '<cmd>e ~/dotfiles/nvim/.config/nvim/<CR>');
-- I use this more than I'd like to admit.

-- Helps a lot when rewriting the config.
vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)

-----------------------------------PLUGINS--------------------------------------

-- Load Lazy
require("jaysh.lazy_init")

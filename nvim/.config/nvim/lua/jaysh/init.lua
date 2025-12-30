
-------------------------------------SETS--------------------------------------


-- I hate the slim cursor, this looks much better.
vim.opt.guicursor = ''

--
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = '81'

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 50

-- vim.g.netrw_browse_split = 0
-- vim.g.netrw_banner = 0
vim.g.netrw_winsize = 50
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.o.clipboard = 'unnamedplus'
vim.opt.winborder = 'rounded'




-------------------------------------REMAPS------------------------------------


-- <space> is the superior leader.
vim.g.mapleader = ' '
vim.g.localleader = ' '
-- I use this a lot, help a lot too.
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
-- I hate using Ctrl for that, and got used to this to switch windows.
vim.keymap.set('n', '<leader>w', '<C-w>')

-- Thanks a lot Primeagen. These are amazing.
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- I forgot this existed, will use more.
vim.keymap.set('n', 'J', 'mzJ`z')

-- I just love these. Thanks again, Prime.
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Split resizing, makes it a lot faster.
vim.keymap.set('n', '<M-,>', '<c-w>5>')
vim.keymap.set('n', '<M-.>', '<c-w>5<')
vim.keymap.set('n', '<M-t>', '<c-w>5+')
vim.keymap.set('n', '<M-s>', '<c-w>5-')

-- Highlight when yanking, thanks TJ.
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kicstart-hightlight-yank', { clear = true }),
    callback  = function()
        vim.hl.on_yank()
    end,
})

-- To get out of terminal mode in a terminal window, thanks again TJ.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')

-- Never actually use these, but you never know.
-- greatest remap ever
-- vim.keymap.set("x", "<leader>p", [["_dP]])
-- next greatest remap ever : asbjornHaland
-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])
-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- I don't use it, so begone Q.
vim.keymap.set('n', 'Q', '<nop>')
-- I'll use it more now that I have an actually working LSP config.
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)

vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz')
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz')

-- Change the word under the cursor in the entire file.
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- Just amazing, thanks once again Primeagen.


-- I do this way more accidentally than intentionally, so nope.
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Don't remember what this does, so commented.
-- vim.keymap.set(
--     "n",
--     "<leader>ee",
--     "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
-- )

-- Opens ~/.config/nvim 
vim.keymap.set('n', '<leader>vpp', '<cmd>e ~/.config/nvim/<CR>');
-- I use this more than I'd like to admit.

-- Helps a lot when rewriting the config.
vim.keymap.set('n', '<leader><leader>', function()
    vim.cmd('so')
end)




-----------------------------------PLUGINS-------------------------------------
-- And all that good stuff.

-- Load Lazy
require('jaysh.lazy_init')

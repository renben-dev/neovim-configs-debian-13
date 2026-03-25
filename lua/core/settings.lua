local opt = vim.opt
local api = vim.api

-- history and memory tweaks
opt.undofile = true
opt.swapfile = false

-- Status bar
opt.showmode = true  -- Show mode in the command area (default is true)
opt.statusline = "%f %h%m%r %=%{getcwd()} %=%-14.(%l,%c%V%) %P"

-- Tabs and indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Scroll offset
opt.scrolloff = 8

-- Keymaps to save buffer with Ctrl+S
api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>a', { noremap = true, silent = true })
api.nvim_set_keymap('v', '<C-s>', ':w<CR>', { noremap = true, silent = true })

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  signs = true,
})

-- Enable folding using Treesitter
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 99      -- start with all folds open
vim.o.foldenable = true

-- make all yank/delete/put operations go through the + (system) register automatically
vim.opt.clipboard = "unnamedplus"

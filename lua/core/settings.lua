local opt = vim.opt
local api = vim.api

-- history and memory tweaks
opt.undofile = true
opt.swapfile = false

-- Status bar
opt.showmode = true -- Show mode in the command area (default is true)
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
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { silent = true, desc = "Save buffer without leaving insert mode" })
vim.keymap.set({ "n", "v" }, "<C-s>", ":w<CR>", { silent = true ,desc="Save buffer"})

vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	signs = true,
})

-- Enable folding using Treesitter
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99 -- start with all folds open
opt.foldenable = true

-- make all yank/delete/put operations go through the + (system) register automatically
opt.clipboard = "unnamedplus"

-- disable all highlight for json like files, renben: I encountered 60 sec open time on 8Mb json files
vim.cmd("syntax off")

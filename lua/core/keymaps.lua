local keymap = vim.keymap

-- The Big 3 / Cancellation (Table Item 3)
keymap.set('n', '<C-c>', '<Esc>')

-- Diagnostic Navigation (Table Items 31 & 33)
keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = "Show Error" })
keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Prev Error" })
keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next Error" })

-- LSP Formatting (Table Item 25)
-- keymap.set('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, { desc = "LSP Format" })
vim.keymap.set("n", "<leader>lf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })

-- Note: Items 4, 5, 6, 7, 8, 10, 11, 12, 13, 17, 18, 19, 23, 34, 35 
-- are native to Neovim and require ZERO configuration. They work out of the box.

-- Table Item 13: The "Black Hole" Delete (Doesn't overwrite your clipboard)
-- Map <leader>d to delete into the black hole register
keymap.set({'n', 'v'}, '<leader>d', [["_d]], { desc = "Delete to black hole" })

-- Table Item 31: Show Diagnostic (The floating error window)
keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = "Show Line Error" })

-- Table Items 33: Diagnostic Jumps
keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous Error" })
keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next Error" })

-- Buffer Navigation (Pro tip: use H and L to jump between open files)
keymap.set('n', 'L', ':bnext<CR>', { silent = true })
keymap.set('n', 'H', ':bprevious<CR>', { silent = true })

-- todo: to be categozied in mega table cheatsheet
vim.keymap.set('n', 'gd', '<cmd>FzfLua lsp_definitions<CR>', { desc = "Go to definition" })

-- Neovide GUI-specific mappings
if vim.g.neovide then
  -- Split navigation
  vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true })
  vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true })
  vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true })
  vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true })

  -- Buffer cycling
  vim.keymap.set('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })

  -- Optional splits creation
  vim.keymap.set('n', '<Leader>v', ':vsplit<CR>', { noremap = true })
  vim.keymap.set('n', '<Leader>s', ':split<CR>', { noremap = true })
end


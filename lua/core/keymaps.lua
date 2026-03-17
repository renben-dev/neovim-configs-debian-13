local keymap = vim.keymap

-- The Big 3 / Cancellation (Table Item 3)
keymap.set('n', '<C-c>', '<Esc>')

-- Diagnostic Navigation (Table Items 31 & 33)
keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = "Show Error" })
keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Prev Error" })
keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next Error" })

-- LSP Formatting (Table Item 25)
keymap.set('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, { desc = "LSP Format" })

-- Note: Items 4, 5, 6, 7, 8, 10, 11, 12, 13, 17, 18, 19, 23, 34, 35 
-- are native to Neovim and require ZERO configuration. They work out of the box.

-- Table Item 13: The "Black Hole" Delete (Doesn't overwrite your clipboard)
-- Map <leader>d to delete into the black hole register
keymap.set({'n', 'v'}, '<leader>d', [["_d]], { desc = "Delete to black hole" })

-- Table Item 25: LSP Format (Clean your code)
keymap.set('n', '<leader>lf', vim.lsp.buf.format, { desc = "LSP Format" })

-- Table Item 31: Show Diagnostic (The floating error window)
keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = "Show Line Error" })

-- Table Items 33: Diagnostic Jumps
keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous Error" })
keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next Error" })

-- Buffer Navigation (Pro tip: use H and L to jump between open files)
keymap.set('n', 'L', ':bnext<CR>', { silent = true })
keymap.set('n', 'H', ':bprevious<CR>', { silent = true })

local keymap = vim.keymap

-- The Big 3 / Cancellation (Table Item 3)
keymap.set("n", "<C-c>", "<Esc>")

-- Diagnostic Navigation (Table Items 31 & 33)
keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show Error" })
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Error" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Error" })

-- LSP Formatting (Table Item 25)
vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({ async = true, lsp_fallback = "fallback" })
end, { desc = "Format file" })

-- Note: Items 4, 5, 6, 7, 8, 10, 11, 12, 13, 17, 18, 19, 23, 34, 35
-- are native to Neovim and require ZERO configuration. They work out of the box.

-- Table Item 13: The "Black Hole" Delete (Doesn't overwrite your clipboard)
-- Map <leader>d to delete into the black hole register
keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to black hole" })

-- Table Item 31: Show Diagnostic (The floating error window)
keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show Line Error" })

-- Table Items 33: Diagnostic Jumps
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Error" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Error" })

-- tbd: add to cheat table. Buffer Navigation (Use H and L to jump between open files)
keymap.set("n", "L", ":bnext<CR>", { silent = true })
keymap.set("n", "H", ":bprevious<CR>", { silent = true })

-- 6. Window / Split Navigation (Available in Terminal & Neovide)
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Focus bottom window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Focus top window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })

keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { silent = true, desc = "Next buffer" })
keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { silent = true, desc = "Previous buffer" })

keymap.set("n", "<Leader>v", "<cmd>vsplit<CR>", { desc = "Vertical split" })
keymap.set("n", "<Leader>s", "<cmd>split<CR>", { desc = "Horizontal split" })

-- tbd: to be categozied in mega table cheatsheet
vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", { desc = "Go to definition" })

-- rename symbol scopewise
vim.keymap.set("n", "grn", vim.lsp.buf.rename, { desc = "Rename symbol" })

local function scroll_without_cursor(direction)
	local current_scrolloff = vim.opt.scrolloff:get()
	vim.opt.scrolloff = 0
	local key = direction == "up" and "<C-y>" or "<C-e>"
	vim.cmd("normal! " .. vim.api.nvim_replace_termcodes(key, true, true, true))
	vim.opt.scrolloff = current_scrolloff
end

vim.keymap.set({ "n", "v", "i", "t" }, "<ScrollWheelUp>", function()
	scroll_without_cursor("up")
end, { silent = true })

vim.keymap.set({ "n", "v", "i", "t" }, "<ScrollWheelDown>", function()
	scroll_without_cursor("down")
end, { silent = true })

-- Neovide GUI-specific mappings
if vim.g.neovide then
	-- Split navigation
	vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
	vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
	vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
	vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })

	-- Buffer cycling
	vim.keymap.set("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { noremap = true, silent = true })

	-- Optional splits creation
	vim.keymap.set("n", "<Leader>v", ":vsplit<CR>", { noremap = true })
	vim.keymap.set("n", "<Leader>s", ":split<CR>", { noremap = true })
end

local function set_json_selected(status)
	-- Use native Neovim treesitter API instead of external plugin utils
	local node = vim.treesitter.get_node()
	if not node then
		vim.notify("No treesitter parser found for this buffer", vim.log.levels.WARN)
		return
	end

	-- Traverse up tree to locate top level-1 item inside array
	local top_obj_node = nil
	local curr = node
	while curr do
		if curr:type() == "object" then
			local parent = curr:parent()
			if
				parent and parent:type() == "array" and parent:parent() == nil
				or (parent and parent:parent() and parent:parent():type() == "document")
			then
				top_obj_node = curr
				break
			else
				top_obj_node = curr
			end
		end
		curr = curr:parent()
	end

	if not top_obj_node then
		vim.notify("Cursor is not inside a JSON object", vim.log.levels.WARN)
		return
	end

	local start_row, _, end_row, _ = top_obj_node:range()
	local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)

	-- Check if "selected" field exists
	local found_idx = nil
	for i, line in ipairs(lines) do
		if line:match('"selected"%s*:') then
			found_idx = i
			break
		end
	end

	local target_val = status and "true" or "false"

	if found_idx then
		lines[found_idx] = lines[found_idx]:gsub('("selected"%s*:%s*)[%w]+', "%1" .. target_val)
	else
		local indent = lines[1]:match("^(%s*)") .. "  "
		local new_line = indent .. '"selected": ' .. target_val .. ","
		table.insert(lines, 2, new_line)
	end

	vim.api.nvim_buf_set_lines(0, start_row, end_row + 1, false, lines)
end

-- Fixed: Changed event from FileType to BufReadPost/BufNewFile for filename matching
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	pattern = "*select.json",
	callback = function(ev)
		vim.keymap.set("n", "<S-Right>", function()
			set_json_selected(true)
		end, { buffer = ev.buf, desc = "Set selected: true" })

		vim.keymap.set("n", "<S-Left>", function()
			set_json_selected(false)
		end, { buffer = ev.buf, desc = "Set selected: false" })
	end,
})

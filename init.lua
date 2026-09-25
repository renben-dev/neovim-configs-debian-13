-- ~/.config/nvim/init.lua
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- basic settings
vim.o.termguicolors = true


-- 5. Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- 5. Load plugins
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	rocks = {
    -- enabled = false,
		hererocks = true,
	},
})

-- 2. Load Editor Settings
require("core.settings")
require("core.fttabs")

-- 3 . Load custom defined keybingings
require("core.keymaps")

-- 4️⃣ Neovide-specific settings
if vim.g.neovide then
	-- Font settings
	vim.opt.guifont = "JetBrainsMono Nerd Font:h8" -- adjust size here
	-- Optional performance tweaks
	vim.g.neovide_refresh_rate = 60
	vim.g.neovide_cursor_vfx_mode = "railgun"
	vim.g.neovide_scroll_animation_length = 0
end


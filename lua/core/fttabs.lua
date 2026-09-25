-- File: ~/.config/nvim/lua/core/fttabs.lua
-- Automatically set tab/indentation per filetype
-- File: ~/.config/nvim/lua/core/fttabs.lua

local ft_tab_settings = {
	javascript = { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true },
	typescript = { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true },
	lua = { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true },
	html = { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true },
	css = { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true },
	json = { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true },
	yaml = { tabstop = 2, shiftwidth = 2, softtabstop = 2, xpandtab = true },
	go = { tabstop = 8, shiftwidth = 8, softtabstop = 2, expandtab = false },
	make = { tabstop = 8, shiftwidth = 8, softtabstop = 2, expandtab = false },
}

local group = vim.api.nvim_create_augroup("FileTypeCustomIndents", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = vim.tbl_keys(ft_tab_settings),
	callback = function(args)
		local cfg = ft_tab_settings[args.match]
		if cfg then
			vim.opt_local.tabstop = cfg.tabstop
			vim.opt_local.shiftwidth = cfg.shiftwidth
			vim.opt_local.softtabstop = cfg.tabstop
			vim.opt_local.expandtab = cfg.expandtab
		end
	end,
})
-- local ft_tab_settings = {
-- 	python = { tabstop = 4, shiftwidth = 4, expandtab = true },
-- 	javascript = { tabstop = 2, shiftwidth = 2, expandtab = true },
-- 	typescript = { tabstop = 2, shiftwidth = 2, expandtab = true },
-- 	lua = { tabstop = 2, shiftwidth = 2, expandtab = true },
-- 	rust = { tabstop = 4, shiftwidth = 4, expandtab = true },
-- 	c = { tabstop = 4, shiftwidth = 4, expandtab = true },
-- 	cpp = { tabstop = 4, shiftwidth = 4, expandtab = true },
-- 	go = { tabstop = 8, shiftwidth = 8, expandtab = false }, -- Go prefers real tabs
-- 	make = { tabstop = 8, shiftwidth = 8, expandtab = false }, -- Makefiles require tabs
-- 	html = { tabstop = 2, shiftwidth = 2, expandtab = true },
-- 	css = { tabstop = 2, shiftwidth = 2, expandtab = true },
-- 	json = { tabstop = 2, shiftwidth = 2, expandtab = true },
-- 	yaml = { tabstop = 2, shiftwidth = 2, expandtab = true },
-- }
--
-- -- Apply settings automatically when a filetype is detected
-- for ft, settings in pairs(ft_tab_settings) do
-- 	vim.api.nvim_create_autocmd("FileType", {
-- 		pattern = ft,
-- 		callback = function()
-- 			vim.opt_local.tabstop = settings.tabstop
-- 			vim.opt_local.shiftwidth = settings.shiftwidth
-- 			vim.opt_local.expandtab = settings.expandtab
-- 		end,
-- 	})
-- end

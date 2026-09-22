local always_show_in_vim_colortheme = true
local default_theme = "arctic"

local function get_lazy_toggle(theme_name)
	return default_theme ~= theme_name and not always_show_in_vim_colortheme
end

local function make_theme(repo, module_name, setup_fn, extra_opts)
	local theme_name = repo:match("/([^/]+)$") or repo
	if theme_name:match("%.nvim$") then
		theme_name = theme_name:gsub("%.nvim$", "")
	end
	local mod = module_name or theme_name

	local spec = {
		repo,
		lazy = get_lazy_toggle(theme_name),
		priority = 1000,
		config = function()
			if setup_fn then
				local ok, err = pcall(setup_fn, mod)
				if not ok and vim.in_fast_event() == false then
					vim.notify("Theme setup failed for " .. theme_name .. ": " .. tostring(err), vim.log.levels.ERROR)
				end
			end

			if default_theme == theme_name then
				vim.cmd.colorscheme(theme_name)
			end
		end,
	}

	if extra_opts then
		for k, v in pairs(extra_opts) do
			spec[k] = v
		end
	end

	return spec
end

return {
	-- make_theme("ishan9299/nvim-solarized-lua", "solarized", function(t)
	-- 	require(t).set()
	-- 	vim.o.background = "dark"
	-- end),
	make_theme("ishan9299/nvim-solarized-lua", "solarized", function()
		vim.g.solarized_italics = 1
		vim.g.solarized_visibility = "normal"
		vim.g.solarized_diffmode = "normal"
		vim.g.solarized_termtrans = 0
		vim.g.solarized_statusline = "normal"
		vim.o.background = "dark"
	end),
	make_theme("rebelot/kanagawa.nvim", "kanagawa", function(t)
		require(t).setup({ theme = "wave" })
	end),

	-- 🦊 Nightfox (multiple styles)
	make_theme("EdenEast/nightfox.nvim", "nightfox", function(t)
		require(t).setup({})
	end),

	-- 🐙 GitHub theme
	make_theme("projekt0n/github-nvim-theme", "github-theme", function(t)
		require(t).setup({})
	end),
	make_theme("craftzdog/solarized-osaka.nvim", "solarized-osaka", function(t)
		require(t).setup({
			transparent = false,
			terminal_colors = true,
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
			},
		})
	end),

	make_theme("folke/tokyonight.nvim", "tokyonight"),
	-- Gruvbox (Lua port)
	make_theme("ellisonleao/gruvbox.nvim", "gruvbox", function(t)
		vim.o.background = "dark"
	end),
	-- Gruvbox mor
	-- make_theme("morhetz/gruvbox", nil, function(t)
	-- 	vim.o.background = "dark" -- must set before colorscheme
	-- end),
	-- Catppuccin
	make_theme("catppuccin/nvim", "catppuccin", function(t)
		require(t).setup({
			flavour = "mocha", -- latte, frappe, macchiato, mocha
		})
	end),
	-- Everforest
	make_theme("sainnhe/everforest", "everforest", function(t)
		vim.o.background = "dark"
	end),
	-- VSCode Dark+
	make_theme("Mofiqul/vscode.nvim", "vscode", function(t)
		require("vscode").setup({
			style = "dark", -- "dark" or "light"
			transparent = false,
			italic_comments = true,
			terminal_colors = true,
		})
	end),
	-- VSCode Dark Modern / Arctic
	make_theme("rockyzhang24/arctic.nvim", "arctic", nil, { dependencies = { "rktjmp/lush.nvim" } }),
}

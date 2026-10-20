return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- Grab cmp capabilities so autocomplete works in TypeScript/JavaScript
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Configure vtsls
			vim.lsp.config("vtsls", {})

			-- Configure ESLint
			vim.lsp.config("eslint", {
				capabilities = capabilities,
				settings = {
					-- This lets ESLint dynamically switch its working directory to the
					-- sub-folder (studio/) where the local eslint.config.mjs lives
					workingDirectories = { { mode = "auto" } },
					-- Explicitly tell the server we are using modern Flat Configs
					experimental = { useFlatConfig = true },
				},
				-- This is the critical fix: Neovim 0.11 will look for these files
				-- starting from your .tsx file and moving upwards. It will stop at
				-- 'eslint.config.mjs' inside studio/ instead of flying up to '.git'.
				root_markers = {
					"eslint.config.mjs",
					"eslint.config.js",
					".eslintrc.js",
					".eslintrc.json",
					"package.json",
				},
			})

			-- Enable the LSPs globally (Neovim 0.11 automatically handles attaching
			-- them only to the correct filetypes like .ts, .tsx, .js, etc.)
			vim.lsp.enable("vtsls")
			vim.lsp.enable("eslint")
		end,
	},
}

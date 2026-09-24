return {
	-- Option 1: Visual rendering overlay
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
		opts = {
			pipe = {
				file_types = { "markdown", "codecompanion" },
				enabled = true,
			},
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	-- Option 2: Buffer plain-text auto-alignment
	{
		"dhruvasagar/vim-table-mode",
		ft = { "markdown", "codecompanion" },
		config = function()
			vim.g.table_mode_corner = "|"
		end,
	},
}

return {
	-- Option 1: Visual rendering overlay
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		opts = {
			pipe = {
				enabled = true,
			},
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	-- Option 2: Buffer plain-text auto-alignment
	{
		"dhruvasagar/vim-table-mode",
		ft = { "markdown" },
		config = function()
			vim.g.table_mode_corner = "|"
		end,
	},
}

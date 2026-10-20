return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    vim.opt.laststatus = 3 -- Sets the Neovim option when Lualine loads
  end,
  opts = {
    sections = {
      lualine_b = { "branch", "diff", "diagnostics" },
    },
    extensions = { "neo-tree" },
  },
}

return {
  "craftzdog/solarized-osaka.nvim",
  priority = 1000, -- load before other UI plugins
  config = function()
    require("solarized-osaka").setup({
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      },
    })

    vim.cmd.colorscheme("solarized-osaka")
  end,
}

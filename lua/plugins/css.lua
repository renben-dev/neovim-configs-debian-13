return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Configure the CSS language server
      vim.lsp.config("cssls", {
        -- Enable capabilities for CSS, SCSS, and LESS
        settings = {
          css = { validate = true },
          scss = { validate = true },
          less = { validate = true },
        },
      })

      -- Enable CSS LSP globally
      vim.lsp.enable("cssls")
    end,
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Configure the JSON language server
      vim.lsp.config("jsonls", {
        settings = {
          json = {
            validate = { enable = true },
          },
        },
      })

      -- Enable JSON LSP globally
      vim.lsp.enable("jsonls")
    end,
  },
}

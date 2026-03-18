return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

      lspconfig.clangd.setup({
        capabilities = cmp_capabilities,
        -- Mason-installed clangd will automatically be found in PATH
      })
    end,
  },
}

-- legacy
-- return {
--   "neovim/nvim-lspconfig",
--   config = function()
    -- require("lspconfig").rust_analyzer.setup({
    --   settings = {
    --     ["rust-analyzer"] = {
    --       cargo = { noDeps = true },
--         },
--       },
--     })
--   end,
-- }
return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.lsp.config("rust_analyzer", {
      settings = {
        ["rust-analyzer"] = {
          cargo = { noDeps = true },
        },
      },
    })

    vim.lsp.enable("rust_analyzer")
  end,
}

return { {
  "neovim/nvim-lspconfig",
  config = function()
    vim.lsp.config("vtsls",{});
    vim.lsp.config("eslint",{});

    vim.lsp.enable("vtsls");
    vim.lsp.enable("eslint");
  end
}
}

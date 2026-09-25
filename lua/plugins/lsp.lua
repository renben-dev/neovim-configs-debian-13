return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      vtsls = {
        cmd = {
          "vtsls",
          "--stdio",
          "--max-old-space-size=1024",
        },
        settings = {
          typescript = {
            tsserver = {
              maxTsServerMemory = 1024,
            },
          },
        },
      },
    },
  },
}

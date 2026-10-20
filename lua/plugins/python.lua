return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          on_attach = function(client, bufnr)
            local venv_path = os.getenv("VIRTUAL_ENV")
            if venv_path then
              client.config.settings.python.pythonPath = venv_path .. "/bin/python"
            end
          end,
        },
        ruff = {},
      },
    },
  },
  -- Debugger stays here
  { "mfussenegger/nvim-dap" },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-python").setup()
    end,
  },
}

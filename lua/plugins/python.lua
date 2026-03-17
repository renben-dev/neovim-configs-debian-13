return { -- Python LSP and Formatter setup via LSPConfig
{
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        -- Pyright for intelligent autocomplete and type checking
        local lspconfig = require("lspconfig")

        -- Setup Pyright
        lspconfig.pyright.setup({
            on_attach = function(client, bufnr)
                local venv_path = os.getenv("VIRTUAL_ENV")
                if venv_path then
                    client.config.settings.python.pythonPath = venv_path .. "/bin/python"
                end
            end
        })
        -- Ruff for blazing fast linting and formatting
        lspconfig.ruff.setup({})
    end
}, -- Debug Adapter Protocol (DAP) for Python
{"mfussenegger/nvim-dap"}, {
    "mfussenegger/nvim-dap-python",
    dependencies = {"mfussenegger/nvim-dap"},
    config = function()
        -- Let dap-python auto-detect debugpy installed by Mason
        require("dap-python").setup()
    end
}}

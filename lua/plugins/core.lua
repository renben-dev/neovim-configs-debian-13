-- ~/.config/nvim/lua/plugins/core.lua
return { -- Syntax Highlighting (Treesitter)
{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {"c", "lua", "vim", "vimdoc", "query", "python", "javascript", "typescript", "rust"},
            highlight = {
                enable = true
            },
            indent = {
                enable = true
            }
        })
    end
}, {
    "hrsh7th/cmp-nvim-lsp",
    dependencies = {"hrsh7th/nvim-cmp"} -- ensures cmp is present
}, -- LSP Infrastructure: Mason
{
    "williamboman/mason.nvim",
    opts = {}
}, -- LSP servers via Mason
{
    "williamboman/mason-lspconfig.nvim",
    version = "1.*",
    dependencies = {"williamboman/mason.nvim", "hrsh7th/cmp-nvim-lsp"},
    lazy = false, -- force early load
    opts = {
        ensure_installed = {"pyright", "ruff", "rust_analyzer", "vtsls", "eslint", "clangd"}
    },
    config = function(_, opts)
        local mlsp = require("mason-lspconfig")
        mlsp.setup({
            ensure_installed = opts.ensure_installed
        })
        mlsp.setup_handlers({function(server_name)
            local lspconfig = require("lspconfig")
            lspconfig[server_name].setup({
                capabilities = require("cmp_nvim_lsp").default_capabilities()
            })
        end})
    end
}, -- Auto-install formatters/debuggers

-- the below cannot uncommented yet because mason-tool-installer must catch up with the current mason version
-- {
--     "WhoIsSethDaniel/mason-tool-installer.nvim",
--     dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim"},
--     opts = {
--         ensure_installed = {"prettier", "clang-format", "debugpy", "codelldb"},
--         run_on_start = true,
--         start_delay = 3000
--     }
-- },
-- Fuzzy Finder
{
    "ibhagwan/fzf-lua",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    keys = {{
        "<leader>ff",
        "<cmd>fzf-lua files<cr>",
        desc = "Find Files"
    }, {
        "<leader>fg",
        "<cmd>fzf-lua live_grep<cr>",
        desc = "Live Proj Grep"
    }, {
        "<leader><space>",
        "<cmd>fzf-lua buffers<cr>",
        desc = "Switch Buffers"
    }},
    opts = {}
}, -- Bottom terminal
{
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = 15,
            open_mapping = [[<C-\>]],
            direction = "horizontal",
            shade_terminals = true,
            persist_mode = true
        })
    end
}, -- File navigation sidebar
{
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim"},
    keys = {{
        "<leader>e",
        "<cmd>Neotree toggle<cr>",
        desc = "Toggle NeoTree"
    }},
    opts = {
        filesystem = {
            filtered_items = {
                visible = true,
                hide_dotfiles = false
            }
        }
    }
}}

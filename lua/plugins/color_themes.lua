-- ~/.config/nvim/lua/plugins/colors.lua
 -- Tokyonight
return {
{
    "folke/tokyonight.nvim",
    lazy = false, -- load immediately
    priority = 1000, -- load early
    config = function()
        vim.cmd.colorscheme("tokyonight") -- set as active colorscheme
    end
}, -- Gruvbox (Lua port)
{
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        vim.o.background = "dark"
        -- vim.cmd.colorscheme("gruvbox") -- uncomment to activate
    end
}, -- Gruvbox mor
{
    "morhetz/gruvbox",
    lazy = false,
    priority = 1000,
    config = function()
        vim.o.background = "dark" -- must set before colorscheme
        -- vim.cmd.colorscheme("gruvbox")
    end
}, -- Catppuccin
{
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha" -- latte, frappe, macchiato, mocha
        })
        vim.cmd.colorscheme("catppuccin") -- uncomment to activate
    end
}, -- Everforest
{
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
        vim.o.background = "dark"
        -- vim.cmd.colorscheme("everforest") -- uncomment to activate
    end
}, -- VSCode Dark+
{
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("vscode").setup({
            style = "dark", -- "dark" or "light"
            transparent = false,
            italic_comments = true,
            terminal_colors = true
        })
        vim.cmd.colorscheme("vscode") -- uncomment to activate
    end
},
-- VSCode Dark Modern / Arctic
{
    "rockyzhang24/arctic.nvim",
    dependencies = {"rktjmp/lush.nvim"},
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("arctic")
    end
}}

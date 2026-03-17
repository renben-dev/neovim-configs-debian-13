return { -- Plugin 1: gp.nvim (Manual Prompting / Chat)
-- This replaces CodeCompanion because it works on Neovim 0.10 (Debian 13)
{
    "robitx/gp.nvim",
    config = function()
        require("gp").setup({
            providers = {
                googleai = {
                    endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}",
                    secret = os.getenv("GEMINI_API_KEY")
                }
            }
        })
    end
}, -- Plugin 2: Minuet AI (Manual-trigger Autocompletion)
{
    "milanglacier/minuet-ai.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},
    config = function()
        require("minuet").setup({
            provider = "gemini",
            provider_options = {
                gemini = {
                    api_key = os.getenv("GEMINI_API_KEY"),
                    model = "gemini-1.5-flash", -- Flash is better for 4GB RAM
                    system = "Provide only code snippets. No prose."
                }
            },
            request = {
                auto_trigger = false -- Saves your tokens
            }
        })
    end,
    -- This 'keys' section fixes the "rhs: expected nil" error
    keys = {{
        "<A-y>", -- Press Alt + y to get an AI completion
        function()
            require("minuet").make_cmp_request()
        end,
        mode = "i",
        desc = "Trigger AI Autocomplete"
    }}
}}

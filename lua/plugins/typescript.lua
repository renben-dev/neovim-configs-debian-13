return {{
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        -- Mason-installed servers are automatically detected
        lspconfig.vtsls.setup({})
        lspconfig.eslint.setup({})
    end
} :w
}

return {{
    'mrcjkb/rustaceanvim',
    version = '^5',
    ft = {'rust'},
    config = function()
        vim.g.rustaceanvim = {
            server = {
                default_settings = {
                    ['rust-analyzer'] = {
                        -- 4GB RAM Optimization
                        checkOnSave = true,
                        check = {
                            command = "clippy"
                        },
                        procMacro = {
                            enable = false
                        }, -- CRITICAL: Saves RAM
                        cargo = {
                            buildScripts = {
                                enable = true
                            }
                        }
                    }
                }
            }
        }
    end
}}

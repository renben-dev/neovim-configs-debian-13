-- ~/.config/nvim/init.lua
-- 1. Set Leaders, absolutely at Top of init.lua
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2. Load Editor Settings
require("core.settings")

-- 3 . Load custom defined keybingings
require("core.keymaps")

-- 3. Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
                   lazypath})
end
vim.opt.rtp:prepend(lazypath)

-- 4. Load Plugins
require("lazy").setup({
    spec = {{
        import = "plugins"
    }},
    performance = {
        rtp = {
            disabled_plugins = {"gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin"}
        }
    },
    rocks = {
        enabled = false
    }
})

-- 5. Set clipboard flow: seamless way: to set standard yank (`y`) and paste (`p`) to ALWAYS use the OS clipboard automatically
vim.opt.clipboard = "unnamedplus"

-- 6. If plugins written in these languages are not needed (which is 99% of modern Neovim setups),
-- explicitly disable for better startup time and warnings
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- notes: disable rocks not needed stuff to silence nvim checkhealth
-- Neovim supports writing plugins in languages like Node, Python, Ruby, and Perl.
-- The health check is warning you that it can't find the necessary bridges for some of these. 

-- 7. Disable hererocks in lazy setup
-- WHAT: Disables Lazy.nvim's built-in support for 'luarocks' (a Lua package manager)
--       and 'hererocks' (the script Lazy uses to install it).
-- WHY:  The automatic installation failed, causing annoying errors in `:checkhealth`.
--       Because none of our current plugins actually require Luarocks, we can safely
--       disable this feature entirely to clear the errors and simplify the setup.

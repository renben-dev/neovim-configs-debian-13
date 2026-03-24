-- ~/.config/nvim/init.lua
-- 1. Set Leaders, absolutely at Top of init.lua
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- basic settings
vim.o.termguicolors = true

-- 2. Load Editor Settings
require("core.settings")
require("core.fttabs")

-- 3 . Load custom defined keybingings
require("core.keymaps")

-- 4. Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 5. Load plugins
require("lazy").setup({
  { import = "plugins" }
})


-- 4️⃣ Neovide-specific settings
if vim.g.neovide then
    -- Font settings
    vim.opt.guifont = "JetBrainsMono Nerd Font:h8"  -- adjust size here

    -- Optional performance tweaks
    vim.g.neovide_refresh_rate = 60
    vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_scroll_animation_length = 0
end

-- Terminal background sync snippet
-- Robust terminal background sync for lazy-loaded themes
-- Terminal background sync (Neovim 0.10+)
-- Terminal background sync (Neovim 0.10+ safe, lazy.nvim friendly)
-- notes: disable rocks not needed stuff to silence nvim checkhealth
-- Neovim supports writing plugins in languages like Node, Python, Ruby, and Perl.
-- The health check is warning you that it can't find the necessary bridges for some of these.

-- Disable hererocks in lazy setup
-- WHAT: Disables Lazy.nvim's built-in support for 'luarocks' (a Lua package manager)
--       and 'hererocks' (the script Lazy uses to install it).
-- WHY:  The automatic installation failed, causing annoying errors in `:checkhealth`.
--       Because none of our current plugins actually require Luarocks, we can safely
--       disable this feature entirely to clear the errors and simplify the setup.

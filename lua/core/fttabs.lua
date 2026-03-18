-- File: ~/.config/nvim/lua/core/fttabs.lua
-- Automatically set tab/indentation per filetype
local ft_tab_settings = {
  python = { tabstop = 4, shiftwidth = 4, expandtab = true },
  javascript = { tabstop = 2, shiftwidth = 2, expandtab = true },
  typescript = { tabstop = 2, shiftwidth = 2, expandtab = true },
  lua = { tabstop = 2, shiftwidth = 2, expandtab = true },
  rust = { tabstop = 4, shiftwidth = 4, expandtab = true },
  c = { tabstop = 4, shiftwidth = 4, expandtab = true },
  cpp = { tabstop = 4, shiftwidth = 4, expandtab = true },
  go = { tabstop = 8, shiftwidth = 8, expandtab = false },  -- Go prefers real tabs
  make = { tabstop = 8, shiftwidth = 8, expandtab = false }, -- Makefiles require tabs
  html = { tabstop = 2, shiftwidth = 2, expandtab = true },
  css = { tabstop = 2, shiftwidth = 2, expandtab = true },
}

-- Apply settings automatically when a filetype is detected
for ft, settings in pairs(ft_tab_settings) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    callback = function()
      vim.opt_local.tabstop = settings.tabstop
      vim.opt_local.shiftwidth = settings.shiftwidth
      vim.opt_local.expandtab = settings.expandtab
    end,
  })
end

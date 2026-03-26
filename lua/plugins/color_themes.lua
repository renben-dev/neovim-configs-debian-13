-- ~/.config/nvim/lua/plugins/colors.lua
-- Tokyonight
return {
  -- 🌞 Solarized (original, Lua port)
  {
    "ishan9299/nvim-solarized-lua",
    lazy = true, -- load immediately
    priority = 1000,
    config = function()
      require("solarized").set()
      vim.o.background = "dark"
      vim.cmd.colorscheme("solarized")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy=true,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        theme = "wave", -- wave, dragon, lotus
      })
    end,
  },
  -- 🦊 Nightfox (multiple styles)
  {
    "EdenEast/nightfox.nvim",
    lazy=true,
    config = function()
      require("nightfox").setup({})
    end,
  },
  -- 🐙 GitHub theme
  {
    "projekt0n/github-nvim-theme",
    lazy=true,
    config = function()
      require("github-theme").setup({})
    end,
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy=true,
    priority = 1000, -- load before other UI plugins
    config = function()
      require("solarized-osaka").setup({
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
        },
      })

      vim.cmd.colorscheme("solarized-osaka")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy=true,
    priority = 1000,                    -- load early
    config = function()
      vim.cmd.colorscheme("tokyonight") -- set as active colorscheme
    end
  },
  -- Gruvbox (Lua port)
  {
    "ellisonleao/gruvbox.nvim",
    lazy=true,
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      -- vim.cmd.colorscheme("gruvbox") -- uncomment to activate
    end
  }, -- Gruvbox mor
  {
    "morhetz/gruvbox",
    lazy=true,
    priority = 1000,
    config = function()
      vim.o.background = "dark" -- must set before colorscheme
      -- vim.cmd.colorscheme("gruvbox")
    end
  }, -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy=true,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha"               -- latte, frappe, macchiato, mocha
      })
      vim.cmd.colorscheme("catppuccin") -- uncomment to activate
    end
  },                                    -- Everforest
  {
    "sainnhe/everforest",
    lazy=true,
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      -- vim.cmd.colorscheme("everforest") -- uncomment to activate
    end
  }, -- VSCode Dark+
  {
    "Mofiqul/vscode.nvim",
    lazy=true,
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
    dependencies = { "rktjmp/lush.nvim" },
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("arctic")
    end
  } }

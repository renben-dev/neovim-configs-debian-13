-- ~/.config/nvim/lua/plugins/completion.lua
return {
  -- Core completion engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",   -- LSP source
      "L3MON4D3/LuaSnip",       -- Snippets
      "saadparwaiz1/cmp_luasnip", -- Snippets completion
      "hrsh7th/cmp-buffer",     -- Buffer words
      "hrsh7th/cmp-path",       -- File paths
    },
    event = "InsertEnter", -- lazy-load on insert mode
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(), -- manual trigger
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- confirm selection
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}

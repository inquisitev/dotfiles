vim.pack.add({
   "https://github.com/hrsh7th/cmp-buffer",
   "https://github.com/hrsh7th/cmp-path",
   "https://github.com/hrsh7th/cmp-cmdline",
   "https://github.com/hrsh7th/cmp-nvim-lsp",
   "https://github.com/L3MON4D3/LuaSnip",
   "https://github.com/saadparwaiz1/cmp_luasnip",
   "https://github.com/hrsh7th/nvim-cmp",
})
local cmp = require("cmp")
local luasnip = require("luasnip")

vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#3b4261" })
vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = "#3b4261" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#282c34" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1a1b26", fg = "#c0caf5" })

local window_bordered = cmp.config.window.bordered({
   border = "single",
   winhighlight = "Normal:Normal,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
})

cmp.setup({
   window = {
      completion = window_bordered,
      documentation = window_bordered,
   },
   snippet = {
      expand = function(args)
         luasnip.lsp_expand(args.body)
      end,
   },
   mapping = cmp.mapping.preset.insert({
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
   }),
   sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
   }, {
      { name = "buffer" },
      { name = "path" },
   }),
   experimental = { ghost_text = true },
})

-- better yank/paste

vim.pack.add({
"https://github.com/kkharji/sqlite.lua",
"https://github.com/gbprod/yanky.nvim",
})

require("yanky").setup({
   ring = {
      history_length = 100,
      storage = "sqlite", -- optional, if you want persistence
   },
})
require("telescope").load_extension("yank_history")

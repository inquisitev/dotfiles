vim.pack.add({
   "https://github.com/mikavilpas/yazi.nvim",
   "https://github.com/folke/snacks.nvim",
})

require("yazi").setup({
   open_for_directories = false,
   keymaps = {
      show_help = "<f1>",
   },
})

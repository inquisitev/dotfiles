vim.pack.add({
   "https://github.com/mikavilpas/yazi.nvim",
   "https://github.com/folke/snacks.nvim",
})

require("yazi").setup({
   opts = {
      open_for_directories = false,
      keymaps = {
         show_help = "<f1>",
      },
   },
   init = function()
      vim.g.loaded_netrwPlugin = 1
   end,
})

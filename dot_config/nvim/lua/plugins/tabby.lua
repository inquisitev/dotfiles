vim.pack.add({
   "https://github.com/tiagovla/scope.nvim",
   "https://github.com/akinsho/bufferline.nvim"
   
})

require("scope").setup({})

vim.opt.termguicolors = true
require("bufferline").setup{}

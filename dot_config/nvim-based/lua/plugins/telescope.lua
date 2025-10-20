vim.pack.add({
   "https://github.com/nvim-lua/plenary.nvim",
   "https://github.com/propet/colorscheme-persist.nvim",
   "https://github.com/nvim-telescope/telescope.nvim",
})

require("telescope").setup({})
require("colorscheme-persist").setup()

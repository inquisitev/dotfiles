vim.pack.add({
   "https://github.com/nvim-lua/plenary.nvim",
   "https://github.com/propet/colorscheme-persist.nvim",
   "https://github.com/nvim-telescope/telescope.nvim",
})

require("telescope").setup({})

-- Override string color at the palette level so it's baked into the colorscheme
require("suannhai").setup({
   on_colors = function(colors)
      colors.string = "#2DFF10"
   end,
})

require("colorscheme-persist").setup({
   fallback = "suannhai-rouiro",
})

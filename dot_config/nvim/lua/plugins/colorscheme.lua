vim.pack.add({
   "https://github.com/rose-pine/neovim",
   "https://github.com/folke/tokyonight.nvim",
   "https://github.com/catppuccin/nvim",
   "https://github.com/rebelot/kanagawa.nvim",
   "https://github.com/scottmckendry/cyberdream.nvim",
   "https://github.com/oxfist/night-owl.nvim",
   "https://github.com/navarasu/onedark.nvim",
   "https://github.com/nvimdev/zephyr-nvim",
   "https://github.com/nyoom-engineering/oxocarbon.nvim",
   "https://github.com/serhez/teide.nvim",
   "https://github.com/WeiTing1991/suannhai.nvim",
   -- colorscheme-persist's picker is built on telescope
   "https://github.com/nvim-lua/plenary.nvim",
   "https://github.com/nvim-telescope/telescope.nvim",
   "https://github.com/propet/colorscheme-persist.nvim",
})

-- Override string color at the palette level so it's baked into the colorscheme
require("suannhai").setup({
   on_colors = function(colors)
      colors.string = "#2DFF10"
   end,
})

-- remembers the last scheme picked with <leader>sh
require("colorscheme-persist").setup({
   fallback = "suannhai-rouiro",
})

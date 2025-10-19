vim.pack.add({
   "https://github.com/rose-pine/neovim",
   "https://github.com/folke/tokyonight.nvim",
   "https://github.com/catppuccin/nvim",
   "https://github.com/rebelot/kanagawa.nvim",
   "https://github.com/nyoom-engineering/nyoom.nvim",
   "https://github.com/scottmckendry/cyberdream.nvim",
   "https://github.com/oxfist/night-owl.nvim",
   "https://github.com/navarasu/onedark.nvim",
})

-- local selected = "onedark"
-- require(selected).load()
-- vim.cmd.colorscheme(selected)
-- Lua
require("onedark").setup({
   style = "darker",
})
require("onedark").load()

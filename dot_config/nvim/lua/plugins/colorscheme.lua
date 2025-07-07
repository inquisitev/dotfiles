return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },
  { "rebelot/kanagawa.nvim"},
  { "scottmckendry/cyberdream.nvim" },
  {
    "inquisitev/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}

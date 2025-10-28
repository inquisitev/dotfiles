vim.pack.add({ { src = "https://github.com/alexghergh/nvim-tmux-navigation" } })

local map = vim.keymap.set
local nvim_tmux_nav = require("nvim-tmux-navigation")
map("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
map("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
map("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
map("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)

nvim_tmux_nav.setup({
   disable_when_zoomed = true, -- defaults to false
})

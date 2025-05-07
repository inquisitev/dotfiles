-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
map("n", "<S-tab>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", ";", ":", { desc = "enter command" })
map("n", "<leader>lg", function()
  Snacks.lazygit()
end, { desc = "Lazygit" })

local nvim_tmux_nav = require("nvim-tmux-navigation")

map("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
map("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
map("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
map("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
map("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
map("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)

map("n", "<A-j>", "<cmd>cnext<CR>", { desc = "quickfix next" })
map("n", "<A-k>", "<cmd>cprev<CR>", { desc = "quickfix previous" })
map("n", "<A-o>", "<cmd>copen<CR>", { desc = "quickfix open" })
map("n", "<A-x>", "<cmd>cclose<CR>", { desc = "quickfix close" })

map("n", "<leader>x", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

-- map("n", "<leader>e", "<leader>fE", { desc = "quickfix open" })
-- map("n", "<leader>E", "<leader>fe", { desc = "quickfix open" })

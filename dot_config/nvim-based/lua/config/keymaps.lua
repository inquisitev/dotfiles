-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
map("n", "<S-tab>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", ";", ":", { desc = "enter command" })

map("n", "<leader>/", "gcc", { remap = true, desc = "toggle comment" })
map("v", "<leader>/", "gc", { remap = true, desc = "toggle comment" })
map("n", "U", "<cmd>lua require('undotree').toggle()<cr>", { remap = true, desc = "Toggle UndoTree" })

map("n", "<c-l>", "<c-w>l", { remap = true, desc = "Window Rightj" })
map("n", "<c-k>", "<c-w>k", { remap = true, desc = "Window Up" })
map("n", "<c-j>", "<c-w>j", { remap = true, desc = "Window Down" })
map("n", "<c-h>", "<c-w>h", { remap = true, desc = "Window Left" })

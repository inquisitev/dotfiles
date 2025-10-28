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
map("n", "<c-l>", "<c-w>l", { remap = true, desc = "Window Right" })
map("n", "<c-k>", "<c-w>k", { remap = true, desc = "Window Up" })
map("n", "<c-j>", "<c-w>j", { remap = true, desc = "Window Down" })
map("n", "<c-h>", "<c-w>h", { remap = true, desc = "Window Left" })
map("n", "H", "<cmd>BufferPrevious<CR>", { remap = true, desc = "Window Right" })
map("n", "L", "<cmd>BufferNext<CR>", { remap = true, desc = "Window Up" })
map("n", "<leader>bo", ":%bd|e#|bd#<CR>", { noremap = true, silent = true, desc = "Close other buffers" })
map("n", "<leader>bn", ":enew<CR>", { noremap = true, silent = true, desc = "New blank buffer" })
map("n", "<leader>x", ":bd<CR>", { noremap = true, silent = true, desc = "Close this buffer" })
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "exit terminal mode" })
map("n", "<c-l>", "<c-w>l", { remap = true, desc = "Window Right" })


map("n", "<A-j>", "<cmd>cnext<CR>", { desc = "quickfix next" })
map("n", "<A-k>", "<cmd>cprev<CR>", { desc = "quickfix previous" })

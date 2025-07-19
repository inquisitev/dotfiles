-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
map("n", "<S-tab>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", ";", ":", { desc = "enter command" })
map("n", "<leader>lg", function()
  Snacks.lazygit()
end, { desc = "Lazygit", remap = true })

local nvim_tmux_nav = require("nvim-tmux-navigation")

map("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
map("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
map("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
map("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
map("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
map("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
map("n", "<A-j>", "<cmd>cnext<CR>", { desc = "quickfix next" })
map("n", "<A-k>", "<cmd>cprev<CR>", { desc = "quickfix previous" })

map("n", "<leader>x", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

vim.keymap.set("n", "<leader>tf", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>tc", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>tb", "<cmd>Telescope buffers<cr>", { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>thh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
vim.keymap.set("n", "<leader>to", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })
vim.keymap.set("n", "<leader>ts", "<cmd>Telescope grep_string<cr>", { desc = "Search Current Word" })
vim.keymap.set("n", "<leader>tt", "<cmd>Telescope treesitter<cr>", { desc = "Treesitter Symbols" })
vim.keymap.set("n", "<leader>tk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
vim.keymap.set("n", "<leader>tm", "<cmd>Telescope marks<cr>", { desc = "Marks" })
vim.keymap.set("n", "<leader>tr", "<cmd>Telescope registers<cr>", { desc = "Registers" })
vim.keymap.set("n", "<leader>tq", "<cmd>Telescope quickfix<cr>", { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>tl", "<cmd>Telescope loclist<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>ta", "<cmd>Telescope autocommands<cr>", { desc = "Autocommands" })
vim.keymap.set("n", "<leader>fi", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Fuzzy Find in Buffer" })

vim.keymap.set(
  "n",
  "<leader>tf",
  LazyVim.pick("files", { cwd = ".", root = false }),
  { desc = "Find file", remap = true }
)
vim.keymap.set("n", "<leader>th", function()
  require("telescope.builtin").colorscheme({
    enable_preview = true,
  })
end, { desc = "Select Colorscheme" })

vim.keymap.del("n", "<leader>/")
vim.keymap.set("n", "<leader>/", "gcc", { remap = true })
vim.keymap.set("v", "<leader>/", "gc", { remap = true })

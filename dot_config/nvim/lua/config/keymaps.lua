local map = vim.keymap.set

-- buffers
map("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-tab>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "L", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "H", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { silent = true, desc = "Close other buffers" })
map("n", "<leader>bn", "<cmd>enew<cr>", { silent = true, desc = "New blank buffer" })
map("n", "<leader>x", "<cmd>bd<cr>", { silent = true, desc = "Close this buffer" })

-- tabs
map("n", "<leader>[", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>tn", "<cmd>tab sb<cr>", { desc = "New tab" })

-- editing
map("n", ";", ":", { desc = "Enter command" })
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" })
map("v", "<leader>/", "gc", { remap = true, desc = "Toggle comment" })
map("n", "U", function() require("undotree").toggle() end, { desc = "Toggle UndoTree" })

-- quickfix
map("n", "<A-j>", "<cmd>cnext<cr>", { desc = "Quickfix next" })
map("n", "<A-k>", "<cmd>cprev<cr>", { desc = "Quickfix previous" })

-- terminal (window navigation <C-h/j/k/l> lives in plugins/nvim_tmux_navigator.lua)
map("t", "<esc><esc>", [[<c-\><c-n>]], { desc = "Exit terminal mode" })

map("n", "<leader>rr", function()
   dofile(vim.env.MYVIMRC)
   vim.notify("Config reloaded")
end, { desc = "Reload config" })

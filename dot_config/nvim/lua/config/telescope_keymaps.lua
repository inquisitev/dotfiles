local map = vim.keymap.set

map({ "n", "x" }, "<leader>tf", function()
   require("telescope.builtin").find_files()
end, { desc = "Find Files (Telescope)" })

map({ "n", "x" }, "<leader>tc", function()
   require("telescope.builtin").live_grep()
end, { desc = "Live Grep (Telescope)" })

map("n", "<leader>th", function()
   require("telescope.builtin").colorscheme({
      enable_preview = true,
   })
end, { desc = "Select Colorscheme" })

map({ "n", "x" }, "<leader>ty", "<cmd>Telescope yank_history<CR>", { desc = "Open Yank History (Telescope)" })

map("n", "<leader>sh", function()
   require("colorscheme-persist").picker({
      enable_preview = true,
   })
end, { desc = "Select Colorscheme" })

map("n", "<leader>tb", "<cmd>Telescope buffers<cr>", { desc = "Find Buffers" })
map("n", "<leader>tH", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
map("n", "<leader>to", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })
map("n", "<leader>ts", "<cmd>Telescope grep_string<cr>", { desc = "Search Current Word" })
map("n", "<leader>tk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
map("n", "<leader>tm", "<cmd>Telescope marks<cr>", { desc = "Marks" })
map("n", "<leader>tr", "<cmd>Telescope registers<cr>", { desc = "Registers" })
map("n", "<leader>tq", "<cmd>Telescope quickfix<cr>", { desc = "Quickfix List" })
map("n", "<leader>tl", "<cmd>Telescope loclist<cr>", { desc = "Location List" })
map("n", "<leader>ta", "<cmd>Telescope autocommands<cr>", { desc = "Autocommands" })
map("n", "<leader>fi", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Fuzzy Find in Buffer" })

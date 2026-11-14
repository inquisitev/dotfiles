local map = vim.keymap.set

-- hidden files/folders are included; .git itself is skipped
local hidden_rg_args = { "--hidden", "--glob", "!**/.git/*" }

map({ "n", "x" }, "<leader>tf", function()
   require("telescope.builtin").find_files({
      find_command = { "rg", "--files", "--color", "never", unpack(hidden_rg_args) },
   })
end, { desc = "Find Files incl. hidden (Telescope)" })

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
map({ "n", "x" }, "<leader>ts", function()
   require("telescope.builtin").grep_string({ additional_args = hidden_rg_args })
end, { desc = "Search Current Word incl. hidden" })
map("n", "<leader>tk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
map("n", "<leader>tm", "<cmd>Telescope marks<cr>", { desc = "Marks" })
map("n", "<leader>tr", "<cmd>Telescope registers<cr>", { desc = "Registers" })
map("n", "<leader>tq", "<cmd>Telescope quickfix<cr>", { desc = "Quickfix List" })
map("n", "<leader>tl", "<cmd>Telescope loclist<cr>", { desc = "Location List" })
map("n", "<leader>ta", "<cmd>Telescope autocommands<cr>", { desc = "Autocommands" })
map("n", "<leader>fi", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Fuzzy Find in Buffer" })

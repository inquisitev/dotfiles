local map = vim.keymap.set

map({ "n", "x" }, "<leader>tf", function()
   require("telescope.builtin").find_files()
end, { desc = "Find Files (Telescope)" })

map({ "n", "x" }, "<leader>tc", function()
   require("telescope.builtin").live_grep()
end, { desc = "Live Grep (Telescope))" })

map({ "n", "x" }, "<leader>ty", function()
   require("telescope.builtin").live_grep()
end, { desc = "Live Grep (Telescope))" })

map({ "n", "x" }, "<leader>ty", "<cmd>Telescope yank_history<CR>", { desc = "Live Grep (Telescope))" })

local map = vim.keymap.set

map({ "n", "x" }, "<leader>-", "<cmd>Yazi<cr>", { desc = "Open yazi at current file" })

map({ "n", "x" }, "<leader>cw", "<cmd>Yazi cwd<cr>", { desc = "Open yazi at nvims current working dir" })

map({ "n", "x" }, "<c-up>", "<cmd>Yazi toggle<cr>", { desc = "Resume last yazi session" })

local map = vim.keymap.set

map({ "n", "x", "o" }, "s", function()
   require("flash").jump()
end, { desc = "Flash" })

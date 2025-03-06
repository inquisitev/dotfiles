require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", "<", ",", { desc = "CMD enter command mode" })
map("n", ",", ";", { desc = "CMD enter command mode" })
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
-- map("i", "W", "w")


-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map({ "n", "t" }, "<A-i>", function()
    require("nvchad.term").toggle { pos = "float", id = "floatTerm", float_opts={
        row = 0.35,
        col = 0.05,
        width = 0.9,
        height = 0.5
    }}
end, { desc = "terminal toggle floating term" })


map("n", "m", "<cmd>cnext<CR>")
map("n", "M", "<cmd>cprev<CR>")
map("n", "<C-m>", "<cmd>cclose<CR>")

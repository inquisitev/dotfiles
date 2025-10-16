local map = vim.keymap.set

map({ "n", "x" }, "<leader>ty", function()
   require("telescope").extensions.yank_history.yank_history({})
end, { desc = "Open Yank History" })

map({ "n", "x" }, "y", "<Plug>(YankyYank)", { desc = "Yank text" })
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put yanked text after cursor" })
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put yanked text before cursor" })
map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "Put yanked text after selection" })
map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "Put yanked text before selection" })
map("n", "<c-p>", "<Plug>(YankyPreviousEntry)", { desc = "Select previous entry through yank history" })
map("n", "<c-n>", "<Plug>(YankyNextEntry)", { desc = "Select next entry through yank history" })
map("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put indented after cursor (linewise)" })
map("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put indented before cursor (linewise)" })
map("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put indented after cursor (linewise)" })
map("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put indented before cursor (linewise)" })
map("n", "=p", "<Plug>(YankyPutAfterFilter)", { desc = "Put after applying a filter" })
map("n", "=P", "<Plug>(YankyPutBeforeFilter)", { desc = "Put before applying a filter" })

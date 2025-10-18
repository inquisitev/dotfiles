vim.pack.add({
   {
      src = "https://github.com/nvim-lua/plenary.nvim",
   },
   {
      src = "https://github.com/ThePrimeagen/harpoon",
      branch = "harpoon2",
   },
})

local map = vim.keymap.set
local harpoon = require("harpoon")
harpoon:setup()

map({ "n", "x" }, "<leader>h", function()
   harpoon:list():add()
end, { remap = true, desc = "Add file (Harpoon)" })

map({ "n", "x" }, "<leader>H", function()
   harpoon.ui:toggle_quick_menu(harpoon:list())
end, { remap = true, desc = "Show files (Harpoon)" })

for i = 1, 10 do
   map({ "n", "x" }, "<leader>" .. i, function()
      harpoon:list():select(i)
   end, { desc = "Nav to file " .. i .. " (Harpoon)" })
end

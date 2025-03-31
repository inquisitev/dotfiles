return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy=false,
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, {desc="Harpoon Add"})
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      local keys = { 
         1, 
         2, 
         3, 
         4
      }

      for _, index in ipairs(keys) do
         vim.keymap.set("n", "<C-" .. index .. ">", function()
             harpoon:list():select(index)
             vim.cmd('normal! zz')
         end, { desc = "Open harpooned buffer" .. index })
      end

              -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Previous harpooned buffer" })
      vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Next harpooned buffer" })


    end
  }
}

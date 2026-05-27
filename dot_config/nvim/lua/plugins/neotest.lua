-- neotest core
vim.pack.add({
  "https://github.com/nvim-neotest/neotest",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-neotest/neotest-python"
})

-- lua/config/neotest.lua
-- 2) Defer setup until runtimepath is updated
vim.schedule(function()
  local neotest = require("neotest")

  neotest.setup({
    adapters = {
      require("neotest-python")
    },
  })

  -- 3) Keymaps (<leader>T...)
  vim.keymap.set("n", "<leader>Tt", function()
    neotest.run.run()
  end, { desc = "Test: run nearest" })

  vim.keymap.set("n", "<leader>Tf", function()
    neotest.run.run(vim.fn.expand("%"))
  end, { desc = "Test: run file" })

  vim.keymap.set("n", "<leader>Ts", function()
    neotest.summary.toggle()
  end, { desc = "Test: summary toggle" })

  vim.keymap.set("n", "<leader>To", function()
    neotest.output.open({ enter = true })
  end, { desc = "Test: open output" })

  vim.keymap.set("n", "<leader>Tl", function()
    neotest.run.run_last()
  end, { desc = "Test: run last" })
  
   vim.api.nvim_create_autocmd("BufWritePost", {
     pattern = { "test_*.py", "*_test.py" },
     callback = function()
       local neotest = require("neotest")
       neotest.run.run(vim.fn.expand("%"))
     end,
   })

end)


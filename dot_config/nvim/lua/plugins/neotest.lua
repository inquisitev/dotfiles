-- neotest core
vim.pack.add({
  "https://github.com/nvim-neotest/neotest",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-neotest/neotest-python"
})

vim.schedule(function()
  local neotest = require("neotest")

  neotest.setup({
    adapters = {
      require("neotest-python"),
    },
    watch = { enabled = false },
    summary = {
      mappings = { watch = {} },
    },
  })

  -- Run
  vim.keymap.set("n", "<leader>Tt", function()
    neotest.run.run()
  end, { desc = "Test: run nearest" })

  vim.keymap.set("n", "<leader>Tf", function()
    neotest.run.run(vim.fn.expand("%"))
  end, { desc = "Test: run file" })

  vim.keymap.set("n", "<leader>Tl", function()
    neotest.run.run_last()
  end, { desc = "Test: run last" })

  -- Debug (neotest passes strategy="dap" to the adapter which handles it)
  vim.keymap.set("n", "<leader>Td", function()
    neotest.run.run({ strategy = "dap" })
  end, { desc = "Test: debug nearest" })

  vim.keymap.set("n", "<leader>TD", function()
    neotest.run.run({ vim.fn.expand("%"), strategy = "dap" })
  end, { desc = "Test: debug file" })

  -- UI
  vim.keymap.set("n", "<leader>Ts", function()
    neotest.summary.toggle()
  end, { desc = "Test: summary toggle" })

  vim.keymap.set("n", "<leader>To", function()
    neotest.output.open({ enter = true })
  end, { desc = "Test: open output" })

end)

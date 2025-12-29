-- neotest core
vim.pack.add({
  "nvim-neotest/neotest",
  "nvim-lua/plenary.nvim",
  "nvim-treesitter/nvim-treesitter",

  -- CTest adapter
  "nvim-neotest/neotest-ctest",
})

local neotest = require("neotest")

neotest.setup({
  adapters = {
    require("neotest-ctest").setup({
      -- Optional but useful defaults
      ctest_command = "tox",
      build_dir = "build",      -- common CMake out-of-source build dir
      args = { "--output-on-failure" },
    }),
  },
})

vim.keymap.set("n", "<leader>tt", function()
  require("neotest").run.run()
end, { desc = "Run nearest test" })

vim.keymap.set("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run file tests" })

vim.keymap.set("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, { desc = "Toggle test summary" })

vim.keymap.set("n", "<leader>to", function()
  require("neotest").output.open({ enter = true })
end, { desc = "Open test output" })


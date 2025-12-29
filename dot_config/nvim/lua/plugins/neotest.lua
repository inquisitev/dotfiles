-- neotest core
vim.pack.add({
  "nvim-neotest/neotest",
  "nvim-lua/plenary.nvim",
  "nvim-treesitter/nvim-treesitter",

  -- CTest adapter
  "nvim-neotest/neotest-ctest",
})

local neotest = require("neotest")

require("neotest").setup({
  adapters = {
    require("neotest-ctest").setup({
      ctest_command = "tox",
      build_dir = "build",
      args = { "--output-on-failure" },
    }),
  },
})

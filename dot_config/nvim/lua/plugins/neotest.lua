-- neotest core
vim.pack.add({
  "https://github.com/nvim-neotest/neotest",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/orjangj/neotest-ctest"
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

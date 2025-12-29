-- neotest core
vim.pack.add({
  "https://github.com/nvim-neotest/neotest",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/orjangj/neotest-ctest"
})
-- lua/config/neotest.lua
-- 2) Defer setup until runtimepath is updated
vim.schedule(function()
  local ok_neotest, neotest = pcall(require, "neotest")
  if not ok_neotest then
    vim.notify("neotest not found", vim.log.levels.ERROR)
    return
  end

  local ok_ctest, ctest = pcall(require, "neotest-ctest")
  if not ok_ctest then
    vim.notify("neotest-ctest not found", vim.log.levels.ERROR)
    return
  end

  neotest.setup({
    adapters = {
      ctest.setup({
        ctest_command = "tox",   -- DIRECT ctest (no tox)
        build_dir = "build",
        args = { "--output-on-failure" },
      }),
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
end)


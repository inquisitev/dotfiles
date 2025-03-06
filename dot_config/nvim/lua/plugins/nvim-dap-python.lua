return {
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      vim.keymap.set("n", "<leader>dtc", function() require('dap-python').test_method() end,{desc="Debug test method"} )
      vim.keymap.set("n", "<leader>dtt", function() require('dap-python').test_class() end,{desc="Debug test class"} )

      require('dap-python').setup('python')
      table.insert(require('dap').configurations.python, {
        type = 'python',
        request = 'launch',
        module = 'pytest',
        name = 'Run Tests',
        args={
              "${file}"
          }
      })
    end
  }
}

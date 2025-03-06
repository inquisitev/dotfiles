return {
  {
    "mfussenegger/nvim-dap",
    config = function()
       vim.keymap.set("n", "<leader>dc", function() require('dap').continue() end, {desc="Continue debugging"})
       vim.keymap.set("n", "<leader>dx", function() require('dap').terminate() end, {desc="Terminate debugging"})
       vim.keymap.set("n", "<leader>di", function() require('dap.ui.widgets').hover() end,{desc="inspect value"} )
       vim.keymap.set("n", "m", function() require('dap').step_over() end,{desc="Step Over"} )
       vim.keymap.set("n", "n", function() require('dap').step_into() end,{desc="Step Into"} )
       vim.keymap.set("n", "<leader>dp", function() require('dap').toggle_breakpoint() end, {desc="Toggle Breakpoint"})
    end
  }
}



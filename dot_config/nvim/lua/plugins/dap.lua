return {
  { "nvim-neotest/nvim-nio" },
  { "Weissle/persistent-breakpoints.nvim" },
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local pdap = require("persistent-breakpoints.api")
      local dapui = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      require("persistent-breakpoints").setup({
        load_breakpoints_event = { "BufReadPost" },
      })

      local home_dir = vim.fn.getenv("HOME")

      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = home_dir .. "/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
      }

      -- if the system is configured with this particular adapter, use it.
      local jd_debug_adapter_name = vim.fn.getenv("JD_DEBUG_ADAPTER")
      local ok, jd_debug_adapter = pcall(require, jd_debug_adapter_name)
      if ok and jd_debug_adapter.is_supported_repo() then
        local target_ip = vim.fn.getenv("TARGET_IP")
        local gdb_server_port = vim.fn.getenv("GDB_SERVER_PORT")
        local gdb_path = vim.fn.getenv("GDB_PATH")
        jd_debug_adapter.setup(target_ip, gdb_server_port, gdb_path)
      else
        dap.configurations.cpp = {
          {
            name = "Launch",
            type = "cppdbg",
            request = "launch",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},
          },
        }

        vim.fn.setenv("DAP_LOG_FILE", vim.fn.stdpath("cache") .. "/dap.log")
        vim.fn.setenv("DAP_LOG_LEVEL", "TRACE")

        vim.keymap.set("n", "<A-n>", function()
          dap.continue()
        end, { desc = "DAP Continue" })

        vim.keymap.set("n", "<A-o>", function()
          dap.step_over()
        end, { desc = "DAP Step Over" })

        vim.keymap.set("n", "<A-i>", function()
          dap.step_into()
        end, { desc = "DAP Step Into" })

        vim.keymap.set("n", "<Leader>ds", function()
          dap.step_out()
        end, { desc = "DAP Step Out" })

        vim.keymap.set("n", "<Leader>dr", function()
          dap.repl.open()
        end, { desc = "DAP Open REPL" })

        vim.keymap.set("n", "<Leader>du", function()
          dapui.toggle()
        end, { desc = "DAP UI Toggle" })

        vim.keymap.set("n", "<Leader>db", function()
          pdap.toggle_breakpoint()
        end, { desc = "DAP Toggle Breakpoint" })

        vim.keymap.set("n", "<Leader>dC", function()
          pdap.set_conditional_breakpoint()
        end, { desc = "DAP Set Custom Conditional Breakpoint" })

        vim.keymap.set("n", "<Leader>dl", function()
          pdap.set_log_point()
        end, { desc = "DAP Add Log Point" })
      end
    end,
  },
}

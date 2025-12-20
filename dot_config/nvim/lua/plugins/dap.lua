vim.pack.add({
   "https://github.com/nvim-neotest/nvim-nio",
   "https://github.com/mfussenegger/nvim-dap",
   "https://github.com/rcarriga/nvim-dap-ui",
   "https://github.com/theHamsta/nvim-dap-virtual-text"
})


local dap = require("dap")
local dapui = require("dapui")

dapui.setup()
require("nvim-dap-virtual-text").setup()

local ok, jd_debug_adapter = pcall(require, jd_debug_adapter_name)
if ok and jd_debug_adapter.is_supported_repo() then
  local target_ip = vim.fn.getenv("TARGET_IP")
  local gdb_server_port = vim.fn.getenv("GDB_SERVER_PORT")
  local gdb_path = vim.fn.getenv("GDB_PATH")
  jd_debug_adapter.setup(target_ip, gdb_server_port, gdb_path)
else
  -- dap.configurations.cpp = {
  --   {
  --     name = "Launch",
  --     type = "cppdbg",
  --     request = "launch",
  --     program = function()
  --       return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
  --     end,
  --     cwd = "${workspaceFolder}",
  --     stopOnEntry = false,
  --     args = {},
  --   },
  -- }
  -- Python configuration
  -- dap.adapters.python = function(cb, config)
  --   if config.request == "attach" then
  --     ---@diagnostic disable-next-line: undefined-field
  --     local port = (config.connect or config).port
  --     ---@diagnostic disable-next-line: undefined-field
  --     local host = (config.connect or config).host or "127.0.0.1"
  --     cb({
  --       type = "server",
  --       port = assert(port, "`connect.port` is required for a python `attach` configuration"),
  --       host = host,
  --       options = {
  --         source_filetype = "python",
  --       },
  --     })
  --   else
  --     cb({
  --       type = "executable",
  --       command = "python",
  --       args = { "-m", "debugpy.adapter" },
  --       options = {
  --         source_filetype = "python",
  --       },
  --     })
  --   end
  -- end
  --
  -- dap.configurations.python = {
  --   {
  --     type = "python",
  --     request = "launch",
  --     name = "Launch file",
  --     program = "${file}",
  --     pythonPath = function()
  --       -- Virtual env detection
  --       local cwd = vim.fn.getcwd()
  --       if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
  --         return cwd .. "/venv/bin/python"
  --       elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
  --         return cwd .. "/.venv/bin/python"
  --       else
  --         return "/usr/bin/python"
  --       end
  --     end,
  --   },
  --   {
  --     type = "python",
  --     request = "launch",
  --     name = "Launch with args",
  --     program = "${file}",
  --     args = function()
  --       return vim.split(vim.fn.input("Args: "), " ")
  --     end,
  --     pythonPath = function()
  --       local cwd = vim.fn.getcwd()
  --       if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
  --         return cwd .. "/venv/bin/python"
  --       elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
  --         return cwd .. "/.venv/bin/python"
  --       else
  --         return "/usr/bin/python"
  --       end
  --     end,
  --   },
  -- }

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
    dap.set_breakpoint()
  end, { desc = "DAP Toggle Breakpoint" })

  vim.keymap.set("n", "<Leader>dC", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, { desc = "DAP Set Custom Conditional Breakpoint" })

  vim.keymap.set("n", "<Leader>dl", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
  end, { desc = "DAP Add Log Point" })
end

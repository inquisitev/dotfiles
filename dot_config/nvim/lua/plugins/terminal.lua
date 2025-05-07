-- toggleterm.lua
-- ToggleTerm plugin specification for lazy.nvim

return {
  "akinsho/toggleterm.nvim",
  enabled = false,
  version = "*",
  keys = {
    { "<A-i>", desc = "Toggle floating terminal" },
  },
  opts = {
    -- Size can be a number or function
    size = function(term)
      if term.direction == "float" then
        return 20 -- Height for floating terminal
      elseif term.direction == "horizontal" then
        return 15 -- Height for horizontal split
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4 -- Width for vertical split
      end
    end,

    -- Style for floating windows
    float_opts = {
      border = "rounded",
      width = function()
        return math.floor(vim.o.columns * 0.6) -- 60% of screen width
      end,
      height = function()
        return math.floor(vim.o.lines * 0.7) -- 70% of screen height
      end,
      winblend = 0,
      -- Position in top right
      row = 1,
      col = function()
        return vim.o.columns - math.floor(vim.o.columns * 0.6) - 1 -- Aligned to right side
      end,
    },

    -- Default settings
    start_in_insert = true,
    direction = "float",
    close_on_exit = true,
    auto_scroll = true,
  },

  config = function(_, opts)
    -- Initialize the plugin with options
    require("toggleterm").setup(opts)

    -- Create a single persistent floating terminal instance
    local float_term = require("toggleterm.terminal").Terminal:new({
      cmd = vim.o.shell,
      direction = "float",
      -- Use the float_opts from the plugin config
      float_opts = opts.float_opts,
      -- Hide the terminal when toggled off
      hidden = true,
      -- Set terminal ID to ensure we toggle the same instance
      id = 100,
      on_open = function(term)
        -- Enter insert mode when terminal opens
        vim.cmd("startinsert!")
        -- Set terminal-specific keymaps if needed
      end,
      on_close = function(term)
        -- Return to normal mode when terminal closes
        vim.cmd("stopinsert")
      end,
    })

    -- Set keybinding for Alt+i to toggle the floating terminal
    vim.keymap.set({ "n", "i", "t", "v" }, "<A-i>", function()
      -- Toggle the terminal - this will show/hide the same instance
      float_term:toggle()
    end, { desc = "Toggle floating terminal", noremap = true, silent = true })

    -- Optional: Set additional keybindings or configurations here

    -- You could add more specialized terminals here if needed
    -- Example: lazygit terminal
    -- vim.keymap.set("n", "<leader>gg", function()
    --   local lazygit = require("toggleterm.terminal").Terminal:new({
    --     cmd = "lazygit",
    --     direction = "float",
    --     hidden = true,
    --   })
    --   lazygit:toggle()
    -- end, {desc = "Lazygit", noremap = true, silent = true})
  end,
}

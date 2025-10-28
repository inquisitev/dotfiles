vim.pack.add({ "https://github.com/akinsho/toggleterm.nvim"  })

require("toggleterm").setup({
   open_mapping = [[<c-/>]],
   hide_numbers = true,
   start_in_insert = true,
})

local Terminal = require('toggleterm.terminal').Terminal

local G5_LOGS_COUNT = 97

local g5_logs = Terminal:new({
  cmd = "ssh g5 journalctl -fu cfd-services",
  direction = "vertical",
  size = 80,
  count = G5_LOGS_COUNT,   -- <- unique identifier so other terminals still work
  hidden = true,
  close_on_exit = false,   -- keep the buffer even if the process exits
})

vim.keymap.set('n', '<leader>lt', function()
  g5_logs:toggle()
end, { desc = 'Toggle G5 cfd-services logs (right split terminal)' })

local work_term = Terminal:new({
  direction = "horizontal",
  size = 80,
  count = 3,   -- <- unique identifier so other terminals still work
  hidden = true,
  close_on_exit = false,   -- keep the buffer even if the process exits
})

vim.keymap.set({"n", "t"}, "<c-y>", function() work_term:toggle() end, { desc = "Toggle Terminal", remap=true })

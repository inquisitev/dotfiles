vim.pack.add({ "https://github.com/akinsho/toggleterm.nvim"  })

require("toggleterm").setup({
   open_mapping = [[<c-/>]],
   hide_numbers = true,
   start_in_insert = true,
})

local Terminal = require('toggleterm.terminal').Terminal

local work_term = Terminal:new({
  direction = "float",
   float_opts = {
      border='curved',
      -- width=vim.o.columns * 0.8,
      -- height=vim.o.rows * 0.8
   }
})

vim.keymap.set({"n", "t"}, "<c-y>", function() work_term:toggle() end, { desc = "Toggle Terminal", remap=true })

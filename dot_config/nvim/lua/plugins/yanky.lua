-- better yank/paste

vim.pack.add({
"https://github.com/kkharji/sqlite.lua",
"https://github.com/gbprod/yanky.nvim",
})

local storage = (pcall(require, "sqlite") and "sqlite") or "memory"

require("yanky").setup({
  ring = {
    history_length = 100,
    storage = storage,
    sync_with_numbered_registers = true,
    cancel_event = "update",
    ignore_registers = { "_" },
    update_register_on_cycle = false,
    permanent_wrapper = nil,
  },
  system_clipboard = {
    sync_with_ring = true,
  },
})

require("telescope").load_extension("yank_history")

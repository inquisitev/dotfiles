-- better yank/paste

vim.pack.add({
"https://github.com/kkharji/sqlite.lua",
"https://github.com/gbprod/yanky.nvim",
})

-- sqlite.defs is what actually loads libsqlite3 (plain `require("sqlite")` succeeds without it)
local storage = (pcall(require, "sqlite.defs") and "sqlite") or "memory"

require("yanky").setup({
  ring = {
    history_length = 500,
    storage = storage, -- falls back to "memory" when libsqlite3 is unavailable (e.g. no-root installs)
    sync_with_numbered_registers = true,
    cancel_event = "update",
    ignore_registers = { "_" },
    update_register_on_cycle = false,
    permanent_wrapper = nil,
  },
})

require("telescope").load_extension("yank_history")

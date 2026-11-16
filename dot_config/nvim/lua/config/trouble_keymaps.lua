-- Trouble (plugins/trouble.lua), under <leader>d for "diagnostics".
local function map(lhs, cmd, desc)
   vim.keymap.set("n", lhs, "<cmd>Trouble " .. cmd .. "<cr>", { desc = desc })
end

map("<leader>dd", "diagnostics toggle", "Diagnostics (workspace)")
map("<leader>db", "diagnostics toggle filter.buf=0", "Diagnostics (buffer)")
map("<leader>ds", "symbols toggle", "Document symbols")
map("<leader>dr", "lsp toggle win.position=right", "LSP references / definitions")
map("<leader>dq", "qflist toggle", "Quickfix list")
map("<leader>dl", "loclist toggle", "Location list")

-- step through whatever Trouble is showing
vim.keymap.set("n", "]d", function()
   if require("trouble").is_open() then
      require("trouble").next({ skip_groups = true, jump = true })
   else
      vim.diagnostic.jump({ count = 1, float = true })
   end
end, { desc = "Next diagnostic / Trouble item" })
vim.keymap.set("n", "[d", function()
   if require("trouble").is_open() then
      require("trouble").prev({ skip_groups = true, jump = true })
   else
      vim.diagnostic.jump({ count = -1, float = true })
   end
end, { desc = "Previous diagnostic / Trouble item" })

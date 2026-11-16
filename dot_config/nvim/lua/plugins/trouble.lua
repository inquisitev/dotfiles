-- Trouble: one panel for diagnostics, references, symbols and quickfix.
-- Keymaps in config/trouble_keymaps.lua (<leader>d...).
vim.pack.add({ "https://github.com/folke/trouble.nvim" })

require("trouble").setup({
   focus = true, -- jump into the panel when it opens
   auto_preview = true,
})

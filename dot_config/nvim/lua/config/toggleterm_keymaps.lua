-- Terminal-mode navigation, only in toggleterm terminals. (Applying these to
-- every terminal broke <esc> and <C-w> inside lazygit, yazi and the AI CLIs.)
vim.api.nvim_create_autocmd("TermOpen", {
   pattern = "term://*toggleterm#*",
   callback = function()
      local opts = { buffer = 0 }
      vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
   end,
})

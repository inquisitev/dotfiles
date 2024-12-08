return {
    {
      "neovim/nvim-lspconfig",
      config = function()
         local lspconfig = require('lspconfig')
         lspconfig.ccls.setup {
           init_options = {
             cache = {
               directory = "~/.ccls-cache";
             };
           }
         }

         lspconfig.clangd.setup {}
         vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
         vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
         vim.keymap.set("n", "gs", "<cmd>ClangdSwitchSourceHeader<CR>", {})


         lspconfig.anakin_language_server.setup{}
      end
   }
}

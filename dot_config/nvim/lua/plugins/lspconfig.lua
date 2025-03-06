return {
    {
      "neovim/nvim-lspconfig",
      config = function()
         local lspconfig = require('lspconfig')
         
         local on_attach = require("nvchad.configs.lspconfig").on_attach
         local on_init = require("nvchad.configs.lspconfig").on_init
         local capabilities = require("nvchad.configs.lspconfig").capabilities

         local servers = { 
            "html", 
            "cssls", 
            "clangd", 
            "anakin_language_server"
         }

         -- lsps with default config
         for _, lsp in ipairs(servers) do
           lspconfig[lsp].setup {
             on_attach = on_attach,
             on_init = on_init,
             capabilities = capabilities,
           }
         end

         vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true, desc="Go To Declaration" })
         vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true, desc="Go To Definition"})
         vim.keymap.set("n", "gs", "<cmd>ClangdSwitchSourceHeader<CR>", {desc="View Header/Source"})

         lspconfig.ccls.setup {
           init_options = {
             cache = {
               directory = "~/.ccls-cache";
             };
           }
         }
      end
   }
}

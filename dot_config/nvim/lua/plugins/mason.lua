vim.pack.add({
   { src = "https://github.com/mason-org/mason.nvim" },
   { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})
require("mason-tool-installer").setup({
   ensure_installed = {
      "clang-format",
      "black",
      "isort",
      "google-java-format",
      "sqlfluff",
      "shfmt",
      "taplo",
      "prettier",
      "bash-language-server",
      "lua-language-server",
      "vim-language-server",
      "clangd",
      "pyright",
      "python-lsp-server",
      "black",
      "isort",
      "rustfmt",
      "qmlfmt",
      "google-java-format",
      "tree-sitter-cli@v0.24.7",
   },

   auto_update = false,
   run_on_start = true,
   start_delay = 3000,
   debounce_hours = 5,
   integrations = {
      ["mason-lspconfig"] = true,
      ["mason-null-ls"] = true,
      ["mason-nvim-dap"] = true,
   },
})

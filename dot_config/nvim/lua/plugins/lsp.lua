vim.pack.add({
   "https://github.com/neovim/nvim-lspconfig",
   "https://github.com/hrsh7th/cmp-nvim-lsp",
   "https://github.com/mason-org/mason.nvim",
   "https://github.com/mason-org/mason-lspconfig.nvim",
   "https://github.com/WhoIsSethDaniel/mason-tool-installer"
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
   ensure_installed = {
      "lua_ls",
      "clangd", 
      "pyright", 
      "rust_analyzer", 
      "qmlls", 
      "cmake", 
      "java-language-server",
      "stylua",
      "black",
      "clang-format",
      "rustfmt",
   },
})

vim.lsp.config("java_language_server", {
    filetypes = { "java" },
    root_dir = vim.fs.dirname(vim.fs.find({ "build.gradle", "pom.xml", ".git" }, { upward = true })[1]),
    settings = {
        java = {
            format = {
                enabled = true,
            },
        },
    },
})

vim.lsp.config("pyright", {
   settings = {
      python = {
         analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
         },
      },
   },
})


vim.lsp.enable({ "pyright", "qmlls", "clangd", "java-language-server" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.name == "clangd" or client.name == "pyright" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

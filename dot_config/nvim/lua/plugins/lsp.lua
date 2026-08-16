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

vim.lsp.config("clangd", {
   cmd = {
      vim.fn.exepath("clangd") ~= "" and vim.fn.exepath("clangd")
      or (vim.fn.stdpath("data") .. "/mason/bin/clangd"),
   },
   filetypes = {
      "c",
      "cpp",
      "cuda",
      "objc",
      "objcpp",
      "h",
      "hh",
      "hpp",
      "hxx",
   },
   root_dir = function(bufnr, on_dir)
      local filename = vim.api.nvim_buf_get_name(bufnr)
      local compile_db = vim.fs.find({
         "compile_commands.json",
         "compile_flags.txt",
         ".clangd",
      }, { path = filename, upward = true })[1]

      if compile_db then
         on_dir(vim.fs.dirname(compile_db))
         return
      end

      local repo_marker = vim.fs.find({
         "Jenkinsfile",
         "CMakeLists.txt",
         "Makefile",
         "meson.build",
         ".git",
      }, { path = filename, upward = true })[1]

      if repo_marker then
         on_dir(vim.fs.dirname(repo_marker))
      end
   end,
   single_file_support = true,
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

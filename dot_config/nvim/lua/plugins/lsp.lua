vim.pack.add({
   { src = "https://github.com/neovim/nvim-lspconfig" },
   { src = "https://github.com/mason-org/mason.nvim" },
   { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
   { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
   ensure_installed = {
      -- Core language servers
      "lua_ls",
      "clangd", -- C / C++
      "pyright", -- Python
      "rust_analyzer", -- Rust
      "qmlls", -- QML
      "cmake", -- CMake
      "java-language-server",
      -- Formatters / linters (optional)
      "stylua",
      "black",
      "clang-format",
      "rustfmt",
   },
})

vim.lsp.config("lua_ls", {
   settings = {
      Lua = {
         runtime = { version = "LuaJIT" },
         diagnostics = { globals = { "vim", "require" } },
         workspace = { library = vim.api.nvim_get_runtime_file("", true) },
         telemetry = { enable = false },
      },
   },
})

vim.lsp.config("clangd", {
   cmd = { "clangd", "--background-index", "--clang-tidy" },
   capabilities = vim.lsp.protocol.make_client_capabilities(),
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

vim.lsp.config("rust_analyzer", {
   settings = {
      ["rust-analyzer"] = {
         cargo = { allFeatures = true },
         check = { command = "clippy" },
      },
   },
})

vim.lsp.config("qmlls", {
   cmd = { "qmlls" },
   filetypes = { "qml" },
   root_markers = { ".git", "CMakeLists.txt" },
})

vim.lsp.config("cmake", {
   cmd = { "cmake-language-server" },
   filetypes = { "cmake" },
   init_options = {
      buildDirectory = "build",
   },
})

vim.lsp.enable({ "pyright", "qmlls", "clangd", "java-language-server" })

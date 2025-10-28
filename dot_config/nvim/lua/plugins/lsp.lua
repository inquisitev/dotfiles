return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Mappings
      local opts = { noremap = true, silent = true }

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

        vim.keymap.set("n", "gs", function()
          -- Get current buffer number
          local current_bufnr = vim.api.nvim_get_current_buf()

          -- Request clangd to switch between header and source
          vim.lsp.buf_request(
            current_bufnr,
            "textDocument/switchSourceHeader",
            { uri = vim.uri_from_bufnr(current_bufnr) },
            function(err, result)
              if err then
                vim.notify("Error switching between source/header: " .. err.message, vim.log.levels.ERROR)
                return
              end
              if not result then
                vim.notify("Corresponding file not found", vim.log.levels.WARN)
                return
              end
              -- Open the result file
              vim.cmd("edit " .. vim.uri_to_fname(result))
            end
          )
        end, { buffer = bufnr, desc = "Switch header/source" })


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

      -- Add capabilities for nvim-cmp
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Setup language servers (examples)
      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

vim.lsp.enable({ "pyright", "qmlls", "clangd", "java-language-server" })

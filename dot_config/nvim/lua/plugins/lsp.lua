-- Servers are installed by mason (plugins/mason.lua); keymaps in config/lsp_keymaps.lua.
vim.pack.add({
   "https://github.com/neovim/nvim-lspconfig",
   "https://github.com/hrsh7th/cmp-nvim-lsp",
   -- JSON/YAML schemas (GitHub Actions, docker-compose, package.json, ...)
   "https://github.com/b0o/SchemaStore.nvim",
})

vim.lsp.config("java_language_server", {
   filetypes = { "java" },
   root_markers = { "build.gradle", "pom.xml", ".git" },
   settings = {
      java = {
         format = { enabled = true },
      },
   },
})

vim.lsp.config("clangd", {
   -- prefer a system clangd (matches the system toolchain), else mason's
   cmd = { vim.fn.exepath("clangd") ~= "" and vim.fn.exepath("clangd") or (vim.fn.stdpath("data") .. "/mason/bin/clangd") },
   filetypes = { "c", "cpp", "cuda", "objc", "objcpp" },
   root_dir = function(bufnr, on_dir)
      local filename = vim.api.nvim_buf_get_name(bufnr)
      local found = vim.fs.find({ "compile_commands.json", "compile_flags.txt", ".clangd" }, { path = filename, upward = true })[1]
         or vim.fs.find({ "Jenkinsfile", "CMakeLists.txt", "Makefile", "meson.build", ".git" }, { path = filename, upward = true })[1]
      if found then
         on_dir(vim.fs.dirname(found))
      end
   end,
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

-- JSON and YAML validate against SchemaStore: workflows, compose files,
-- package.json, renovate.json, .clangd, ... get completion and errors.
vim.lsp.config("jsonls", {
   settings = {
      json = {
         schemas = require("schemastore").json.schemas(),
         validate = { enable = true },
      },
   },
})

vim.lsp.config("yamlls", {
   settings = {
      yaml = {
         -- use SchemaStore.nvim's catalogue instead of the built-in fetch
         schemaStore = { enable = false, url = "" },
         schemas = require("schemastore").yaml.schemas(),
         keyOrdering = false,
      },
   },
})

-- bash-language-server runs shellcheck (installed by mason) on every change.
vim.lsp.config("bashls", {
   filetypes = { "bash", "sh" },
})

-- was "java-language-server", which doesn't match the config name above
vim.lsp.enable({ "pyright", "ruff", "qmlls", "clangd", "java_language_server", "bashls", "jsonls", "yamlls" })

-- treesitter highlighting looks better than these servers' semantic tokens
vim.api.nvim_create_autocmd("LspAttach", {
   callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (client.name == "clangd" or client.name == "pyright") then
         client.server_capabilities.semanticTokensProvider = nil
      end
      -- pyright's hover is the useful one; ruff's only repeats lint rules
      if client and client.name == "ruff" then
         client.server_capabilities.hoverProvider = false
      end
   end,
})

-- Servers are installed by mason (plugins/mason.lua); keymaps in config/lsp_keymaps.lua.
vim.pack.add({
   "https://github.com/neovim/nvim-lspconfig",
   "https://github.com/hrsh7th/cmp-nvim-lsp",
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

-- was "java-language-server", which doesn't match the config name above
vim.lsp.enable({ "pyright", "qmlls", "clangd", "java_language_server" })

-- treesitter highlighting looks better than these servers' semantic tokens
vim.api.nvim_create_autocmd("LspAttach", {
   callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (client.name == "clangd" or client.name == "pyright") then
         client.server_capabilities.semanticTokensProvider = nil
      end
   end,
})

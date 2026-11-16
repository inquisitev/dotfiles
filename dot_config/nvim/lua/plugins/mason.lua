-- Mason installs LSP servers / formatters into stdpath("data")/mason.
-- (Previously two files each added a copy of mason-tool-installer and called
-- setup() with different lists, so only one list ever applied.)
vim.pack.add({
   "https://github.com/mason-org/mason.nvim",
   "https://github.com/mason-org/mason-lspconfig.nvim",
   "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

-- Some packages only exist for some platforms or need a toolchain; skip them
-- where they'd just fail (e.g. linux-arm64 containers and Raspberry Pis).
local is_arm_linux = vim.uv.os_uname().sysname == "Linux" and vim.uv.os_uname().machine:match("^a") ~= nil
local function missing(exe)
   return vim.fn.executable(exe) == 0
end

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
   ensure_installed = {
      -- language servers
      "lua_ls",
      -- system clangd (apt/brew) is preferred, see plugins/lsp.lua
      { "clangd", condition = function() return missing("clangd") and not is_arm_linux end },
      "pyright",
      "python-lsp-server",
      "rust_analyzer",
      { "qmlls", condition = function() return not is_arm_linux end },
      "cmake",
      -- built from source; needs a JDK
      { "java-language-server", condition = function() return not missing("java") end },
      "bash-language-server",
      "shellcheck", -- bash-language-server runs it for diagnostics
      "yaml-language-server",
      "json-lsp",
      "ruff", -- Python linting (LSP) next to pyright
      "vim-language-server",
      -- formatters
      "stylua",
      "clang-format",
      "black",
      "isort",
      "google-java-format",
      "sqlfluff",
      "shfmt",
      "taplo",
      "prettier",
      -- tree-sitter CLI comes from mise (~/.config/mise/config.toml), not mason
   },
   auto_update = false,
   run_on_start = true,
   start_delay = 3000,
   debounce_hours = 5,
})

-- run_on_start hangs off VimEnter, but with a UI this file loads after startup
-- (see init.lua), when VimEnter has already fired; start the check ourselves.
if vim.v.vim_did_enter == 1 then
   require("mason-tool-installer").run_on_start()
end

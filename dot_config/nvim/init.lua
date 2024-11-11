vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end


vim.opt.rtp:prepend(lazypath)
local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },
  {
    "mfussenegger/nvim-dap",
  },
  {
    "mfussenegger/nvim-dap",
  },
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
        require("peek").setup()
        vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
        vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim'
  },
  {
    "mfussenegger/nvim-dap-python",
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  -- optional for floating window border decoration
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  keys = {
    { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    { "<leader>tf", "<cmd>Telescope find_files<cr>", desc = "Telescope find files" },
    { "<leader>tc", "<cmd>Telescope live_grep<cr>", desc = "Telescope live grep" },
    { "<leader>ty", "<cmd>Telescope yank_history<cr>", desc = "Telescope yank_history" }
  }
},

  { import = "plugins" },
}, lazy_config)

local lspconfig = require('lspconfig')
lspconfig.ccls.setup {
  init_options = {
    cache = {
      directory = "~/.ccls-cache";
    };
  }
}

lspconfig.anakin_language_server.setup{}

local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-1>", function()
    harpoon:list():select(1)
    vim.cmd('normal! zz')
end)
vim.keymap.set("n", "<C-2>", function()
    harpoon:list():select(2)
    vim.cmd('normal! zz')
end)

vim.keymap.set("n", "<C-3>", function()
    harpoon:list():select(3) 
    vim.cmd('normal! zz')
end)
vim.keymap.set("n", "<C-4>", function()
    harpoon:list():select(4)
    vim.cmd('normal! zz')
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
require('mason-tool-installer').setup {

  -- a list of all tools you want to ensure are installed upon
  -- start
  ensure_installed = {

    { 'bash-language-server', auto_update = true },
    'lua-language-server',
    'json-to-struct',
    'luacheck',
    'misspell',
    'revive',
    'shellcheck',
    'shfmt',
    'staticcheck',
    'clangd',
    'cpptools',
    'cpplint',
    'flake8',
    'jsonlint',
    'matlab-language-server',
    'pydocstyle',
    'pyright',
    'python-lsp-server',
    'reorder-python-imports',
    'rust-analyzer',
    'rust-fmt',
    'sqlfluff',
    'sqlfmt',
    'docker-compose-language-server',
    'dockerfile-language-server',
  },

  -- if set to true this will check each tool for updates. If updates
  -- are available the tool will be updated. This setting does not
  -- affect :MasonToolsUpdate or :MasonToolsInstall.
  -- Default: false
  auto_update = false,

  -- automatically install / update on startup. If set to false nothing
  -- will happen on startup. You can use :MasonToolsInstall or
  -- :MasonToolsUpdate to install tools and check for updates.
  -- Default: true
  run_on_start = true,

  -- set a delay (in ms) before the installation starts. This is only
  -- effective if run_on_start is set to true.
  -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
  -- Default: 0
  start_delay = 3000, -- 3 second delay

  -- Only attempt to install if 'debounce_hours' number of hours has
  -- elapsed since the last time Neovim was started. This stores a
  -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
  -- This is only relevant when you are using 'run_on_start'. It has no
  -- effect when running manually via ':MasonToolsInstall' etc....
  -- Default: nil
  debounce_hours = 5, -- at least 5 hours between attempts to install/update

  -- By default all integrations are enabled. If you turn on an integration
  -- and you have the required module(s) installed this means you can use
  -- alternative names, supplied by the modules, for the thing that you want
  -- to install. If you turn off the integration (by setting it to false) you
  -- cannot use these alternative names. It also suppresses loading of those
  -- module(s) (assuming any are installed) which is sometimes wanted when
  -- doing lazy loading.
  integrations = {
    ['mason-lspconfig'] = true,
    ['mason-null-ls'] = true,
    ['mason-nvim-dap'] = true,
  },
}

require('dap-python').setup('python')
-- require('yanky').setup()
table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'launch',
  module = 'pytest',
  name = 'Run Tests',
  args={
        "${file}"
    }
})
vim.keymap.set("n", "<leader>dc", function() require('dap').continue() end, {desc="Continue debugging"})
vim.keymap.set("n", "<leader>dx", function() require('dap').terminate() end, {desc="Terminate debugging"})
vim.keymap.set("n", "<leader>dtc", function() require('dap-python').test_method() end,{desc="Debug test method"} )
vim.keymap.set("n", "<leader>dtt", function() require('dap-python').test_class() end,{desc="Debug test class"} )
vim.keymap.set("n", "<leader>di", function() require('dap.ui.widgets').hover() end,{desc="inspect value"} )
vim.keymap.set("n", "m", function() require('dap').step_over() end,{desc="Step Over"} )
vim.keymap.set("n", "n", function() require('dap').step_into() end,{desc="Step Into"} )
vim.keymap.set("n", "<leader>dp", function() require('dap').toggle_breakpoint() end, {desc="Toggle Breakpoint"})
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

local set = vim.opt -- set options
vim.opt.clipboard=unnamedplus
set.tabstop = 4
set.softtabstop = 4

set.shiftwidth = 4
vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }
vim.wo.relativenumber = true

require("telescope").load_extension("yank_history")


 


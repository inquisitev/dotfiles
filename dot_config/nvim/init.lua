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

vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

require('dap-python').setup('python')
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


 


vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

local map = vim.keymap.set

map("n", "<A-a>", "<C-a>", {noremap = "increment number"})
map("n", "<A-f>", "<C-x>", {noremap = "decrement number"})

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
    "inquisitev/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")


vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
   vim.diagnostic.config({
      virtual_lines = { current_line = true },
      virtual_text = false,
      float = {
       border = "rounded",
       source = "always",
     }
   })
  end,
})



vim.lsp.enable({'clangd', 'pyright', 'lua-lsp-server', 'rust-analyzer', 'qmlls', 'anakinls', 'lua-language-server' })

-- vim.cmd("set completeopt+=noselect")

require "nvchad.autocmds"
vim.schedule(function() require "mappings" end)



vim.wo.relativenumber = true


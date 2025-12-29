vim.g.mapleader = " "

vim.diagnostic.config({ virtual_text = false })
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
   vim.cmd('echo "Installing `mini.nvim`" | redraw')
   local clone_cmd = {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/nvim-mini/mini.nvim",
      mini_path,
   }
   vim.fn.system(clone_cmd)
   vim.cmd("packadd mini.nvim | helptags ALL")
   vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require("mini.deps").setup({ path = { package = path_package } })

local function load_directory(dir)
   local path = vim.fn.stdpath("config") .. "/lua/" .. dir
   local files = vim.fn.glob(path .. "/*.lua", false, true)
   for _, file in ipairs(files) do
      local name = file:match(".*/(.*)%.lua$")
      if name then
         local ok, err = pcall(require, dir .. "." .. name)
         if not ok then
            vim.notify("Error loading " .. dir .. "/" .. name .. ": " .. err, vim.log.levels.ERROR)
         end
      end
   end
end

load_directory("config")
load_directory("plugins")
load_directory("treesitter_colors")

vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = function () end,
    ['*'] = function () end,
  },
}

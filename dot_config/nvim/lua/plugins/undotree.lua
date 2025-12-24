vim.pack.add({ "https://github.com/jiaoshijie/undotree" })

local undodir = vim.fn.stdpath('data') .. '/undo'
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, 'p')
end
vim.opt.undodir = undodir
vim.opt.undofile = true


require("undotree").setup({
   dependencies = "nvim-lua/plenary.nvim",
   config = true,
})

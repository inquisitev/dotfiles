vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cmdheight = 0
vim.opt.fillchars:append({ eob = " " })
vim.opt.sessionoptions = "curdir,folds,globals,help,tabpages,terminal,winsize"

-- persistent undo (used by undotree)
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.fn.mkdir(vim.o.undodir, "p")

-- inline diagnostics come from tiny-inline-diagnostic instead
vim.diagnostic.config({ virtual_text = false })

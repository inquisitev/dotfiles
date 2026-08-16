vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" }, {
   build = ":TSUpdate",
   config = function()
      require("nvim-treesitter.configs").setup({
         ensure_installed = { "lua", "python", "cpp", "c", "javascript", "qmljs" },
      })
   end,
})

-- Explicitly enable treesitter highlighting and indentation
vim.api.nvim_create_autocmd("FileType", {
   callback = function(args)
      if pcall(vim.treesitter.start, args.buf) then
         vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
   end,
})


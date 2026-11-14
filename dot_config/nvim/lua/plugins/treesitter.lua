-- nvim-treesitter `main` branch. (The old `nvim-treesitter.configs` setup and
-- lazy.nvim-style `build`/`config` keys did nothing here, so parsers were never
-- installed automatically.) Parsers compile with the tree-sitter CLI from mise.
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

require("nvim-treesitter").install({ "lua", "python", "cpp", "c", "javascript", "qmljs" })

-- keep parsers in sync after `vim.pack.update()`
vim.api.nvim_create_autocmd("PackChanged", {
   callback = function(ev)
      if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
         vim.cmd("TSUpdate")
      end
   end,
})

-- treesitter highlighting + indentation wherever a parser exists
vim.api.nvim_create_autocmd("FileType", {
   callback = function(args)
      if pcall(vim.treesitter.start, args.buf) then
         vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
   end,
})

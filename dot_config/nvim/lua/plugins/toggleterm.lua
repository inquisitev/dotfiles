vim.pack.add({ { src = "https://github.com/akinsho/toggleterm.nvim" } })

require("toggleterm").setup({
   open_mapping = [[<c-/>]],
   hide_numbers = true,
   start_in_insert = true,
})


return {
  {
    "akinsho/toggleterm.nvim",
    config = function(_, opts)
      require("toggleterm").setup({
         open_mapping = [[<c-/>]],
         hide_numbers = true,
         start_in_insert = true,
      })
    end,
  },
}

return {
   {
      "nvzone/floaterm",
      dependencies = "nvzone/volt",
      event = "VeryLazy",
      cmd = "FloatermToggle",

    config = function()
      vim.keymap.set("n", "<leader>tn", "<cmd>FloatermToggle<CR>", { desc = "open floaterm" })
    end
   }          
}

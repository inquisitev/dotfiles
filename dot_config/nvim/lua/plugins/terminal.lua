return {
   {
      "nvzone/floaterm",
      dependencies = "nvzone/volt",
      event = "VeryLazy",
      opts = {
         mappings = {
            term = function(buf)
               vim.keymap.set({ "n", "t" }, "<leader>tn", function()
               require("floaterm.api").switch_wins "prev"
               end, { buffer = buf })
            end,
         },
      },
      mappings = {
         term = function(buf)
            vim.keymap.set({ "n", "t" }, "<leader>tn", function()
            require("floaterm.api").cycle_term_bufs "prev"
            end, { buffer = buf })
         end,
      },
      cmd = "FloatermToggle",

    config = function()
      vim.keymap.set("n", "<leader>tn", "<cmd>FloatermToggle<CR>", { desc = "open floaterm" })
    end
   }          
}

return {
  {
    "yetone/avante.nvim",
    event = "BufReadPost",
    version = false,
    opts = {
      provider = "copilot",
      cursor_applying_provider = "copilot", -- In this example, use Groq for applying, but you can also use any provider you want.
      behaviour = {
        --- ... existing behaviours
        enable_cursor_planning_mode = true, -- enable cursor planning mode!
      },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "echasnovski/mini.pick",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
      "ibhagwan/fzf-lua",
      "nvim-tree/nvim-web-devicons",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}

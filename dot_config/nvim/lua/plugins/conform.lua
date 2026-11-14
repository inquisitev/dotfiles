vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

local function get_git_branch()
   local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
   if not handle then
      return nil
   end
   local branch = handle:read("*a"):gsub("%s+", "")
   handle:close()
   return branch ~= "" and branch or nil
end

local branch = get_git_branch()
-- only format on save on release-* branches (checked once, at startup)
local shouldFormat = branch and branch:match("^release%-")

local opts = {
   format_on_save = true
}

if shouldFormat then
   opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
      cpp = { "uncrustify" },
      c = { "clang-format", "uncrustify" },
      qml = { "qmlformat" },
      python = { "black" },
      java = { "google-java-format" },
      cmake = { "cmake_custom_formatter" },
      sql = { "sqlfluff" },
      bash = { "shfmt" },
      sh = { "shfmt" },
      fish = { "fish_indent" },
      toml = { "taplo" },
      ini = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
   })
end

opts.formatters = {
   uncrustify = {
      command = "uncrustify",
      args = function()
         local cfg_path = vim.fn.findfile("uncrustify.cfg", ".;")
         if cfg_path == "" then
            local current_dir = vim.fn.getcwd()
            local home_dir = vim.fn.expand("$HOME")
            local one_level_cfg = vim.fn.expand(
               home_dir .. "/" .. vim.fn.fnamemodify(current_dir, ":h:t") .. "/" .. "uncrustify/uncrustify.cfg"
            )
            if vim.fn.filereadable(one_level_cfg) == 1 then
               cfg_path = one_level_cfg
            else
               cfg_path = vim.fn.expand("$HOME/.config/uncrustify/uncrustify.cfg")
            end
         end
         return { "-c", cfg_path, "--replace", "$FILENAME" }
      end,
      temp_file = false,
      stdin = false,
   },
   cmake_custom_formatter = {
      command = "cmake-format",
      args = function()
         return { "--config-file", vim.fn.expand("$HOME/.config/cmake_format/config.py"), "-i", "$FILENAME" }
      end,
      temp_file = false,
      stdin = false,
   },
}

vim.api.nvim_create_autocmd("User", {
   pattern = "ConformPost",
   callback = function()
      print("Formatting finished!")
   end,
})

require("conform").setup(opts)

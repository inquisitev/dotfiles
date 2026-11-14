-- text-case.nvim:  ga<x> = convert word,  ga<X> = LSP rename,  ge<x> = operator
local conversions = {
   u = "to_upper_case",
   l = "to_lower_case",
   s = "to_snake_case",
   d = "to_dash_case",
   n = "to_constant_case",
   ["."] = "to_dot_case",
   [","] = "to_comma_case",
   a = "to_phrase_case",
   c = "to_camel_case",
   p = "to_pascal_case",
   t = "to_title_case",
   f = "to_path_case",
}

for key, method in pairs(conversions) do
   vim.keymap.set({ "n", "x" }, "ga" .. key, function()
      require("textcase").current_word(method)
   end, { desc = "TextCase " .. method })

   vim.keymap.set({ "n", "x" }, "ge" .. key, function()
      require("textcase").operator(method)
   end, { desc = "TextCase operator " .. method })

   if key:match("%a") then
      vim.keymap.set({ "n", "x" }, "ga" .. key:upper(), function()
         require("textcase").lsp_rename(method)
      end, { desc = "TextCase LSP " .. method })
   end
end

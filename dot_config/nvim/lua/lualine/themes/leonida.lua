-- lualine theme for the leonida colorscheme (colors/leonida.lua).
local bg, mid, fg, dim = "#000000", "#1c1029", "#f6e7f1", "#86709c"
local dark = "#000000"

local function mode(color)
   return {
      a = { fg = dark, bg = color, gui = "bold" },
      b = { fg = color, bg = mid },
      c = { fg = fg, bg = bg },
   }
end

return {
   normal = mode("#ff4f8b"), -- pink
   insert = mode("#2de2c6"), -- teal
   visual = mode("#ffa53a"), -- amber
   replace = mode("#ff3b5c"), -- red
   command = mode("#ffd166"), -- gold
   terminal = mode("#b07cff"), -- violet
   inactive = {
      a = { fg = dim, bg = bg },
      b = { fg = dim, bg = bg },
      c = { fg = dim, bg = bg },
   },
}

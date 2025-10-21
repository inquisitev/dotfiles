vim.pack.add({
   "https://github.com/rebelot/heirline.nvim",
})
-- ~/.config/nvim/lua/plugins/heirline-statuscolumn.lua
local heirline = require("heirline")
local conditions = require("heirline.conditions")

local color = "#0cedbd"

-- Highlights
vim.api.nvim_set_hl(0, "LineNrCustom", { fg = "#7c7c7c", bg = "NONE" })
vim.api.nvim_set_hl(0, "LineNrCurrentActive", { fg = color, bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "LineNrCurrentInactive", { fg = "#888888", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "LineBorderActive", { fg = "#444444", bg = "NONE" })
vim.api.nvim_set_hl(0, "LineBorderInactive", { fg = "#333333", bg = "NONE" })

local StatusColumn = {
   init = function(self)
      self.lnum = vim.v.lnum
      self.relnum = math.abs(vim.fn.line(".") - self.lnum)
      self.is_current = self.lnum == vim.fn.line(".")
      self.active = conditions.is_active()
   end,

   -- Line number
   {
      provider = function(self)
         if vim.wo.relativenumber then
            if self.is_current then
               return string.format("%4d", self.lnum)
            elseif self.relnum > 0 then
               return string.format("%4d", self.relnum)
            end
         end
         return string.format("%4d", self.lnum)
      end,
      hl = function(self)
         if self.is_current then
            return self.active and "LineNrCurrentActive" or "LineNrCurrentInactive"
         else
            return "LineNrCustom"
         end
      end,
   },

   -- Border
   {
      provider = " │ ",
      hl = function(self)
         return self.active and "LineBorderActive" or "LineBorderInactive"
      end,
   },
}

heirline.setup({
   statuscolumn = StatusColumn,
})

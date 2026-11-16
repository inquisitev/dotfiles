vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })

local function lsp_status()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if not clients or #clients == 0 then
    return ""
  end

  local names = {}
  for _, c in ipairs(clients) do
    if c and c.name and c.name ~= "" then
      names[#names + 1] = c.name
    end
  end

  if #names == 0 then
    return ""
  end

  return "lsp: " .. table.concat(names, ", ")
end

local function local_date()
  return os.date("%b %d, %Y")
end

local function local_time_12h()
  return os.date("%-I:%M %p")
end

-- leonida ships its own lualine theme; every other scheme uses horizon.
local function theme()
  return vim.g.colors_name == "leonida" and "leonida" or "horizon"
end

local config = {
  options = {
    theme = theme(),
    globalstatus = true,
    icons_enabled = true,
    component_separators = { left = "│", right = "│" },
    section_separators = { left = "", right = "" },
  },

  sections = {
    lualine_a = { "mode" },

    lualine_b = {
      "branch",
    },

    lualine_c = {
      {
        "filename",
        path = 1, -- relative path
        symbols = {
          modified = " [+]",
          readonly = " [RO]",
          unnamed = "[No Name]",
        },
      },
      {
        function() return require("gitblame").get_current_blame_text() end,
        cond = function() return require("gitblame").is_blame_text_available() end,
      },
      {
        lsp_status,
        cond = function()
          return lsp_status() ~= ""
        end,
      },
    },

    lualine_x = {},

    lualine_y = {
      local_date,
    },

    lualine_z = {
      local_time_12h,
    },
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
}

require("lualine").setup(config)

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("lualine_theme", { clear = true }),
  callback = function()
    if config.options.theme ~= theme() then
      config.options.theme = theme()
      require("lualine").setup(config)
    end
  end,
})

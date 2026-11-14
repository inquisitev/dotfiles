-- Cache compiled Lua modules; must come before any require().
vim.loader.enable()

vim.g.mapleader = " "

-- Plugins are managed by Neovim's built-in vim.pack (versions pinned in
-- nvim-pack-lock.json). Each file in lua/config and lua/plugins is loaded in
-- alphabetical order; a broken file is reported instead of aborting startup.
--
-- Startup is split in two so the first frame appears quickly:
--   1. everything in lua/config plus the plugins that draw the first frame
--      (EAGER below) load immediately;
--   2. the rest of lua/plugins loads right after the UI is up, one file per
--      event-loop turn so typing is never blocked.
-- Without a UI (`nvim --headless`, used by the install/verify scripts)
-- everything loads immediately, so plugins are installed before `+qa` runs.
local EAGER = {
   colorscheme = true,
   dashboard = true,
   lualine = true,
   tabs = true,
   treesitter = true,
}

local function load(dir, name)
   local ok, err = pcall(require, dir .. "." .. name)
   if not ok then
      vim.notify("Error loading " .. dir .. "/" .. name .. ": " .. err, vim.log.levels.ERROR)
   end
end

local function modules(dir)
   local names = {}
   local path = vim.fn.stdpath("config") .. "/lua/" .. dir
   for _, file in ipairs(vim.fn.glob(path .. "/*.lua", false, true)) do
      names[#names + 1] = file:match(".*/(.*)%.lua$")
   end
   return names
end

for _, name in ipairs(modules("config")) do
   load("config", name)
end

local has_ui = #vim.api.nvim_list_uis() > 0
local deferred = {}
for _, name in ipairs(modules("plugins")) do
   if EAGER[name] or not has_ui then
      load("plugins", name)
   else
      deferred[#deferred + 1] = name
   end
end

local function load_deferred(index)
   local name = deferred[index]
   if name then
      load("plugins", name)
      return vim.schedule(function()
         load_deferred(index + 1)
      end)
   end

   -- Buffers opened before the deferred plugins existed (e.g. `nvim file`)
   -- missed their FileType handlers; replay the event for them.
   for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" and vim.bo[buf].filetype ~= "" then
         vim.api.nvim_exec_autocmds("FileType", { buffer = buf, modeline = false })
      end
   end
   vim.api.nvim_exec_autocmds("User", { pattern = "PluginsLoaded", modeline = false })
end

if #deferred > 0 then
   vim.api.nvim_create_autocmd("UIEnter", {
      once = true,
      callback = function()
         vim.schedule(function()
            load_deferred(1)
         end)
      end,
   })
end

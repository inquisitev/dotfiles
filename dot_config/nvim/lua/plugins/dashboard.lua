-- Animated start screen, no plugin required.
--
-- A drifting, twinkling starfield with the odd shooting star sits behind a
-- logo that decodes itself on startup and then has the colorscheme's own
-- palette flowing through it. Colors are derived from the active colorscheme,
-- so it re-themes itself whenever the scheme changes.
--
-- Opens when nvim starts without a file; reopen any time with :Dashboard.

local api, uv = vim.api, vim.uv

local FPS = 24
local GRAD = 36 -- number of steps in the logo gradient
local ITEM_WIDTH = 40

local ns = api.nvim_create_namespace("animated_dashboard")
local augroup = api.nvim_create_augroup("animated_dashboard", { clear = true })

local function chars(str)
   return vim.fn.split(str, "\\zs")
end

local function icon(codepoint)
   return vim.fn.nr2char(codepoint)
end

local LOGO = vim.tbl_map(chars, {
   "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
   "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
   "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
   "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
   "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
   "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
})
local LOGO_WIDTH = #LOGO[1]
local LOGO_SMALL = chars("N E O V I M")
local SCRAMBLE = chars("░▒▓█▚▞▙▟╬╠╣═║")

local function telescope(picker, opts)
   return function()
      require("telescope.builtin")[picker](opts or {})
   end
end

-- { icon, label, key, action } -- action is an ex command or a function
local ITEMS = {
   { icon(0xf002), "Find file", "f", telescope("find_files") },
   { icon(0xf15b), "New file", "n", "enew" },
   { icon(0xf1da), "Recent files", "r", telescope("oldfiles") },
   { icon(0xf0b0), "Live grep", "g", telescope("live_grep") },
   {
      icon(0xf013),
      "Dotfiles",
      "d",
      telescope("find_files", { cwd = vim.fn.expand("~/.local/share/chezmoi"), hidden = true }),
   },
   {
      icon(0xf1fc),
      "Colorscheme",
      "c",
      function()
         require("colorscheme-persist").picker({})
      end,
   },
   {
      icon(0xf021),
      "Update plugins",
      "u",
      function()
         vim.pack.update()
      end,
   },
   { icon(0xf011), "Quit", "q", "qa" },
}

---------------------------------------------------------------------------
-- Colors
---------------------------------------------------------------------------

local function hl_attr(name, attr)
   local ok, hl = pcall(api.nvim_get_hl, 0, { name = name, link = false })
   return ok and hl[attr] or nil
end

local function blend(a, b, t)
   local function channel(shift)
      local x = bit.band(bit.rshift(a, shift), 0xff)
      local y = bit.band(bit.rshift(b, shift), 0xff)
      return math.floor(x + (y - x) * t + 0.5)
   end
   return bit.bor(bit.lshift(channel(16), 16), bit.lshift(channel(8), 8), channel(0))
end

local function setup_highlights()
   local dark = vim.o.background ~= "light"
   local bg = hl_attr("Normal", "bg") or (dark and 0x0b0e14 or 0xf5f5f5)
   local fg = hl_attr("Normal", "fg") or (dark and 0xd0d4e0 or 0x30343c)
   local pop = dark and 0xffffff or 0x000000

   local stops = {
      hl_attr("Function", "fg") or 0x7aa2f7,
      hl_attr("Keyword", "fg") or 0xbb9af7,
      hl_attr("Constant", "fg") or 0xff9e64,
      hl_attr("String", "fg") or 0x9ece6a,
   }

   -- Cyclic gradient through the stops: solid blocks get the full color,
   -- the logo's box-drawing "shadow" gets a dimmed copy.
   for i = 0, GRAD - 1 do
      local pos = i / GRAD * #stops
      local from = math.floor(pos)
      local color = blend(stops[from + 1], stops[(from + 1) % #stops + 1], pos - from)
      api.nvim_set_hl(0, "DashGrad" .. i, { fg = color, bold = true })
      api.nvim_set_hl(0, "DashShadow" .. i, { fg = blend(color, bg, 0.55) })
   end

   for level, amount in ipairs({ 0.16, 0.3, 0.5, 0.85 }) do
      api.nvim_set_hl(0, "DashStar" .. level, { fg = blend(bg, fg, amount) })
   end

   api.nvim_set_hl(0, "DashShine", { fg = blend(fg, pop, 0.8), bold = true })
   api.nvim_set_hl(0, "DashItem", { fg = blend(fg, bg, 0.15) })
   api.nvim_set_hl(0, "DashSelected", { fg = blend(fg, pop, 0.6), bold = true })
   api.nvim_set_hl(0, "DashDim", { fg = blend(bg, fg, 0.42) })
   api.nvim_set_hl(0, "DashIcon", { fg = stops[1] })
   api.nvim_set_hl(0, "DashKey", { fg = stops[3], bold = true })
   api.nvim_set_hl(0, "DashGreeting", { fg = blend(stops[2], fg, 0.3), italic = true })
end

---------------------------------------------------------------------------
-- State
---------------------------------------------------------------------------

local state = nil -- nil while no dashboard is open

local function greeting()
   local hour = tonumber(os.date("%H"))
   local part = hour < 5 and "Burning the midnight oil"
      or hour < 12 and "Good morning"
      or hour < 18 and "Good afternoon"
      or hour < 22 and "Good evening"
      or "Burning the midnight oil"
   return part .. " — what are we building?"
end

local function footer_info()
   local v = vim.version()
   local info = ("nvim %d.%d.%d"):format(v.major, v.minor, v.patch)
   -- info = false skips the per-plugin git queries (~90ms for 60 plugins)
   local ok, plugins = pcall(vim.pack.get, nil, { info = false })
   if ok and type(plugins) == "table" then
      info = info .. ("  ·  %d plugins"):format(#plugins)
   end
   return info
end

local function seed_stars(w, h)
   local stars = {}
   for i = 1, math.floor(w * h / 38) do
      stars[i] = {
         x = math.random() * w,
         y = math.random(h),
         layer = math.random(3), -- 1 = far and slow, 3 = near and fast
         phase = math.random() * math.pi * 2,
         twinkle = 0.5 + math.random() * 2,
      }
   end
   return stars
end

---------------------------------------------------------------------------
-- Rendering
---------------------------------------------------------------------------

-- The frame is composed in a grid of single-width cells (one character and
-- one highlight each), then flushed to the buffer as lines plus extmarks.
local function render(now)
   local s = state
   local w, h = api.nvim_win_get_width(s.win), api.nvim_win_get_height(s.win)
   if w < 20 or h < 8 then
      return
   end

   local t = now - s.start
   local dt = math.min(now - s.last, 0.25)
   s.last = now

   if w ~= s.w or h ~= s.h then
      s.w, s.h = w, h
      s.stars = seed_stars(w, h)
      s.shoot = nil
   end

   local cell, hl = {}, {}
   for y = 1, h do
      local crow, hrow = {}, {}
      for x = 1, w do
         crow[x], hrow[x] = " ", false
      end
      cell[y], hl[y] = crow, hrow
   end

   local function put(y, x, glyphs, group)
      local crow, hrow = cell[y], hl[y]
      if not crow then
         return
      end
      for i, glyph in ipairs(glyphs) do
         local cx = x + i - 1
         if cx >= 1 and cx <= w then
            crow[cx], hrow[cx] = glyph, group
         end
      end
   end

   -- Starfield: three parallax layers drifting left, each star twinkling.
   for _, star in ipairs(s.stars) do
      star.x = star.x - star.layer * 0.55 * dt
      if star.x < 1 then
         star.x = star.x + w
         star.y = math.random(h)
      end
      local glow = (math.sin(t * star.twinkle + star.phase) + 1) / 2
      local level = math.max(1, math.min(4, math.floor(glow * 2 + star.layer)))
      local glyph = star.layer == 1 and "." or star.layer == 2 and "·" or (glow > 0.93 and "✦" or "•")
      put(star.y, math.floor(star.x), { glyph }, "DashStar" .. level)
   end

   -- Shooting star, every few seconds.
   if not s.shoot and math.random() < dt / 4 then
      s.shoot = { x = math.random() * w * 0.7, y = 1 + math.random() * h * 0.4, vx = 42, vy = 12 }
   end
   if s.shoot then
      local sh = s.shoot
      sh.x, sh.y = sh.x + sh.vx * dt, sh.y + sh.vy * dt
      for k = 9, 0, -1 do
         local glyph = k == 0 and "•" or k < 4 and "·" or "."
         put(
            math.floor(sh.y - sh.vy * k * 0.017),
            math.floor(sh.x - sh.vx * k * 0.017),
            { glyph },
            "DashStar" .. (4 - math.floor(k / 2.5))
         )
      end
      if sh.x - 8 > w or sh.y - 4 > h then
         s.shoot = nil
      end
   end

   -- Vertical layout, centered; gaps collapse on short windows.
   local big_logo = w >= LOGO_WIDTH + 4
   local logo_height = big_logo and #LOGO or 1
   local spacing = h >= logo_height + #ITEMS * 2 + 9 and 2 or 1
   local menu_height = (#ITEMS - 1) * spacing + 1
   local top = math.max(1, math.floor((h - (logo_height + menu_height + 7)) / 2) + 1)

   -- Logo: decodes from noise column by column, then the gradient flows
   -- diagonally through it and a highlight sweeps across now and then.
   if big_logo then
      local left = math.floor((w - LOGO_WIDTH) / 2) + 1
      local sweep = (t % 6) / 1.1 * (LOGO_WIDTH + 24) - 12
      for r, row in ipairs(LOGO) do
         for c, glyph in ipairs(row) do
            if glyph ~= " " then
               local index = math.floor(c * 0.8 + r * 2 - t * 13) % GRAD
               local group
               if t < c / LOGO_WIDTH * 0.7 + s.noise[r][c] * 0.45 then
                  glyph = SCRAMBLE[math.random(#SCRAMBLE)]
                  group = "DashShadow" .. index
               elseif t > 1.6 and math.abs(c + r * 1.5 - sweep) < 2 then
                  group = "DashShine"
               else
                  group = (glyph == "█" and "DashGrad" or "DashShadow") .. index
               end
               put(top + r - 1, left + c - 1, { glyph }, group)
            end
         end
      end
   else
      local left = math.floor((w - #LOGO_SMALL) / 2) + 1
      for c, glyph in ipairs(LOGO_SMALL) do
         put(top, left + c - 1, { glyph }, "DashGrad" .. math.floor(c * 2 - t * 13) % GRAD)
      end
   end

   -- Greeting, typed out.
   local typed = math.floor((t - 0.9) * 32)
   if typed > 0 then
      local line = {}
      for i = 1, math.min(typed, #s.greeting) do
         line[i] = s.greeting[i]
      end
      if typed < #s.greeting + 12 and typed % 8 < 5 then
         line[#line + 1] = "▏"
      end
      put(top + logo_height + 1, math.floor((w - #s.greeting) / 2) + 1, line, "DashGreeting")
   end

   -- Menu: items slide in from the right one after another.
   local menu_top = top + logo_height + 4
   local menu_left = math.floor((w - ITEM_WIDTH) / 2) + 1
   local cursor_row = nil
   for i, item in ipairs(ITEMS) do
      local progress = math.min(1, (t - 1.1 - i * 0.07) / 0.35)
      local y = menu_top + (i - 1) * spacing
      if progress > 0 and y <= h then
         local x = menu_left + math.floor((1 - progress) ^ 2 * 14)
         local settled = progress >= 1
         local selected = settled and i == s.selected
         put(y, x - 2, chars((" "):rep(ITEM_WIDTH + 4)), false)
         if selected then
            put(y, x, { "▌" }, "DashGrad" .. math.floor(t * 13) % GRAD)
            cursor_row = y
         end
         put(y, x + 2, { item[1] }, settled and "DashIcon" or "DashDim")
         put(y, x + 5, chars(item[2]), selected and "DashSelected" or settled and "DashItem" or "DashDim")
         put(y, x + ITEM_WIDTH - 1, { item[3] }, settled and "DashKey" or "DashDim")
      end
   end

   -- Footer: live clock and version info.
   if t > 1.9 then
      local line = chars(os.date("%a %d %b  %H:%M:%S") .. "  ·  " .. s.footer)
      put(math.min(h, menu_top + menu_height + 1), math.floor((w - #line) / 2) + 1, line, "DashDim")
   end

   -- Flush the grid.
   local lines = {}
   for y = 1, h do
      lines[y] = table.concat(cell[y])
   end
   vim.bo[s.buf].modifiable = true
   api.nvim_buf_set_lines(s.buf, 0, -1, false, lines)
   vim.bo[s.buf].modifiable = false

   api.nvim_buf_clear_namespace(s.buf, ns, 0, -1)
   for y = 1, h do
      local crow, hrow = cell[y], hl[y]
      local byte, run_start, run_group = 0, 0, false
      for x = 1, w + 1 do
         local group = hrow[x] or false
         if group ~= run_group then
            if run_group then
               api.nvim_buf_set_extmark(s.buf, ns, y - 1, run_start, { end_col = byte, hl_group = run_group })
            end
            run_start, run_group = byte, group
         end
         byte = byte + #(crow[x] or "")
      end
   end

   -- Park the cursor on the selected item's marker.
   local cursor_y = cursor_row or math.min(h, menu_top)
   local cursor_col = 0
   for x = 1, menu_left - 1 do
      cursor_col = cursor_col + #cell[cursor_y][x]
   end
   pcall(api.nvim_win_set_cursor, s.win, { cursor_y, cursor_col })
end

---------------------------------------------------------------------------
-- Lifecycle
---------------------------------------------------------------------------

local function close()
   local s = state
   if not s then
      return
   end
   state = nil
   s.timer:stop()
   s.timer:close()
   vim.o.laststatus, vim.o.showtabline = s.saved.laststatus, s.saved.showtabline
end

local function tick()
   local s = state
   if not s then
      return
   end
   if not api.nvim_buf_is_valid(s.buf) then
      return close()
   end
   s.win = vim.fn.bufwinid(s.buf)
   if s.win == -1 then
      return
   end
   local ok, err = pcall(render, uv.hrtime() / 1e9)
   if not ok then
      close()
      vim.notify("dashboard animation stopped: " .. tostring(err), vim.log.levels.WARN)
   end
end

local function run(item)
   if not item then
      return
   end
   local action = item[4]
   if type(action) == "string" then
      vim.cmd(action)
   else
      action()
   end
end

local function open()
   if state and api.nvim_buf_is_valid(state.buf) then
      api.nvim_set_current_buf(state.buf)
      return
   end

   -- Take over the current buffer if it is a pristine [No Name], so no stray
   -- empty buffer is left behind.
   local buf = api.nvim_get_current_buf()
   local pristine = api.nvim_buf_get_name(buf) == ""
      and vim.bo[buf].buftype == ""
      and not vim.bo[buf].modified
      and api.nvim_buf_line_count(buf) == 1
      and api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
   if not pristine then
      buf = api.nvim_create_buf(false, true)
      api.nvim_set_current_buf(buf)
   end
   local win = api.nvim_get_current_win()

   for option, value in pairs({
      buftype = "nofile",
      bufhidden = "wipe",
      swapfile = false,
      buflisted = false,
      undolevels = -1,
      filetype = "dashboard",
   }) do
      vim.bo[buf][option] = value
   end
   for option, value in pairs({
      number = false,
      relativenumber = false,
      cursorline = false,
      cursorcolumn = false,
      list = false,
      wrap = false,
      spell = false,
      signcolumn = "no",
      foldcolumn = "0",
      colorcolumn = "",
      statuscolumn = "",
   }) do
      api.nvim_set_option_value(option, value, { scope = "local", win = win })
   end

   local noise = {}
   for r, row in ipairs(LOGO) do
      noise[r] = {}
      for c = 1, #row do
         noise[r][c] = math.random()
      end
   end

   local now = uv.hrtime() / 1e9
   state = {
      buf = buf,
      win = win,
      start = now,
      last = now,
      selected = 1,
      noise = noise,
      stars = {},
      greeting = chars(greeting()),
      footer = footer_info(),
      saved = { laststatus = vim.o.laststatus, showtabline = vim.o.showtabline },
      timer = assert(uv.new_timer()),
   }
   vim.o.laststatus, vim.o.showtabline = 0, 0

   local function map(lhs, rhs)
      vim.keymap.set("n", lhs, rhs, { buffer = buf, nowait = true, silent = true })
   end
   local function move(delta)
      return function()
         if state then
            state.selected = (state.selected - 1 + delta) % #ITEMS + 1
         end
      end
   end
   for _, item in ipairs(ITEMS) do
      map(item[3], function()
         run(item)
      end)
   end
   for _, lhs in ipairs({ "j", "<Down>", "<Tab>" }) do
      map(lhs, move(1))
   end
   for _, lhs in ipairs({ "k", "<Up>", "<S-Tab>" }) do
      map(lhs, move(-1))
   end
   map("<CR>", function()
      run(state and ITEMS[state.selected])
   end)

   api.nvim_create_autocmd("BufWipeout", { group = augroup, buffer = buf, once = true, callback = close })

   setup_highlights()
   state.timer:start(0, math.floor(1000 / FPS), vim.schedule_wrap(tick))
end

api.nvim_create_autocmd("ColorScheme", { group = augroup, callback = setup_highlights })

api.nvim_create_user_command("Dashboard", open, { desc = "Open the animated dashboard" })

-- Show on startup, unless nvim was given files or is reading from stdin.
local reading_stdin = false
api.nvim_create_autocmd("StdinReadPre", {
   group = augroup,
   callback = function()
      reading_stdin = true
   end,
})
api.nvim_create_autocmd("VimEnter", {
   group = augroup,
   once = true,
   nested = true,
   callback = function()
      if vim.fn.argc() == 0 and not reading_stdin and api.nvim_buf_get_name(0) == "" then
         open()
      end
   end,
})

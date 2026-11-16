-- Animated start screen, no plugin required.
--
-- An animated background (starfield, digital rain, aurora, fire, Game of
-- Life or contour map -- `b` cycles, `B` picks) sits behind an animated logo
-- (nine styles, from a neon sign to a particle swarm -- `l` cycles, `L`
-- picks), with the time and date underneath. The accent colors are a fixed
-- neon-sunset palette (violet, magenta, pink, orange, gold), blended against
-- the active colorscheme's background.
--
-- Opens when nvim starts without a file; reopen any time with :Dashboard.

local api, uv = vim.api, vim.uv

local FPS = 24
local GRAD = 36 -- number of steps in the logo gradient

local ns = api.nvim_create_namespace("animated_dashboard")
local augroup = api.nvim_create_augroup("animated_dashboard", { clear = true })

local function chars(str)
   return vim.fn.split(str, "\\zs")
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

-- Defined with the backgrounds further down.
local cycle_option, pick_option

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

   -- The palette is a neon sunset rather than the colorscheme's own accents:
   -- deep violet, magenta, hot pink, orange, gold.
   local sunset = { 0x4b2a9c, 0x8a3fe0, 0xe0329f, 0xff4f8b, 0xff7a4d, 0xffa53a, 0xffd166 }
   local function sunset_at(pos) -- pos in 0..1
      pos = pos * (#sunset - 1)
      local from = math.min(math.floor(pos), #sunset - 2)
      return blend(sunset[from + 1], sunset[from + 2], pos - from)
   end
   local stops = { sunset[3], sunset[5], sunset[7], sunset[2] }

   -- Cyclic gradient through the stops: solid blocks get the full color,
   -- the logo's box-drawing "shadow" gets a dimmed copy.
   for i = 0, GRAD - 1 do
      local pos = i / GRAD * #stops
      local from = math.floor(pos)
      local color = blend(stops[from + 1], stops[(from + 1) % #stops + 1], pos - from)
      api.nvim_set_hl(0, "DashGrad" .. i, { fg = color, bold = true })
      api.nvim_set_hl(0, "DashShadow" .. i, { fg = blend(color, bg, 0.55) })
      api.nvim_set_hl(0, "DashFaint" .. i, { fg = blend(color, bg, 0.78) })
   end

   for level, amount in ipairs({ 0.16, 0.3, 0.5, 0.85 }) do
      api.nvim_set_hl(0, "DashStar" .. level, { fg = blend(bg, fg, amount) })
   end

   -- Backgrounds are faded to this where they pass behind the logo and clock.
   api.nvim_set_hl(0, "DashVeil", { fg = blend(bg, fg, 0.09) })

   -- Digital rain falls in hot pink.
   for level, amount in ipairs({ 0.16, 0.3, 0.48, 0.7, 0.95 }) do
      api.nvim_set_hl(0, "DashRain" .. level, { fg = blend(bg, sunset[4], amount) })
   end
   api.nvim_set_hl(0, "DashRainHead", { fg = blend(sunset[4], pop, 0.75), bold = true })

   -- Fire is the one background with its own palette: embers to white heat.
   for level, color in ipairs({ 0x4a0a05, 0x8a1505, 0xc42a06, 0xe8500a, 0xf57c10, 0xfbab24, 0xfdd75a, 0xfff4c2 }) do
      api.nvim_set_hl(0, "DashFire" .. level, { fg = blend(bg, color, dark and 1 or 0.85) })
   end

   -- Sunset ramp, violet (1) to gold (13): contour lines by height, and the
   -- blueprint logo top to bottom (skipping the darkest violets).
   for i = 1, 13 do
      local color = sunset_at((i - 1) / 12)
      api.nvim_set_hl(0, "DashTopo" .. i, { fg = blend(bg, color, dark and 0.8 or 0.9) })
      api.nvim_set_hl(0, "DashSun" .. i, { fg = color, bold = true })
      api.nvim_set_hl(0, "DashSunShadow" .. i, { fg = blend(color, bg, 0.45) })
   end
   api.nvim_set_hl(0, "DashClock", { fg = sunset[4], bold = true })
   api.nvim_set_hl(0, "DashDate", { fg = blend(sunset[6], bg, 0.2) })

   api.nvim_set_hl(0, "DashShine", { fg = blend(fg, pop, 0.8), bold = true })
   api.nvim_set_hl(0, "DashItem", { fg = blend(fg, bg, 0.15) })
   api.nvim_set_hl(0, "DashSelected", { fg = blend(fg, pop, 0.6), bold = true })
   api.nvim_set_hl(0, "DashDim", { fg = blend(bg, fg, 0.42) })
end

---------------------------------------------------------------------------
-- State
---------------------------------------------------------------------------

local state = nil -- nil while no dashboard is open

---------------------------------------------------------------------------
-- Backgrounds
---------------------------------------------------------------------------

-- Each background has `init(w, h)`, returning its private data (rebuilt on
-- resize), and `draw(data, f)`, which paints one frame into
-- f = { cell, hl, w, h, t, dt }. Backgrounds with `veil = true` are busy
-- enough that they are faded where they pass behind the logo and clock.
-- Cycle through them with `b` on the dashboard; the choice is remembered.
local BACKGROUNDS = {}
local BG_ORDER = { "stars", "rain", "aurora", "fire", "life", "contours" }

local sin, floor, random = math.sin, math.floor, math.random

local function clamp(v, lo, hi)
   return v < lo and lo or v > hi and hi or v
end

local function plot(f, y, x, glyph, group)
   if y >= 1 and y <= f.h and x >= 1 and x <= f.w then
      f.cell[y][x], f.hl[y][x] = glyph, group
   end
end

local function new_stars(w, h, area_per_star)
   local stars = {}
   for i = 1, floor(w * h / area_per_star) do
      stars[i] = {
         x = 1 + random() * w,
         y = random(h),
         layer = random(3), -- 1 = far and slow, 3 = near and fast
         phase = random() * math.pi * 2,
         twinkle = 0.5 + random() * 2,
      }
   end
   return stars
end

local function draw_stars(stars, f, drift)
   for _, star in ipairs(stars) do
      star.x = star.x - star.layer * drift * f.dt
      if star.x < 1 then
         star.x = star.x + f.w
         star.y = random(f.h)
      end
      local glow = (sin(f.t * star.twinkle + star.phase) + 1) / 2
      local level = math.max(1, math.min(4, floor(glow * 2 + star.layer)))
      local glyph = star.layer == 1 and "." or star.layer == 2 and "·" or (glow > 0.93 and "✦" or "•")
      plot(f, star.y, floor(star.x), glyph, "DashStar" .. level)
   end
end

-- Starfield: three parallax layers drifting left, twinkling, with a
-- shooting star every few seconds.
BACKGROUNDS.stars = {
   label = "Starfield",
   about = "drifting, twinkling stars and the odd shooting star",
   init = function(w, h)
      return { stars = new_stars(w, h, 38) }
   end,
   draw = function(d, f)
      draw_stars(d.stars, f, 0.55)
      if not d.shoot and random() < f.dt / 4 then
         d.shoot = { x = random() * f.w * 0.7, y = 1 + random() * f.h * 0.4, vx = 42, vy = 12 }
      end
      local sh = d.shoot
      if sh then
         sh.x, sh.y = sh.x + sh.vx * f.dt, sh.y + sh.vy * f.dt
         for k = 9, 0, -1 do
            local glyph = k == 0 and "•" or k < 4 and "·" or "."
            plot(
               f,
               floor(sh.y - sh.vy * k * 0.017),
               floor(sh.x - sh.vx * k * 0.017),
               glyph,
               "DashStar" .. (4 - floor(k / 2.5))
            )
         end
         if sh.x - 8 > f.w or sh.y - 4 > f.h then
            d.shoot = nil
         end
      end
   end,
}

-- Digital rain: columns of half-width katakana falling at different speeds,
-- bright at the head and fading up the tail, glyphs flickering as they go.
local RAIN_GLYPHS = chars("0123456789")
for codepoint = 0xff66, 0xff9d do
   RAIN_GLYPHS[#RAIN_GLYPHS + 1] = vim.fn.nr2char(codepoint)
end

local function reset_drop(drop, h, scatter)
   drop.y = scatter and (random() * 2 - 1) * h or -random() * h * 0.4
   drop.speed = 5 + random() * 16
   drop.len = 5 + random(math.max(2, floor(h * 0.5)))
end

BACKGROUNDS.rain = {
   label = "Digital rain",
   about = "falling columns of flickering katakana",
   veil = true,
   init = function(w, h)
      local drops = {}
      for x = 1, w do
         if random() < 0.7 then
            local drop = { x = x }
            reset_drop(drop, h, true)
            drops[#drops + 1] = drop
         end
      end
      return { drops = drops }
   end,
   draw = function(d, f)
      local count = #RAIN_GLYPHS
      for _, drop in ipairs(d.drops) do
         drop.y = drop.y + drop.speed * f.dt
         local head = floor(drop.y)
         for i = 0, drop.len do
            local y = head - i
            if y >= 1 and y <= f.h then
               -- cheap positional hash, so glyphs stay put but flicker over time
               local flicker = floor(f.t * (i == 0 and 14 or 1.5) + drop.x)
               local glyph = RAIN_GLYPHS[floor(sin(drop.x * 12.9898 + y * 78.233 + flicker * 37.719) * 43758.5453 % count) + 1]
               local group = i == 0 and "DashRainHead" or "DashRain" .. math.max(1, 5 - floor(i / drop.len * 5))
               plot(f, y, drop.x, glyph, group)
            end
         end
         if head - drop.len > f.h then
            reset_drop(drop, f.h, false)
         end
      end
   end,
}

-- Aurora: three curtains of light over a still night sky. Each has a bright,
-- slowly waving lower edge with shimmering rays fading upward from it.
BACKGROUNDS.aurora = {
   label = "Aurora",
   about = "curtains of light waving over a night sky",
   veil = true,
   init = function(w, h)
      return { stars = new_stars(w, h, 75), glow = {} }
   end,
   draw = function(d, f)
      draw_stars(d.stars, f, 0)
      local w, h, t, glow = f.w, f.h, f.t, d.glow
      local reach = h * 0.34
      for x = 1, w do
         for y = 1, h do
            glow[y] = 0
         end
         for k = 1, 3 do
            local edge = h * (0.3 + 0.17 * k) + sin(x * 0.045 * k + t * 0.35 + k * 2) * h * 0.07 + sin(x * 0.017 - t * 0.22 + k) * h * 0.06
            local ray = 0.5 + 0.5 * sin(x * 0.8 + t * 2.2 + k * 1.7 + sin(x * 0.11 + t * 0.5) * 3)
            local strength = (0.15 + 0.85 * ray * ray) * (k == 2 and 1 or 0.75)
            for y = math.max(1, floor(edge - reach)), math.min(h, floor(edge)) do
               local v = 1 - (edge - y) / reach
               glow[y] = glow[y] + v * v * strength
            end
         end
         for y = 1, h do
            local v = glow[y]
            if v > 0.1 then
               local hue = floor(x * 0.22 + y * 0.6 + t * 2.5) % GRAD
               if v < 0.22 then
                  plot(f, y, x, "░", "DashFaint" .. hue)
               elseif v < 0.48 then
                  plot(f, y, x, "░", "DashShadow" .. hue)
               elseif v < 0.8 then
                  plot(f, y, x, "▒", "DashShadow" .. hue)
               else
                  plot(f, y, x, "▓", "DashShadow" .. hue)
               end
            end
         end
      end
   end,
}

-- Fire: the classic cellular fire. Heat is injected along the bottom row and
-- each cell takes the heat of a jittered cell below it minus a random loss,
-- so flames lick upward and cool; stray embers drift off the top.
local FIRE_GLYPHS = { ".", ":", "░", "░", "▒", "▒", "▓", "█" }

BACKGROUNDS.fire = {
   label = "Fire",
   about = "flames rising from the bottom, with embers",
   veil = true,
   init = function(w, h)
      local rows = math.max(4, floor(h * 0.5))
      local heat = {}
      for y = 1, rows do
         heat[y] = {}
         for x = 1, w do
            heat[y][x] = 0
         end
      end
      return { rows = rows, heat = heat, embers = {}, clock = 0 }
   end,
   draw = function(d, f)
      local w, rows, heat = f.w, d.rows, d.heat
      d.clock = math.min(d.clock + f.dt, 0.15)
      while d.clock >= 0.05 do
         d.clock = d.clock - 0.05
         local loss = 36 / rows * 2.1
         for y = 1, rows - 1 do
            local row, below = heat[y], heat[y + 1]
            for x = 1, w do
               local v = below[math.max(1, math.min(w, x + random(-1, 1)))] - random() * loss
               row[x] = v > 0 and v or 0
            end
         end
         local source = heat[rows]
         for x = 1, w do
            source[x] = 36 * (0.55 + 0.45 * random()) * (0.7 + 0.3 * sin(x * 0.13 + f.t * 1.1))
         end
      end

      local top = f.h - rows
      for y = 1, rows do
         local row = heat[y]
         for x = 1, w do
            local v = row[x]
            if v > 1.5 then
               local level = math.min(8, floor(v / 36 * 8) + 1)
               plot(f, top + y, x, FIRE_GLYPHS[level], "DashFire" .. level)
            end
         end
      end

      if random() < f.dt * 7 then
         d.embers[#d.embers + 1] = {
            x = random(w),
            y = f.h - rows * (0.3 + random() * 0.4),
            vx = (random() - 0.5) * 4,
            vy = -(3 + random() * 6),
            life = 1.5 + random() * 2.5,
         }
      end
      for i = #d.embers, 1, -1 do
         local ember = d.embers[i]
         ember.x = ember.x + (ember.vx + sin(f.t * 3 + i) * 2) * f.dt
         ember.y = ember.y + ember.vy * f.dt
         ember.life = ember.life - f.dt
         local y, x = floor(ember.y), floor(ember.x)
         if ember.life <= 0 or y < 1 then
            table.remove(d.embers, i)
         elseif x >= 1 and x <= w and not f.hl[y][x] then
            plot(f, y, x, ember.life > 1.2 and "•" or "·", "DashFire" .. math.max(2, math.min(7, floor(ember.life * 2.5))))
         end
      end
   end,
}

-- Life: Conway's Game of Life on a wrapping grid. Newborn cells are bright,
-- survivors settle into the gradient, and the dead leave a fading ghost.
-- The colony is reseeded when it dies out or stops changing.
BACKGROUNDS.life = {
   label = "Game of Life",
   about = "Conway's cells being born, fading and reseeding",
   veil = true,
   init = function(w, h)
      local d = { age = {}, ghost = {}, clock = 0, stale = 0, population = -1 }
      for y = 1, h do
         d.age[y], d.ghost[y] = {}, {}
         for x = 1, w do
            d.age[y][x] = random() < 0.28 and 1 or 0 -- age 0 = dead
            d.ghost[y][x] = 0
         end
      end
      return d
   end,
   draw = function(d, f)
      local w, h = f.w, f.h
      d.clock = d.clock + f.dt
      if d.clock >= 0.11 then
         d.clock = 0
         local age, ghost, next_age, population = d.age, d.ghost, {}, 0
         for y = 1, h do
            local up, row, down = age[(y - 2) % h + 1], age[y], age[y % h + 1]
            local new_row, ghost_row = {}, ghost[y]
            for x = 1, w do
               local l, r = (x - 2) % w + 1, x % w + 1
               local n = (up[l] > 0 and 1 or 0)
                  + (up[x] > 0 and 1 or 0)
                  + (up[r] > 0 and 1 or 0)
                  + (row[l] > 0 and 1 or 0)
                  + (row[r] > 0 and 1 or 0)
                  + (down[l] > 0 and 1 or 0)
                  + (down[x] > 0 and 1 or 0)
                  + (down[r] > 0 and 1 or 0)
               local alive = row[x] > 0
               if n == 3 or (alive and n == 2) then
                  new_row[x] = row[x] + 1
                  population = population + 1
               else
                  new_row[x] = 0
                  ghost_row[x] = alive and 3 or math.max(0, ghost_row[x] - 1)
               end
            end
            next_age[y] = new_row
         end
         d.age = next_age
         d.stale = population == d.population and d.stale + 1 or 0
         d.population = population
         if population < w * h * 0.02 or d.stale > 25 then
            d.stale = 0
            for y = 1, h do
               for x = 1, w do
                  if random() < 0.16 then
                     next_age[y][x] = 1
                  end
               end
            end
         end
      end

      for y = 1, h do
         local row, ghost_row = d.age[y], d.ghost[y]
         for x = 1, w do
            local a = row[x]
            if a > 0 then
               local hue = floor(x * 0.4 + y + f.t * 5) % GRAD
               if a <= 2 then
                  plot(f, y, x, "●", "DashGrad" .. hue)
               elseif a <= 8 then
                  plot(f, y, x, "•", "DashShadow" .. hue)
               else
                  plot(f, y, x, "∙", "DashFaint" .. hue)
               end
            elseif ghost_row[x] > 0 then
               plot(f, y, x, "·", "DashStar" .. ghost_row[x])
            end
         end
      end
   end,
}

-- Contours: a slowly shifting height field drawn as a topographic map. A
-- cell is inked when a contour level passes through it, with the stroke
-- following the direction of the line, colored by height like a sunset.
BACKGROUNDS.contours = {
   label = "Contours",
   about = "a slowly shifting topographic map",
   veil = true,
   init = function()
      return { above = {}, here = {} }
   end,
   draw = function(d, f)
      local w, h, t = f.w, f.h, f.t
      local cx, cy = w * 0.5 + sin(t * 0.07) * w * 0.25, h * 0.5 + sin(t * 0.05 + 1) * h * 0.2
      local function height(x, y)
         local dx, dy = x - cx, (y - cy) * 2
         return 1.7
            * (
               sin(x * 0.06 + t * 0.21)
               + sin(y * 0.13 - t * 0.17)
               + sin(x * 0.04 + y * 0.09 + t * 0.12)
               + sin(math.sqrt(dx * dx + dy * dy) * 0.09 - t * 0.35)
            )
      end

      local here, below = d.above, d.here
      for x = 1, w + 1 do
         here[x] = height(x, 1)
      end
      for y = 1, h do
         for x = 1, w + 1 do
            below[x] = height(x, y + 1)
         end
         for x = 1, w do
            local v = here[x]
            local gx, gy = here[x + 1] - v, (below[x] - v) * 0.5 -- cells are ~twice as tall as wide
            local level = floor(v + 0.5)
            local slope = math.sqrt(gx * gx + gy * gy)
            if slope > 0.004 and math.abs(v - level) / slope < 0.5 then
               local ax, ay = math.abs(gx), math.abs(gy)
               local glyph = ax > ay * 2.4 and "│" or ay > ax * 2.4 and "─" or (gx * gy > 0 and "╱" or "╲")
               local group = "DashTopo" .. clamp(level, -6, 6) + 7
               plot(f, y, x, glyph, group)
            end
         end
         here, below = below, here
      end
   end,
}

---------------------------------------------------------------------------
-- Foregrounds (logo styles)
---------------------------------------------------------------------------

-- Each foreground pairs a piece of logo art with its own animation. Like a
-- background it has `init()` and `draw(data, f, left, top)`; here f.t counts
-- from the moment the style was switched on, so every style gets its intro.
-- Cycle through them with `l` on the dashboard; the choice is remembered.
-- (Art rendered once from FIGlet fonts and embedded, so nothing is needed
-- at runtime.)
local ART = {
   elite = {
      [=[ ▐ ▄ ▄▄▄ .       ▌ ▐·▪  • ▌ ▄ ·. ]=],
      [=[•█▌▐█▀▄.▀·▪     ▪█·█▌██ ·██ ▐███▪]=],
      [=[▐█▐▐▌▐▀▀▪▄ ▄█▀▄ ▐█▐█•▐█·▐█ ▌▐▌▐█·]=],
      [=[██▐█▌▐█▄▄▌▐█▌.▐▌ ███ ▐█▌██ ██▌▐█▌]=],
      [=[▀▀ █▪ ▀▀▀  ▀█▄▀▪. ▀  ▀▀▀▀▀  █▪▀▀▀]=],
   },
   blocks = {
      [=[███    ██ ███████  ██████  ██    ██ ██ ███    ███]=],
      [=[████   ██ ██      ██    ██ ██    ██ ██ ████  ████]=],
      [=[██ ██  ██ █████   ██    ██ ██    ██ ██ ██ ████ ██]=],
      [=[██  ██ ██ ██      ██    ██  ██  ██  ██ ██  ██  ██]=],
      [=[██   ████ ███████  ██████    ████   ██ ██      ██]=],
   },
   slant = {
      [=[    _   ____________ _    ________  ___]=],
      [=[   / | / / ____/ __ \ |  / /  _/  |/  /]=],
      [=[  /  |/ / __/ / / / / | / // // /|_/ / ]=],
      [=[ / /|  / /___/ /_/ /| |/ // // /  / /  ]=],
      [=[/_/ |_/_____/\____/ |___/___/_/  /_/   ]=],
   },
   delta = {
      [=[███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄  ]=],
      [=[███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄]=],
      [=[███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███]=],
      [=[███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███]=],
      [=[███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███]=],
      [=[███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███]=],
      [=[███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███]=],
      [=[ ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀ ]=],
   },
   bloody = {
      [=[ ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓]=],
      [=[ ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒]=],
      [=[▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░]=],
      [=[▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██ ]=],
      [=[▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒]=],
      [=[░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░]=],
      [=[░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░]=],
      [=[   ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░   ]=],
      [=[         ░    ░  ░    ░ ░        ░   ░         ░   ]=],
      [=[                                ░                  ]=],
   },
   solid3d = {
      [=[ ________   _______   ________  ___      ___ ___  _____ ______      ]=],
      [=[|\   ___  \|\  ___ \ |\   __  \|\  \    /  /|\  \|\   _ \  _   \    ]=],
      [=[\ \  \\ \  \ \   __/|\ \  \|\  \ \  \  /  / | \  \ \  \\\__\ \  \   ]=],
      [=[ \ \  \\ \  \ \  \_|/_\ \  \\\  \ \  \/  / / \ \  \ \  \\|__| \  \  ]=],
      [=[  \ \  \\ \  \ \  \_|\ \ \  \\\  \ \    / /   \ \  \ \  \    \ \  \ ]=],
      [=[   \ \__\\ \__\ \_______\ \_______\ \__/ /     \ \__\ \__\    \ \__\]=],
      [=[    \|__| \|__|\|_______|\|_______|\|__|/       \|__|\|__|     \|__|]=],
   },
   calvin = {
      { "╔╗╔", "║║║", "╝╚╝" },
      { "╔═╗", "║╣ ", "╚═╝" },
      { "╔═╗", "║ ║", "╚═╝" },
      { "╦  ╦", "╚╗╔╝", " ╚╝ " },
      { "╦", "║", "╩" },
      { "╔╦╗", "║║║", "╩ ╩" },
   },
}

local FOREGROUNDS = {}
local FG_ORDER = { "flow", "neon", "glitch", "assemble", "wave", "scanner", "molten", "blueprint", "minimal" }

-- Gradient flow: the block logo decodes from noise column by column, then
-- the gradient flows diagonally through it and a highlight sweeps across.
FOREGROUNDS.flow = {
   label = "Gradient flow",
   about = "block letters decoding, then awash in a moving gradient",
   rows = LOGO,
   init = function()
      local noise = {}
      for r, row in ipairs(LOGO) do
         noise[r] = {}
         for c = 1, #row do
            noise[r][c] = random()
         end
      end
      return { noise = noise }
   end,
   draw = function(d, f, left, top)
      local t = f.t
      local sweep = (t % 6) / 1.1 * (LOGO_WIDTH + 24) - 12
      for r, row in ipairs(LOGO) do
         for c, glyph in ipairs(row) do
            if glyph ~= " " then
               local index = floor(c * 0.8 + r * 2 - t * 13) % GRAD
               local group
               if t < c / LOGO_WIDTH * 0.7 + d.noise[r][c] * 0.45 then
                  glyph = SCRAMBLE[random(#SCRAMBLE)]
                  group = "DashShadow" .. index
               elseif t > 1.6 and math.abs(c + r * 1.5 - sweep) < 2 then
                  group = "DashShine"
               else
                  group = (glyph == "█" and "DashGrad" or "DashShadow") .. index
               end
               plot(f, top + r - 1, left + c - 1, glyph, group)
            end
         end
      end
   end,
}

-- Neon: a small framed sign. Each letter is its own tube with its own color;
-- they stutter on one by one, and one tube is faulty and keeps flickering.
local NEON_ROWS, NEON_OWNER = {}, {} -- NEON_OWNER[c] = which letter owns column c
do
   local inner = { "   ", "   ", "   " }
   for c = 1, 3 do
      NEON_OWNER[c + 1] = 0
   end
   for i, letter in ipairs(ART.calvin) do
      for _ = 1, #chars(letter[1]) do
         NEON_OWNER[#NEON_OWNER + 1] = i
      end
      for _ = 1, (i < #ART.calvin and 2 or 3) do
         NEON_OWNER[#NEON_OWNER + 1] = 0
      end
      for r = 1, 3 do
         inner[r] = inner[r] .. letter[r] .. (i < #ART.calvin and "  " or "   ")
      end
   end
   local span = #chars(inner[1])
   NEON_ROWS = vim.tbl_map(chars, {
      "╭" .. ("─"):rep(span) .. "╮",
      "│" .. inner[1] .. "│",
      "│" .. inner[2] .. "│",
      "│" .. inner[3] .. "│",
      "╰" .. ("─"):rep(span) .. "╯",
   })
end

FOREGROUNDS.neon = {
   label = "Neon sign",
   about = "a small framed sign whose tubes stutter on and flicker",
   rows = NEON_ROWS,
   init = function()
      local d = { faulty = random(#ART.calvin), tubes = {} }
      for i = 1, #ART.calvin do
         d.tubes[i] = { on_at = 0.35 + i * 0.22, dark_until = 0 }
      end
      return d
   end,
   draw = function(d, f, left, top)
      local t = f.t
      local lit = {}
      for i, tube in ipairs(d.tubes) do
         if t > tube.on_at + 0.4 and t > tube.dark_until and random() < f.dt * (i == d.faulty and 1.1 or 0.07) then
            tube.dark_until = t + 0.04 + random() * 0.2
         end
         local warming = t < tube.on_at + 0.4 and random() < 0.45
         lit[i] = t >= tube.on_at and t >= tube.dark_until and not warming
      end
      local drift = floor(t * 1.5)
      for r, row in ipairs(NEON_ROWS) do
         for c, glyph in ipairs(row) do
            if glyph ~= " " then
               local owner = (r > 1 and r < #NEON_ROWS) and NEON_OWNER[c] or 0
               local group
               if owner == 0 then
                  group = (t > 0.15 and "DashShadow" or "DashVeil") .. (t > 0.15 and drift % GRAD or "")
               elseif lit[owner] then
                  group = "DashGrad" .. floor((owner - 1) * GRAD / #ART.calvin + drift) % GRAD
               else
                  group = "DashVeil"
               end
               plot(f, top + r - 1, left + c - 1, glyph, group)
            end
         end
      end
   end,
}

-- Glitch: a jagged logo that sits still, then tears: rows jump sideways,
-- leaving color-split ghosts and corrupted glyphs for a fraction of a second.
FOREGROUNDS.glitch = {
   label = "Glitch",
   about = "jagged letters that tear sideways with color-split ghosts",
   rows = vim.tbl_map(chars, ART.elite),
   init = function()
      return { burst_until = 0.7, next_burst = 0 }
   end,
   draw = function(d, f, left, top)
      local t = f.t
      if t > d.next_burst and t > d.burst_until then
         d.burst_until = t + 0.12 + random() * 0.3
         d.next_burst = d.burst_until + 1.5 + random() * 4
      end
      local bursting = t < d.burst_until
      local rows = FOREGROUNDS.glitch.rows
      local scan = floor(t * 4) % (#rows + 10)
      for r, row in ipairs(rows) do
         local y, shift = top + r - 1, 0
         if bursting and random() < 0.6 then
            shift = random(-4, 4)
         elseif not bursting and random() < 0.004 then
            shift = random(-1, 1)
         end
         if bursting and shift ~= 0 then
            for c, glyph in ipairs(row) do
               if glyph ~= " " then
                  plot(f, y, left + c - 1 + shift - 2, glyph, "DashGrad0")
                  plot(f, y, left + c - 1 + shift + 2, glyph, "DashGrad" .. floor(GRAD / 2))
               end
            end
         end
         for c, glyph in ipairs(row) do
            if glyph ~= " " then
               if bursting and random() < 0.08 then
                  glyph = SCRAMBLE[random(#SCRAMBLE)]
               end
               plot(f, y, left + c - 1 + shift, glyph, r == scan and "DashDim" or "DashSelected")
            end
         end
      end
   end,
}

-- Assemble: every block of the logo is a particle. They fly in from all
-- over the screen and lock into place, hold, then scatter and regroup.
FOREGROUNDS.assemble = {
   label = "Assemble",
   about = "particles fly in to build the logo, then scatter and regroup",
   rows = vim.tbl_map(chars, ART.blocks),
   init = function()
      local parts = {}
      for r, row in ipairs(FOREGROUNDS.assemble.rows) do
         for c, glyph in ipairs(row) do
            if glyph ~= " " then
               parts[#parts + 1] = { r = r, c = c, glyph = glyph }
            end
         end
      end
      return { parts = parts, cycle = -1 }
   end,
   draw = function(d, f, left, top)
      local period = 14
      local cycle = floor(f.t / period)
      if cycle ~= d.cycle then
         d.cycle = cycle
         for _, p in ipairs(d.parts) do
            p.sx, p.sy = p.c + (random() - 0.5) * 130, p.r + (random() - 0.5) * 44
            p.delay = random() * 0.6
         end
      end
      local t = f.t - cycle * period
      for _, p in ipairs(d.parts) do
         local k -- 0 = at its scattered position, 1 = locked into the logo
         if t < 12.3 then
            k = clamp((t - p.delay) / 0.9, 0, 1)
            k = 1 - (1 - k) ^ 3
         else
            local q = clamp((t - 12.3 - p.delay * 0.5) / 1.2, 0, 1)
            k = 1 - q * q
         end
         local hue = floor(p.c * 0.7 + p.r + f.t * 4) % GRAD
         if k >= 1 then
            plot(f, top + p.r - 1, left + p.c - 1, p.glyph, random() < 0.0015 and "DashShine" or "DashGrad" .. hue)
         elseif k > 0 then
            local x, y = p.sx + (p.c - p.sx) * k, p.sy + (p.r - p.sy) * k
            local glyph = k > 0.8 and p.glyph or k > 0.4 and "•" or "·"
            local group = k > 0.8 and "DashShadow" .. hue or "DashStar" .. (k > 0.4 and 3 or 2)
            plot(f, floor(top + y - 0.5), floor(left + x - 0.5), glyph, group)
         end
      end
   end,
}

-- Wave: slanted line-art letters rippling like a flag, each column riding
-- its own point on a travelling sine wave.
FOREGROUNDS.wave = {
   label = "Wave",
   about = "slanted line-art letters rippling like a flag",
   rows = vim.tbl_map(chars, ART.slant),
   draw = function(_, f, left, top)
      local t = f.t
      for r, row in ipairs(FOREGROUNDS.wave.rows) do
         for c, glyph in ipairs(row) do
            if glyph ~= " " and c < t * 70 then
               -- a long wavelength, so whole letters ride the swell instead of shearing apart
               local lift = floor(sin(c * 0.075 - t * 2.2) * 1.3 + 0.5)
               plot(f, top + r - 1 + lift, left + c - 1, glyph, "DashGrad" .. floor(c * 0.9 + r - t * 12) % GRAD)
            end
         end
      end
   end,
}

-- Scanner: tall, heavy letters left almost dark, with a bar of light
-- sweeping back and forth across them and trailing a fading glow.
FOREGROUNDS.scanner = {
   label = "Scanner",
   about = "heavy dark letters swept by a bar of light with a glowing trail",
   rows = vim.tbl_map(chars, ART.delta),
   draw = function(_, f, left, top)
      local t = f.t
      local rows = FOREGROUNDS.scanner.rows
      local width = #rows[1]
      local position = (sin(t * 1.3) * 0.5 + 0.5) * (width + 8) - 3
      local direction = math.cos(t * 1.3) >= 0 and 1 or -1
      local hue = floor(t * 2) % GRAD
      for r, row in ipairs(rows) do
         for c, glyph in ipairs(row) do
            if glyph ~= " " then
               local behind = (position - c) * direction -- > 0: the light has passed
               local group
               if t < 0.5 then
                  group = "DashVeil"
               elseif math.abs(behind) < 1.5 then
                  group = "DashShine"
               elseif behind > -3 and behind < 6 then
                  group = "DashGrad" .. hue
               elseif behind > 0 and behind < 15 then
                  group = "DashShadow" .. hue
               else
                  group = "DashFaint" .. hue
               end
               plot(f, top + r - 1, left + c - 1, glyph, group)
            end
         end
      end
   end,
}

-- Molten: dripping letters in the fire palette. Solid parts glow white-hot,
-- the drips cool toward embers, and heat ripples through the whole thing.
local MOLTEN_HEAT = { ["█"] = 7, ["▓"] = 5.5, ["▒"] = 4, ["░"] = 2.4 }

FOREGROUNDS.molten = {
   label = "Molten",
   about = "dripping letters glowing white-hot and cooling to embers",
   rows = vim.tbl_map(chars, ART.bloody),
   draw = function(_, f, left, top)
      local t = f.t
      local warmup = clamp(t / 1.5, 0.15, 1)
      for r, row in ipairs(FOREGROUNDS.molten.rows) do
         for c, glyph in ipairs(row) do
            if glyph ~= " " then
               local heat = (MOLTEN_HEAT[glyph] or 6) + 1.2 * sin(c * 0.4 - t * 2.5 + r * 0.7) + 0.8 * sin(c * 1.9 + t * 6.3)
               plot(f, top + r - 1, left + c - 1, glyph, "DashFire" .. clamp(floor(heat * warmup + 0.5), 1, 8))
            end
         end
      end
   end,
}

-- Blueprint: 3D line-art letters drawn in by a pen sweeping diagonally,
-- then left as a sunset (magenta at the top down to gold) with a glint
-- passing over now and then.
FOREGROUNDS.blueprint = {
   label = "Blueprint",
   about = "3D line-art letters sketched in by a sweeping pen",
   rows = vim.tbl_map(chars, ART.solid3d),
   draw = function(_, f, left, top)
      local t = f.t
      local rows = FOREGROUNDS.blueprint.rows
      local pen = t * 62
      local glint = ((t - 3) % 8) * (#rows[1] + 30) - 10
      for r, row in ipairs(rows) do
         for c, glyph in ipairs(row) do
            local reach = c + r * 4
            if glyph ~= " " and reach < pen then
               local group
               if pen - reach < 3 or (t > 3 and math.abs(c + r * 2 - glint) < 2) then
                  group = "DashShine"
               else
                  group = (glyph == "_" and "DashSunShadow" or "DashSun") .. 3 + floor((r - 1) / math.max(1, #rows - 1) * 10 + 0.5)
               end
               plot(f, top + r - 1, left + c - 1, glyph, group)
            end
         end
      end
   end,
}

-- Minimal: just the name, letterspaced, breathing slowly over a thin rule
-- with a single point of light gliding along it.
FOREGROUNDS.minimal = {
   label = "Minimal",
   about = "a quiet letterspaced wordmark breathing over a thin rule",
   rows = vim.tbl_map(chars, { "n   e   o   v   i   m", (" "):rep(21), ("─"):rep(21) }),
   draw = function(_, f, left, top)
      local t = f.t
      local rows = FOREGROUNDS.minimal.rows
      for i = 1, 6 do
         local c = 1 + (i - 1) * 4
         local age = t - 0.3 - i * 0.18
         if age > 0 then
            local breath = 0.5 + 0.5 * sin(t * 1.1 - i * 0.6)
            local group = age < 0.15 and "DashDim" or breath > 0.75 and "DashSelected" or breath > 0.3 and "DashItem" or "DashDim"
            plot(f, top, left + c - 1, rows[1][c], group)
         end
      end
      local hue = floor(t * 2) % GRAD
      local half = clamp((t - 0.4) * 16, 0, 10)
      local light = 11 + sin(t * 0.9) * half
      for c = floor(11 - half), floor(11 + half) do
         local distance = math.abs(c - light)
         if distance < 0.6 then
            plot(f, top + 2, left + c - 1, "━", "DashGrad" .. hue)
         else
            plot(f, top + 2, left + c - 1, "─", (distance < 3 and "DashShadow" or "DashFaint") .. hue)
         end
      end
   end,
}

for _, style in pairs(FOREGROUNDS) do
   style.width, style.height = #style.rows[1], #style.rows
   style.init = style.init or function()
      return {}
   end
end

---------------------------------------------------------------------------
-- Choosing a background / logo
---------------------------------------------------------------------------

local OPTIONS = {
   background = { noun = "Background", items = BACKGROUNDS, order = BG_ORDER, field = "bg", data = "bgdata" },
   logo = { noun = "Logo", items = FOREGROUNDS, order = FG_ORDER, field = "fg", data = "fgdata", default = "blueprint" },
}
for kind, option in pairs(OPTIONS) do
   option.file = vim.fn.stdpath("state") .. "/dashboard-" .. kind
end

local function saved_choice(option)
   local file = io.open(option.file)
   local name = file and file:read("*l")
   if file then
      file:close()
   end
   return option.items[name] and name or option.default or option.order[1]
end

-- `persist = false` only previews: the choice isn't written to disk.
local function set_choice(option, name, persist)
   if not state or not option.items[name] then
      return
   end
   if state[option.field] ~= name then
      state[option.field], state[option.data] = name, nil
   end
   if persist == false then
      return
   end
   vim.fn.mkdir(vim.fs.dirname(option.file), "p")
   local file = io.open(option.file, "w")
   if file then
      file:write(name)
      file:close()
   end
end

-- Apply a background or logo by name, whichever it is (names don't overlap).
local function set_named(name)
   for _, option in pairs(OPTIONS) do
      set_choice(option, name)
   end
end

cycle_option = function(kind)
   local option = OPTIONS[kind]
   if not state then
      return
   end
   for i, name in ipairs(option.order) do
      if name == state[option.field] then
         return set_choice(option, option.order[i % #option.order + 1])
      end
   end
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
      s.bgdata = nil
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

   -- Vertical layout, centered; gaps collapse on short windows.
   local style = FOREGROUNDS[s.fg]
   local big_logo = w >= style.width + 4
   local logo_height = big_logo and style.height or 1
   local top = math.max(1, math.floor((h - (logo_height + 4)) / 2) + 1)
   local time_row = top + logo_height + 2
   local date_row = time_row + 1
   local time_line = chars(os.date("%H:%M:%S"))
   local date_line = chars(os.date("%A %d %B %Y"))

   -- Background first; busy ones are faded where the content sits on top.
   local background = BACKGROUNDS[s.bg]
   s.bgdata = s.bgdata or background.init(w, h)
   local frame = { cell = cell, hl = hl, w = w, h = h, t = t, dt = dt }
   background.draw(s.bgdata, frame)
   if background.veil then
      local half = math.floor(math.max(big_logo and style.width or #LOGO_SMALL, #date_line) / 2) + 4
      local from, to = math.max(1, math.floor(w / 2) - half), math.min(w, math.floor(w / 2) + half + 1)
      for y = math.max(1, top - 1), math.min(h, date_row + 1) do
         local hrow = hl[y]
         for x = from, to do
            if hrow[x] then
               hrow[x] = "DashVeil"
            end
         end
      end
   end

   -- Logo, in the chosen style (a plain wordmark if the window is too narrow).
   if big_logo then
      if not s.fgdata then
         s.fgdata, s.fgstart = style.init(), t
      end
      frame.t = t - s.fgstart
      style.draw(s.fgdata, frame, math.floor((w - style.width) / 2) + 1, top)
   else
      local left = math.floor((w - #LOGO_SMALL) / 2) + 1
      for c, glyph in ipairs(LOGO_SMALL) do
         put(top, left + c - 1, { glyph }, "DashGrad" .. math.floor(c * 2 - t * 13) % GRAD)
      end
   end

   -- Clock: the time, with the date under it, fading in after the logo.
   if t > 0.9 then
      local lit = t > 1.3
      put(time_row, math.floor((w - #time_line) / 2) + 1, time_line, lit and "DashClock" or "DashDim")
      if t > 1.1 then
         put(date_row, math.floor((w - #date_line) / 2) + 1, date_line, lit and "DashDate" or "DashDim")
      end
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

   -- Park the cursor out of the way, in the bottom-left corner.
   pcall(api.nvim_win_set_cursor, s.win, { h, 0 })
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

local function open(choice)
   if state and api.nvim_buf_is_valid(state.buf) then
      api.nvim_set_current_buf(state.buf)
      set_named(choice)
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

   local now = uv.hrtime() / 1e9
   state = {
      buf = buf,
      win = win,
      start = now,
      last = now,
      bg = saved_choice(OPTIONS.background),
      fg = saved_choice(OPTIONS.logo),
      saved = { laststatus = vim.o.laststatus, showtabline = vim.o.showtabline },
      timer = assert(uv.new_timer()),
   }
   vim.o.laststatus, vim.o.showtabline = 0, 0

   local function map(lhs, rhs)
      vim.keymap.set("n", lhs, rhs, { buffer = buf, nowait = true, silent = true })
   end
   map("b", function()
      cycle_option("background")
   end)
   map("l", function()
      cycle_option("logo")
   end)
   map("B", function()
      pick_option("background")
   end)
   map("L", function()
      pick_option("logo")
   end)

   api.nvim_create_autocmd("BufWipeout", { group = augroup, buffer = buf, once = true, callback = close })

   set_named(choice)
   setup_highlights()
   state.timer:start(0, math.floor(1000 / FPS), vim.schedule_wrap(tick))
end

api.nvim_create_autocmd("ColorScheme", { group = augroup, callback = setup_highlights })

-- Telescope picker over the backgrounds (<leader>sb, or `B` on the
-- dashboard) or the logo styles (<leader>sl, or `L`). Moving through the
-- list previews each one live behind the picker; <CR> keeps it, <Esc> goes
-- back to what was there before.
pick_option = function(kind)
   local option = OPTIONS[kind]
   open()
   if not state then
      return
   end
   local pickers = require("telescope.pickers")
   local finders = require("telescope.finders")
   local actions = require("telescope.actions")
   local action_set = require("telescope.actions.set")
   local action_state = require("telescope.actions.state")

   local original, confirmed = state[option.field], false
   local function preview()
      local entry = action_state.get_selected_entry()
      if entry then
         set_choice(option, entry.value, false)
      end
   end

   pickers
      .new(require("telescope.themes").get_ivy({ layout_config = { height = #option.order + 4 } }), {
         prompt_title = "Dashboard " .. option.noun:lower(),
         previewer = false,
         default_selection_index = vim.fn.index(option.order, original) + 1,
         finder = finders.new_table({
            results = option.order,
            entry_maker = function(name)
               local item = option.items[name]
               return {
                  value = name,
                  ordinal = name .. " " .. item.label .. " " .. item.about,
                  display = ("%-14s %s"):format(item.label, item.about),
               }
            end,
         }),
         sorter = require("telescope.config").values.generic_sorter({}),
         attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
               local entry = action_state.get_selected_entry()
               confirmed = true
               actions.close(prompt_bufnr)
               set_choice(option, entry and entry.value or original)
            end)
            -- preview on movement, and when typing changes the top match
            action_set.shift_selection:enhance({ post = preview })
            api.nvim_create_autocmd("TextChangedI", {
               buffer = prompt_bufnr,
               callback = function()
                  vim.defer_fn(preview, 60)
               end,
            })
            api.nvim_create_autocmd("BufWipeout", {
               buffer = prompt_bufnr,
               once = true,
               callback = function()
                  if not confirmed then
                     set_choice(option, original, false)
                  end
               end,
            })
            return true
         end,
      })
      :find()
end

-- :Dashboard [background or logo] -- e.g. `:Dashboard aurora`, `:Dashboard neon`
api.nvim_create_user_command("Dashboard", function(command)
   open(command.args ~= "" and command.args or nil)
end, {
   nargs = "?",
   desc = "Open the animated dashboard, optionally picking a background or logo",
   complete = function(lead)
      return vim.tbl_filter(function(name)
         return name:find(lead, 1, true) == 1
      end, vim.list_extend(vim.deepcopy(BG_ORDER), FG_ORDER))
   end,
})

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

return {
   open = open,
   pick_background = function()
      pick_option("background")
   end,
   pick_logo = function()
      pick_option("logo")
   end,
}

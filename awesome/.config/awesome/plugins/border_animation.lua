-- plugins/border_animation.lua
-- Border animation system for focused client borders
-- Exposes:
--   border_animation.start()
--   border_animation.stop()
--   border_animation.pause()
--   border_animation.resume()
--   border_animation.set_params(tbl)
-- Emits signals:
--   awesome.emit_signal("border_animation::tick", index, len, color)

local gears = require("gears")

local M = {}

-- Palette and animation state
local palette = {}
local len = 1500
local borderLoop = 1.0  -- use float for smoother interpolation
local borderStep = 1.0
local paused = false

local timer = nil

-- Gradient generator function (krazydad-inspired)
local function makeColorGradient(frequency1, frequency2, frequency3, phase1, phase2, phase3, center, width, length)
  center = center or 128
  width = width or 127
  length = length or len
  palette = {}
  for i = 0, length - 1 do
    local r = string.format("%02x", math.floor(math.sin(frequency1 * i + phase1) * width + center))
    local g = string.format("%02x", math.floor(math.sin(frequency2 * i + phase2) * width + center))
    local b = string.format("%02x", math.floor(math.sin(frequency3 * i + phase3) * width + center))
    palette[i] = "#" .. r .. g .. b
  end
  len = length
end

-- Default parameters (matches current aesthetic)
local params = {
  redFrequency = 0.1,
  grnFrequency = 0.2,
  bluFrequency = 0.1,
  phase1 = 1,
  phase2 = 260,
  phase3 = 50,
  center = 180,
  width = 75,
  length = 1500,
  speed = 0.06,  -- faster updates for smoother animation
  step_size = 0.5,  -- smaller steps for smoother transitions
}

local function rebuild_palette()
  makeColorGradient(
    params.redFrequency,
    params.grnFrequency,
    params.bluFrequency,
    params.phase1,
    params.phase2,
    params.phase3,
    params.center,
    params.width,
    params.length
  )
  borderLoop = 0.0
  borderStep = params.step_size or 0.5
end

local function ensure_timer()
  if timer then return end
  timer = gears.timer {
    timeout = params.speed,
    autostart = false,
    callback = function()
      if paused then return end
      local c = client.focus
      if not c then
        timer:stop()
        return
      end
      if c._dnd_dragging then return end

      -- Step the loop (0..len-1) with fractional precision
      borderLoop = borderLoop + borderStep
      if borderLoop >= (len - 1) then
        borderLoop = len - 1
        borderStep = -(params.step_size or 0.5)
      elseif borderLoop <= 0 then
        borderLoop = 0
        borderStep = (params.step_size or 0.5)
      end

      -- interpolate between colors for smoother transitions
      local index = math.floor(borderLoop)
      local fraction = borderLoop - index
      local next_index = (index + 1) % len
      
      local color1 = palette[index] or "#00000000"
      local color2 = palette[next_index] or "#00000000"
      
      -- simple linear interpolation between colors
      local color = color1
      if fraction > 0 and color1 ~= color2 then
        -- extract rgb values and interpolate
        local r1, g1, b1 = color1:match("#(%x%x)(%x%x)(%x%x)")
        local r2, g2, b2 = color2:match("#(%x%x)(%x%x)(%x%x)")
        if r1 and g1 and b1 and r2 and g2 and b2 then
          r1, g1, b1 = tonumber(r1, 16), tonumber(g1, 16), tonumber(b1, 16)
          r2, g2, b2 = tonumber(r2, 16), tonumber(g2, 16), tonumber(b2, 16)
          local r = math.floor(r1 + (r2 - r1) * fraction)
          local g = math.floor(g1 + (g2 - g1) * fraction)
          local b = math.floor(b1 + (b2 - b1) * fraction)
          color = string.format("#%02x%02x%02x", r, g, b)
        end
      end
      
      c.border_color = color
      awesome.emit_signal("border_animation::tick", borderLoop, len, color)
    end
  }
end

function M.start()
  ensure_timer()
  if not timer.started then timer:start() end
end

function M.stop()
  if timer then timer:stop() end
end

function M.pause()
  paused = true
end

function M.resume()
  paused = false
  M.start()
end

function M.set_params(tbl)
  if type(tbl) ~= "table" then return end
  for k, v in pairs(tbl) do params[k] = v end
  if timer then timer.timeout = params.speed or timer.timeout end
  rebuild_palette()
  awesome.emit_signal("border_animation::tick", borderLoop, len, palette[borderLoop])
end

function M.get_palette()
  return palette, len
end

function M.get_state()
  return {
    running = timer and timer.started or false,
    paused = paused,
    index = borderLoop,
    len = len,
  }
end

-- convenience function to adjust animation smoothness
function M.set_smoothness(level)
  local smoothness_levels = {
    [1] = {speed = 0.15, step_size = 1.0},    -- original (jittery)
    [2] = {speed = 0.08, step_size = 0.8},    -- slightly smoother
    [3] = {speed = 0.06, step_size = 0.5},    -- smooth (default)
    [4] = {speed = 0.04, step_size = 0.3},    -- very smooth
    [5] = {speed = 0.03, step_size = 0.2},    -- ultra smooth
  }
  
  local settings = smoothness_levels[level] or smoothness_levels[3]
  M.set_params(settings)
end

-- Hook focus/unfocus to draw initial color and clean up
client.connect_signal("focus", function(c)
  borderLoop = 0.0
  borderStep = params.step_size or 0.5
  local color = palette[borderLoop] or "#00000000"
  c.border_color = color
  awesome.emit_signal("border_animation::tick", borderLoop, len, color)
  if not paused then M.start() end
end)

client.connect_signal("unfocus", function(c)
  c.border_color = "#00000000"
end)

-- Listen for external pause/resume requests (e.g., DnD)
awesome.connect_signal("border_animation::pause", function() M.pause() end)
awesome.connect_signal("border_animation::resume", function() M.resume() end)

-- Build initial palette
rebuild_palette()

return M

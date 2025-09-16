-- plugins/shimmer/border.lua
-- Border animation system for window shimmer effects
--
-- BORDER ARCHITECTURE:
-- This module provides continuous shimmer animation for window borders:
-- • Independent animation loop with configurable timing
-- • Synchronized with main shimmer palette colors  
-- • Phase offset system for variety (default 3.0)
-- • Smoothness control for animation quality
-- • Start/stop/pause controls for performance
--
-- INTEGRATION:
-- • Uses shared color palette from animation module
-- • Responds to mode changes via on_mode_changed()
-- • Border colors cycle through current shimmer preset
-- • Phase offset creates timing variety vs text shimmer
--
-- PERFORMANCE:
-- • Independent timer (0.06s default) for smooth borders
-- • Can be paused/stopped when not needed
-- • Smoothness setting controls update frequency

local gears = require("gears")

local M = {}

-- // MARK: BORDER STATE VARIABLES

-- border animation state
local border_loop = 1.0
local border_step = 1.0
local border_paused = false
local border_timer = nil
local border_params = {
    speed = 0.06,         -- animation timer interval
    step_size = 0.5,      -- animation step increment
    phase_offset = 3.0    -- border gets its own phase offset for variety
}

-- // MARK: PALETTE INTEGRATION

-- get current palette from animation module (lazy loading)
local function get_current_palette()
    local animation = require("plugins.shimmer.animation")
    return animation.get_palette()
end

-- // MARK: ANIMATION CONTROL

-- start border animation timer
function M.start()
    if border_timer then return end
    
    border_timer = gears.timer {
        timeout = border_params.speed,
        autostart = true,
        callback = function()
            if border_paused then return end
            local c = client.focus
            if not c then
                border_timer:stop()
                return
            end
            if c._dnd_dragging then return end
            
            -- get current palette
            local palette = get_current_palette()
            if not palette then return end
            
            local len = #palette
            
            -- step the loop with fractional precision and phase offset
            border_loop = border_loop + border_step
            if border_loop >= (len - 1) then
                border_loop = len - 1
                border_step = -(border_params.step_size or 0.5)
            elseif border_loop <= 0 then
                border_loop = 0
                border_step = (border_params.step_size or 0.5)
            end
            
            -- apply phase offset to color selection (1-based indexing)
            local phase_adjusted_loop = border_loop + (border_params.phase_offset or 0)
            local base_index = math.floor(phase_adjusted_loop)
            local index = (base_index % len) + 1
            local fraction = phase_adjusted_loop - base_index
            local next_index = (index % len) + 1
            
            local color1 = palette[index] or "#00000000"
            local color2 = palette[next_index] or "#00000000"
            
            local color = color1
            if fraction > 0 and color1 ~= color2 then
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
            awesome.emit_signal("shimmer::border_tick", border_loop, len, color)
        end
    }
end

-- stop border animation and cleanup timer
function M.stop()
    if border_timer then 
        border_timer:stop()
        border_timer = nil
    end
end

-- pause/unpause border animation without stopping timer
function M.pause()
    border_paused = true
end

-- resume border animation from paused state
function M.resume()
    border_paused = false
    M.start()
end

-- set border animation smoothness (1-5, higher = smoother)
function M.set_smoothness(smoothness)
    local smoothness_levels = {
        [1] = {speed = 0.15, step_size = 1.0},    -- original (jittery)
        [2] = {speed = 0.08, step_size = 0.8},    -- slightly smoother
        [3] = {speed = 0.06, step_size = 0.5},    -- smooth (default)
        [4] = {speed = 0.04, step_size = 0.3},    -- very smooth
        [5] = {speed = 0.03, step_size = 0.2},    -- ultra smooth
    }
    
    local settings = smoothness_levels[smoothness] or smoothness_levels[3]
    for k, v in pairs(settings) do 
        if k ~= "phase_offset" then  -- preserve phase_offset
            border_params[k] = v 
        end
    end
    if border_timer then border_timer.timeout = border_params.speed end
end

-- // MARK: CONFIGURATION

-- set border phase offset for timing variety
function M.set_phase_offset(offset)
    border_params.phase_offset = offset or 3.0
end

-- get current border phase offset
function M.get_phase_offset()
    return border_params.phase_offset
end

function M.get_state()
    return {
        running = border_timer and border_timer.started or false,
        paused = border_paused,
        index = border_loop
    }
end

-- set up client signals
client.connect_signal("focus", function(c)
    border_loop = 0.0
    border_step = border_params.step_size or 0.5
    local palette = get_current_palette()
    if palette and palette[1] then
        c.border_color = palette[1]
        awesome.emit_signal("shimmer::border_tick", border_loop, #palette, palette[1])
    end
    if not border_paused then M.start() end
end)

client.connect_signal("unfocus", function(c)
    c.border_color = "#00000000"
end)

-- listen for external pause/resume requests (e.g., DnD)
awesome.connect_signal("shimmer::border_pause", function() M.pause() end)
awesome.connect_signal("shimmer::border_resume", function() M.resume() end)

-- respond to shimmer mode changes
function M.on_mode_changed(mode)
    if border_timer then
        M.stop()
        M.start()
    end
end

return M

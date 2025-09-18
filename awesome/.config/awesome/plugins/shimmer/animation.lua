-- plugins/shimmer/animation.lua
-- Core animation and color generation for shimmer system
--
-- ARCHITECTURE:
-- This module handles the core shimmer animation logic including:
-- • Color palette generation using sine wave gradients
-- • Per-character and solid color shimmer modes
-- • Preset management with cycling support
-- • Global per-character toggle independent of presets
-- • Color interpolation for smooth transitions
-- • Animation timing and widget application
--
-- PRESET SYSTEM:
-- Each preset defines speed, gradient parameters, and per_character_default
-- Presets with per_character_default=true: candle, cloud, char_flicker, debug
-- 
-- PER-CHARACTER LOGIC:
-- - Global toggle (per_character_enabled) overrides preset defaults
-- - When switching presets, per_character_default applies if not manually set
-- - Each character gets phase offset based on position (i * 3.0 for wave mode)
-- - should_use_per_character() determines final per-character state

local gears = require("gears")
local awful = require("awful")

local M = {}

-- // MARK: CORE STATE VARIABLES

-- base gold color palette
local base_gold = "#FFD700"

-- current animation mode
local shimmer_mode = "gold_contrast"

-- per-character shimmer global toggle (independent of presets)
local per_character_enabled = false

-- per-character phase modes
local per_character_modes = {
    uniform = "uniform",           -- same phase for all characters (original behavior)
    wave = "wave",                 -- sequential phase progression for wave effect
    drift = "drift",               -- slow random drift with momentum
    scatter = "scatter",           -- moderate randomness with some coherence
    chaos = "chaos",               -- high randomness, granular-like sampling
    random = "random",             -- full random phase for each character
    spiral = "spiral",             -- spiral pattern through color space
    pulse = "pulse",               -- pulsing waves through text
    alternating = "alternating",   -- every other character opposite phase
    fibonacci = "fibonacci",       -- fibonacci sequence spacing
    sine_wave = "sine_wave",       -- sine wave pattern through text
    reverse_wave = "reverse_wave", -- wave but backwards
    center_out = "center_out",     -- radiates from center outward
    edges_in = "edges_in",         -- starts from edges, moves inward
    rainbow = "rainbow",           -- evenly spaced across full spectrum
    heartbeat = "heartbeat"        -- irregular pulsing pattern
}
local current_per_character_mode = per_character_modes.wave

-- progression mode cycling order - grouped by pattern type and complexity
local progression_modes_list = {
    -- basic patterns
    "uniform", "alternating", 
    -- wave patterns
    "wave", "reverse_wave", "sine_wave", "pulse",
    -- geometric patterns  
    "center_out", "edges_in", "spiral", "fibonacci",
    -- random patterns (mild to wild)
    "drift", "scatter", "chaos", "random",
    -- special effects
    "rainbow", "heartbeat"
}
local current_progression_index = 3  -- start with wave

-- preset cycling state - grouped by color family and complexity
local preset_list = {
    -- gold family (classic shimmer)
    "gold_contrast", "bright_gold", "honey_glow", "deep_gold",
    -- warm metallics
    "amber_pulse", "warm_amber", "copper",
    -- soft/light tones
    "warm_light", "sepia_soft", "cloud",
    -- colorful effects (mild to wild)
    "candy", "candy_pastel", "plasma_drift", "electric_buzz",
    -- special effects
    "aurora_scatter", "digital_chaos", "border_sync",
    -- utility
    "debug", "off"
}
local current_preset_index = 1  -- start with gold_contrast

-- color palette cache and generation
local color_palettes = {}
local palette_length = 200  -- increased for longer animation cycles

-- animation state
local shimmer_step = 0
local shimmer_timer = nil
local animation_direction = 1  -- 1 for forward, -1 for reverse

-- global speed multiplier (applied to all presets)
local global_speed_multiplier = 1.2

-- speed multiplier control functions
function M.set_speed_multiplier(multiplier)
    global_speed_multiplier = multiplier or 1.0
end

function M.get_speed_multiplier()
    return global_speed_multiplier
end

-- debug function to check timer status
function M.get_debug_status()
    return {
        mode = shimmer_mode,
        step = shimmer_step,
        timer_running = shimmer_timer and shimmer_timer.started or false,
        palette_cached = color_palettes[shimmer_mode] and true or false,
        palette_length = color_palettes[shimmer_mode] and #color_palettes[shimmer_mode] or 0
    }
end

-- // MARK: COLOR PALETTE GENERATION

-- sine wave gradient generator: creates smooth RGB transitions via frequency modulation
-- each color channel oscillates independently, center/width control brightness range
-- generates single color when phase_offset provided, otherwise generates palette
local function makeColorGradient(frequency1, frequency2, frequency3, phase1, phase2, phase3, center, width, length, brightness_opts, animation_phase, phase_offset)
    center = center or 180  -- lower center for wider range
    width = width or 75     -- increased width for more contrast
    length = length or palette_length
    
    -- if generating single color with phase offset (real-time generation)
    if animation_phase ~= nil and phase_offset ~= nil then
        local total_phase = animation_phase + (phase_offset or 0) * 0.8  -- linear relationship
        
        -- calculate brightness modulation based on phase offset for linear relationship
        local brightness_factor = 1.0 + math.sin(phase_offset * 0.6) * 0.3  -- ±30% brightness variation
        local dynamic_center = center * brightness_factor
        local dynamic_width = width * brightness_factor
        
        local r = math.floor(math.sin(frequency1 * total_phase * 0.5 + phase1) * dynamic_width + dynamic_center)
        local g = math.floor(math.sin(frequency2 * total_phase * 0.5 + phase2) * dynamic_width + dynamic_center)
        local b = math.floor(math.sin(frequency3 * total_phase * 0.5 + phase3) * dynamic_width + dynamic_center)
        
        -- clamp values to valid range
        r = math.max(0, math.min(255, r))
        g = math.max(0, math.min(255, g))
        b = math.max(0, math.min(255, b))
        
        return string.format("#%02x%02x%02x", r, g, b)
    end
    
    -- otherwise generate palette (fallback for compatibility)
    local palette = {}
    local expanded_length = length * 2
    for i = 0, expanded_length - 1 do
        local r = math.floor(math.sin(frequency1 * i * 0.5 + phase1) * width + center)
        local g = math.floor(math.sin(frequency2 * i * 0.5 + phase2) * width + center)
        local b = math.floor(math.sin(frequency3 * i * 0.5 + phase3) * width + center)
        -- clamp values to valid range
        r = math.max(0, math.min(255, r))
        g = math.max(0, math.min(255, g))
        b = math.max(0, math.min(255, b))
        -- only store every other color to maintain original palette size but with smoother transitions
        if i % 2 == 0 and (i / 2) < length then
            palette[(i / 2) + 1] = string.format("#%02x%02x%02x", r, g, b)
        end
    end
    return palette
end

-- HSV gold shine generator: natural gold tones via hue/saturation/value modulation
-- shine_frequency controls shimmer speed, hue_variation adds color depth
-- value_min/max clamp brightness to avoid unreadable extremes~50° (gold), vary value for shine and slightly vary saturation
local function hsv_to_rgb(h, s, v)
    -- h in [0,360), s,v in [0,1]
    local c = v * s
    local x = c * (1 - math.abs(((h / 60) % 2) - 1))
    local m = v - c
    local r1, g1, b1 = 0, 0, 0
    if h < 60 then r1, g1, b1 = c, x, 0
    elseif h < 120 then r1, g1, b1 = x, c, 0
    elseif h < 180 then r1, g1, b1 = 0, c, x
    elseif h < 240 then r1, g1, b1 = 0, x, c
    elseif h < 300 then r1, g1, b1 = x, 0, c
    else r1, g1, b1 = c, 0, x end
    local r = math.floor((r1 + m) * 255)
    local g = math.floor((g1 + m) * 255)
    local b = math.floor((b1 + m) * 255)
    r = math.max(0, math.min(255, r))
    g = math.max(0, math.min(255, g))
    b = math.max(0, math.min(255, b))
    return string.format("#%02x%02x%02x", r, g, b)
end

local function makeGoldShinePalette(length, opts, animation_phase, phase_offset)
    length = length or palette_length
    opts = opts or {}
    local hue_base = opts.hue_base or 50       -- ~gold hue
    local hue_var = opts.hue_variation or 8    -- slightly more hue wobble for visibility
    local sat_base = opts.sat_base or 0.95
    local sat_var = opts.sat_variation or 0.15  -- more saturation variation
    local val_min = opts.value_min or 0.55      -- lower floor for more contrast
    local val_max = opts.value_max or 0.98      -- higher ceiling for more contrast
    local shine_freq = opts.shine_frequency or 2.0  -- more cycles for visible shimmer
    local hue_freq = opts.hue_frequency or 0.5
    local sat_freq = opts.sat_frequency or 0.77
    
    -- if generating single color with phase offset (real-time generation)
    if animation_phase ~= nil and phase_offset ~= nil then
        local total_phase = animation_phase + (phase_offset or 0) * 0.8  -- linear relationship
        local t = total_phase / 100  -- normalize for sine calculations
        
        local hue = hue_base + hue_var * math.sin(2 * math.pi * t * hue_freq)
        local sat = sat_base - sat_var * math.sin(2 * math.pi * t * sat_freq)
        local shine = 0.5 + 0.5 * math.sin(2 * math.pi * t * shine_freq)
        
        -- apply brightness modulation based on phase offset for linear relationship
        local brightness_factor = 1.0 + math.sin(phase_offset * 0.6) * 0.25  -- ±25% brightness variation
        local base_val = val_min + (val_max - val_min) * shine
        local val = base_val * brightness_factor
        
        return hsv_to_rgb((hue % 360 + 360) % 360, math.max(0, math.min(1, sat)), math.max(0, math.min(1, val)))
    end
    
    -- otherwise generate palette (fallback for compatibility)
    local palette = {}
    for i = 1, length do
        local t = (i - 1) / length
        local hue = hue_base + hue_var * math.sin(2 * math.pi * t * hue_freq)
        local sat = sat_base - sat_var * math.sin(2 * math.pi * t * sat_freq)
        local shine = 0.5 + 0.5 * math.sin(2 * math.pi * t * shine_freq)
        local val = val_min + (val_max - val_min) * shine
        
        palette[i] = hsv_to_rgb((hue % 360 + 360) % 360, math.max(0, math.min(1, sat)), math.max(0, math.min(1, val)))
    end
    return palette
end

-- // MARK: PRESET CONFIGURATIONS
-- enhanced shimmer configuration with color cycling
-- each preset defines: speed, per_character_default, gradient parameters
local shimmer_config = {
    -- high-contrast gold with tight value range, good default
    gold_contrast = {
        speed = 0.35,
        per_character_default = false,
        use_gold_shine = true,
        gold_shine_opts = {
            hue_base = 50,
            hue_variation = 6,
            sat_base = 1.0,
            sat_variation = 0.10,
            value_min = 0.72,
            value_max = 0.94,
            shine_frequency = 2.4
        }
    },

    -- vivid golden shimmer with shine - more intense and eye-catching
    -- creates bright gold with shine effects, good for highlighting
    bright_gold = {
        speed = 0.32,
        per_character_default = false,
        use_gold_shine = true,
        gold_shine_opts = {
            hue_base = 48,
            hue_variation = 4,
            sat_base = 1.0,
            sat_variation = 0.08,
            value_min = 0.75,
            value_max = 0.96,
            shine_frequency = 1.8
        },
        -- gradient kept for potential future switch; ignored when use_gold_shine=true
        gradient = {
            redFrequency = 0.06,
            grnFrequency = 0.055,
            bluFrequency = 0.008,
            phase1 = 0,
            phase2 = 0.4,
            phase3 = 2.8,
            center = 210,
            width = 40
        }
    },

    -- warm amber gradient - rich, vibrant amber with deeper saturation
    warm_amber = {
        speed = 0.28,
        per_character_default = false,
        gradient = {
            redFrequency = 0.055,
            grnFrequency = 0.028,
            bluFrequency = 0.0003,
            phase1 = 0.2,
            phase2 = 0.8,
            phase3 = 6.0,
            center = 200,
            width = 45
        }
    },

    -- warm flickering candlelight - organic, cozy flame colors
    -- slow animation with authentic candle orange-red tones
    candy = {
        speed = 0.25,
        per_character_default = true,
        gradient = {
            redFrequency = 0.075,
            grnFrequency = 0.065,
            bluFrequency = 0.008,
            phase1 = 0.2,
            phase2 = 1.8,
            phase3 = 5.2,
            center = 205,
            width = 38
        }
    },

    -- candy_pastel variant - less contrast, brighter
    candy_pastel = {
        speed = 0.25,
        per_character_default = true,
        gradient = {
            redFrequency = 0.05,
            grnFrequency = 0.07,
            bluFrequency = 0.015,
            phase1 = 0.8,
            phase2 = 2.2,
            phase3 = 4.2,
            center = 205,
            width = 35
        }
    },

    -- honey glow - softer gold shine
    honey_glow = {
        speed = 0.30,
        per_character_default = false,
        use_gold_shine = true,
        gold_shine_opts = {
            hue_base = 46,
            hue_variation = 5,
            sat_base = 0.95,
            sat_variation = 0.12,
            value_min = 0.70,
            value_max = 0.93,
            shine_frequency = 1.8
        }
    },

    -- copper shine - warmer, reddish gold family (brighter bronze)
    copper = {
        speed = 0.40,
        per_character_default = false,
        use_gold_shine = true,
        gold_shine_opts = {
            hue_base = 25,
            hue_variation = 8,
            sat_base = 0.92,
            sat_variation = 0.08,
            value_min = 0.78,
            value_max = 0.96,
            shine_frequency = 2.0
        }
    },


    -- soft ethereal cloud shimmer - warm white with blue accents
    -- warmer cloud tones with enhanced blue for sky-like appearance
    cloud = {
        speed = 0.30,
        per_character_default = true,
        gradient = {
            redFrequency = 0.025,
            grnFrequency = 0.028,
            bluFrequency = 0.055,
            phase1 = 2.1,
            phase2 = 2.8,
            phase3 = 0.5,
            center = 215,
            width = 32
        }
    },

    -- amber pulse - slow pulse-like shine
    amber_pulse = {
        speed = 0.28,
        per_character_default = true,
        per_character_mode_default = "drift",
        use_gold_shine = true,
        gold_shine_opts = {
            hue_base = 48,
            hue_variation = 4,
            sat_base = 0.98,
            sat_variation = 0.06,
            value_min = 0.68,
            value_max = 0.96,
            shine_frequency = 1.2
        }
    },

    -- rapid electric buzz - high-energy, attention-grabbing with more saturation
    -- fast animation speed with high frequency changes, best for short bursts
    electric_buzz = {
        speed = 0.15,
        per_character_default = true,
        gradient = {
            redFrequency = 0.12,
            grnFrequency = 0.15,
            bluFrequency = 0.08,
            phase1 = 0,
            phase2 = 2,
            phase3 = 4,
            center = 180,
            width = 75
        }
    },

    -- static amber - stable highlight without animation
    static_amber = {
        speed = 0,
        per_character_default = false,
        static_color = "#FFC107"
    },

    -- border sync mode - coordinates with window border animation
    -- designed to complement border colors, wider color range for variety
    border_sync = {
        speed = 0.4,
        per_character_default = false,
        gradient = {
            redFrequency = 0.1,
            grnFrequency = 0.2,
            bluFrequency = 0.1,
            phase1 = 1,
            phase2 = 260,
            phase3 = 50,
            center = 175,
            width = 60
        }
    },

    -- sepia soft - rich sepia tones with warm brown undertones
    sepia_soft = {
        speed = 0.32,
        per_character_default = false,
        gradient = {
            redFrequency = 0.028,
            grnFrequency = 0.022,
            bluFrequency = 0.008,
            phase1 = 0.2,
            phase2 = 0.4,
            phase3 = 2.8,
            center = 170,
            width = 35
        }
    },

    -- golden hour warm light - hotter white light with bright intensity
    -- produces bright white shimmer with warm undertones
    warm_light = {
        speed = 0.25,
        per_character_default = false,
        gradient = {
            redFrequency = 0.038,
            grnFrequency = 0.040,
            bluFrequency = 0.035,
            phase1 = 0.1,
            phase2 = 0.6,
            phase3 = 1.8,
            center = 235,
            width = 25
        }
    },

    -- rich deep gold - sophisticated luxury with vibrant golden intensity
    -- slower, more refined animation with richer golden tones
    deep_gold = {
        speed = 0.6,
        per_character_default = false,
        gradient = {
            redFrequency = 0.05,
            grnFrequency = 0.042,
            bluFrequency = 0.0008,
            phase1 = 0.1,
            phase2 = 0.4,
            phase3 = 4.8,
            center = 195,
            width = 40
        }
    },

    -- debug rainbow - obvious color cycling for testing/development
    -- cycles through red->green->blue->yellow->magenta->cyan for easy visibility
    debug = {
        speed = 0.2,
        per_character_default = true,  -- debug mode shows per-character clearly
        gradient = {
            redFrequency = 0.3,
            grnFrequency = 0.2,
            bluFrequency = 0.4,
            phase1 = 0,
            phase2 = 2.1,
            phase3 = 4.2,
            center = 127,
            width = 127
        }
    },

    -- plasma drift - granular drift mode
    plasma_drift = {
        speed = 0.22,
        per_character_default = true,
        per_character_mode_default = "drift",
        gradient = {
            redFrequency = 0.08,
            grnFrequency = 0.12,
            bluFrequency = 0.15,
            phase1 = 1.2,
            phase2 = 3.8,
            phase3 = 0.5,
            center = 180,
            width = 50
        }
    },

    -- aurora scatter - granular scatter mode
    aurora_scatter = {
        speed = 0.18,
        per_character_default = true,
        per_character_mode_default = "scatter",
        use_gold_shine = true,
        gold_shine_opts = {
            hue_base = 180,
            hue_variation = 60,
            sat_base = 0.85,
            sat_variation = 0.25,
            value_min = 0.65,
            value_max = 0.92,
            shine_frequency = 1.5
        }
    },

    -- digital chaos - granular chaos mode
    digital_chaos = {
        speed = 0.12,
        per_character_default = true,
        per_character_mode_default = "chaos",
        gradient = {
            redFrequency = 0.25,
            grnFrequency = 0.18,
            bluFrequency = 0.32,
            phase1 = 0,
            phase2 = 1.5,
            phase3 = 3.0,
            center = 160,
            width = 80
        }
    },

    -- no animation - static gold color
    -- fallback mode, good for performance or when animation is unwanted
    off = {
        speed = 0,
        per_character_default = false,
        static_color = base_gold
    }
}

-- // MARK: PALETTE MANAGEMENT

-- palette cache manager: lazy-loads color arrays per preset to avoid startup blocking
-- each mode gets 100-color palette generated on first use, cached thereafter
local function ensure_palette(mode_name)
    local config = shimmer_config[mode_name]
    if not config then return nil end
    
    -- return cached palette if available
    if color_palettes[mode_name] then
        return color_palettes[mode_name]
    end
    
    -- for startup performance, defer expensive palette generation
    -- use simple fallback during initialization
    if not shimmer_timer or not shimmer_timer.started then
        -- startup fallback: simple static color to prevent blocking
        local simple_palette = { config.static_color or base_gold }
        return simple_palette
    end
    
    -- generate full palette only after timer is running
    if config.use_gold_shine then
        color_palettes[mode_name] = makeGoldShinePalette(palette_length, config.gold_shine_opts)
    elseif config.gradient then
        local g = config.gradient
        color_palettes[mode_name] = makeColorGradient(
            g.redFrequency, g.grnFrequency, g.bluFrequency,
            g.phase1, g.phase2, g.phase3,
            g.center, g.width, palette_length -- removed g.brightness
        )
    else
        -- fallback for modes without gradient
        color_palettes[mode_name] = { config.static_color or base_gold }
    end
    
    return color_palettes[mode_name]
end

-- // MARK: CLIENT STATUS HELPERS

-- get client status prefix symbols for window titles
local function get_client_status_prefix(c)
    if not c or not c.valid then return "" end
    
    local symbols = {}
    if c.floating then table.insert(symbols, "✈") end
    if c.maximized then table.insert(symbols, "+")
    elseif c.maximized_horizontal then table.insert(symbols, "⬌")
    elseif c.maximized_vertical then table.insert(symbols, "⬍") end
    if c.sticky then table.insert(symbols, "▪") end
    if c.ontop then table.insert(symbols, "⌃")
    elseif c.above then table.insert(symbols, "▴")
    elseif c.below then table.insert(symbols, "▾") end
    
    return (#symbols > 0) and table.concat(symbols, "") .. " " or ""
end

-- timer callback for shimmer animation
local function shimmer_tick()
    shimmer_step = shimmer_step + 1
    -- direct call to integrations update instead of signal
    local integrations = require("plugins.shimmer.integrations")
    integrations.update_widgets()
end

-- // MARK: PER-CHARACTER SHIMMER

-- per-letter shimmer function - applies different colors to each character
function M.get_letter_shimmer_markup(text, base_phase_offset, options)
    if not text or text == "" then return "" end
    
    options = options or {}
    local mode = options.per_character_mode or current_per_character_mode
    
    -- print("[SHIMMER DEBUG] get_letter_shimmer_markup called with text:", text, "mode:", mode)
    
    -- validate UTF-8 and escape XML before processing
    local escaped_text = gears.string.xml_escape(text)
    
    -- check for invalid UTF-8 sequences and replace with safe fallback
    local safe_text = escaped_text:gsub("[\128-\255]+", function(match)
        -- replace problematic UTF-8 sequences with safe ASCII
        return "*"
    end)
    
    local chars = {}
    
    -- split into individual characters (handle utf-8 safely)
    for i = 1, safe_text:len() do
        local char = safe_text:sub(i, i)
        if char ~= "" then
            table.insert(chars, char)
        end
    end
    
    -- generate random seed based on text for consistent random phases
    local text_seed = 0
    for i = 1, #text do
        text_seed = text_seed + string.byte(text, i)
    end
    
    local colored_chars = {}
    for i, char in ipairs(chars) do
        if char:match("%s") then
            -- preserve whitespace
            table.insert(colored_chars, char)
        else
            local letter_phase = base_phase_offset or 0
            
            if mode == per_character_modes.wave then
                -- wave effect: each character progressively offset with expanded spacing
                letter_phase = letter_phase + (i * 0.4)
            elseif mode == per_character_modes.random then
                -- random phase for each character (but consistent per text)
                math.randomseed(text_seed + i)
                letter_phase = letter_phase + (math.random() * 15.0)
            elseif mode == per_character_modes.uniform then
                -- all characters same phase (original behavior)
                letter_phase = letter_phase
            elseif mode == per_character_modes.drift then
                -- slow random drift with momentum
                math.randomseed(text_seed + i)
                letter_phase = letter_phase + (math.random() * 0.8)
            elseif mode == per_character_modes.scatter then
                -- moderate randomness with some coherence
                math.randomseed(text_seed + i)
                letter_phase = letter_phase + (math.random() * 2.5)
            elseif mode == per_character_modes.chaos then
                -- high randomness, granular-like sampling (boosted for more chaos)
                math.randomseed(text_seed + i)
                letter_phase = letter_phase + (math.random() * 10.0)
            elseif mode == per_character_modes.spiral then
                -- spiral pattern through color space
                local angle = (i - 1) * 0.8  -- spiral angle
                letter_phase = letter_phase + angle + math.sin(angle * 0.3) * 2.0
            elseif mode == per_character_modes.pulse then
                -- pulsing waves through text
                local pulse_freq = 0.5
                letter_phase = letter_phase + math.sin((i - 1) * pulse_freq) * 3.0
            elseif mode == per_character_modes.alternating then
                -- every other character opposite phase
                letter_phase = letter_phase + ((i % 2 == 0) and 6.0 or 0)
            elseif mode == per_character_modes.fibonacci then
                -- fibonacci sequence spacing
                local function fib(n)
                    if n <= 1 then return n end
                    local a, b = 0, 1
                    for j = 2, n do a, b = b, a + b end
                    return b
                end
                letter_phase = letter_phase + (fib(i % 12) * 0.2)  -- cycle through fib numbers
            elseif mode == per_character_modes.sine_wave then
                -- sine wave pattern through text
                letter_phase = letter_phase + math.sin((i - 1) * 0.6) * 4.0
            elseif mode == per_character_modes.reverse_wave then
                -- wave but backwards
                letter_phase = letter_phase + ((#chars - i + 1) * 0.4)
            elseif mode == per_character_modes.center_out then
                -- radiates from center outward
                local center = (#chars + 1) / 2
                local distance = math.abs(i - center)
                letter_phase = letter_phase + distance * 0.8
            elseif mode == per_character_modes.edges_in then
                -- starts from edges, moves inward
                local center = (#chars + 1) / 2
                local distance_from_edge = math.min(i - 1, #chars - i)
                letter_phase = letter_phase + distance_from_edge * 0.6
            elseif mode == per_character_modes.rainbow then
                -- evenly spaced across full spectrum
                letter_phase = letter_phase + ((i - 1) / math.max(1, #chars - 1)) * 20.0
            elseif mode == per_character_modes.heartbeat then
                -- irregular pulsing pattern (double pulse like heartbeat)
                local beat_pos = (i - 1) % 8  -- 8-character heartbeat cycle
                local heartbeat_pattern = {0, 3, 0.5, 0, 0, 2, 0.3, 0}
                letter_phase = letter_phase + heartbeat_pattern[beat_pos + 1]
            end
            
            local color = M.get_color(nil, 1, letter_phase)
            -- print("[SHIMMER DEBUG] char", i, "'", char, "' phase:", letter_phase, "color:", color)
            table.insert(colored_chars, '<span foreground="' .. color .. '">' .. char .. '</span>')
        end
    end
    
    local result = table.concat(colored_chars)
    -- print("[SHIMMER DEBUG] final markup length:", #result)
    return result
end

-- // MARK: CORE API FUNCTIONS

-- main animation control functions
function M.set_mode(mode)
    if shimmer_config[mode] then
        shimmer_mode = mode
        -- defer palette generation to prevent startup blocking
        -- ensure_palette(mode) -- commented out for lazy loading
        
        -- update per-character state based on preset default (if not manually overridden)
        local config = shimmer_config[mode]
        if config.per_character_default ~= nil then
            per_character_enabled = config.per_character_default
        end
        
        -- update per-character mode based on preset default (if not manually overridden)
        if config.per_character_mode_default then
            current_per_character_mode = config.per_character_mode_default
        end
        
        -- defer border notification to prevent cascading calls
        gears.timer.start_new(0.1, function()
            local border = require("plugins.shimmer.border")
            border.on_mode_changed(mode)
            return false
        end)
    end
end

function M.get_mode()
    return shimmer_mode
end

-- core color calculation with real-time generation for linear brightness/color relationship
function M.get_color(mode_config, text_length, phase_offset)
    local mode_name = mode_config or shimmer_mode or "warm_light"
    local config = shimmer_config[mode_name]
    
    if not config then
        return base_gold
    end
    
    -- handle static colors
    if config.speed == 0 or config.static_color then
        return config.static_color or base_gold
    end
    
    -- calculate animation phase
    local effective_speed = config.speed * global_speed_multiplier * 0.5
    local base_time = shimmer_step * effective_speed * animation_direction
    local length_factor = (text_length or 1) * 0.1
    local animation_phase = base_time + length_factor
    
    -- use real-time generation if phase_offset provided (per-character mode)
    if phase_offset and phase_offset ~= 0 then
        if config.use_gold_shine then
            return makeGoldShinePalette(palette_length, config.gold_shine_opts, animation_phase, phase_offset)
        elseif config.gradient then
            local g = config.gradient
            return makeColorGradient(
                g.redFrequency, g.grnFrequency, g.bluFrequency,
                g.phase1, g.phase2, g.phase3,
                g.center, g.width, palette_length, nil, animation_phase, phase_offset
            )
        end
    end
    
    -- fallback to palette lookup for uniform mode
    local palette = ensure_palette(mode_name)
    if not palette or #palette == 0 then
        return base_gold
    end
    
    if #palette < 2 then
        return palette[1] or base_gold
    end
    
    local cycle_length = #palette * 2 - 2
    local raw_index = math.floor(math.abs(animation_phase) * 8) % cycle_length
    local palette_index
    
    if raw_index < #palette then
        palette_index = raw_index
    else
        palette_index = cycle_length - raw_index
    end
    
    return palette[palette_index + 1] or base_gold
end

function M.start()
    if shimmer_timer then return end
    
    -- create timer with reduced frequency to prevent glib_poll blocking
    shimmer_timer = gears.timer {
        timeout = 0.1,  -- reduced from 0.05s to prevent blocking
        autostart = false,  -- don't start immediately during config load
        callback = shimmer_tick
    }
    
    -- defer startup to avoid blocking main loop during initialization
    gears.timer.start_new(0.5, function()
        if shimmer_timer then
            shimmer_timer:start()
        end
        return false
    end)
end

function M.stop()
    if shimmer_timer then
        shimmer_timer:stop()
        shimmer_timer = nil
    end
end

function M.restart()
    M.stop()
    shimmer_step = 0
    M.start()
end

function M.get_base_gold()
    return base_gold
end

function M.get_status_prefix(client)
    return get_client_status_prefix(client)
end

function M.apply_to_widget(widget, text, status_symbols, options)
    if not widget or not widget.set_markup then return end
    if widget.__hover_lock or widget.__hover_fade_lock then return end
    
    local display_text = (status_symbols or "") .. (text or "")
    if display_text == "" then return end
    
    options = options or {}
    local phase_offset = options.phase_offset or 0
    
    -- use enhanced per-character logic
    local use_per_character = M.should_use_per_character(options)
    
    -- print("[SHIMMER DEBUG] apply_to_widget - text:", display_text, "use_per_character:", use_per_character)
    
    if use_per_character then
        local markup = M.get_letter_shimmer_markup(display_text, phase_offset, options)
        -- print("[SHIMMER DEBUG] per-character markup:", markup:sub(1, 100) .. "...")
        widget:set_markup(markup)
    else
        -- when per-character is off, optionally allow phase_offset for targeted variance
        -- default: keep widgets synchronized (phase 0) unless explicitly overridden
        local solid_phase = (options and options.use_phase_when_solid) and (options.phase_offset or 0) or 0
        local shimmer_color = M.get_color(nil, #display_text, solid_phase)
        local markup = '<span foreground="' .. shimmer_color .. '">' .. 
                       gears.string.xml_escape(display_text) .. '</span>'
        -- print("[SHIMMER DEBUG] solid color markup:", markup)
        widget:set_markup(markup)
    end
end

function M.get_palette(mode_name)
    local mode = mode_name or shimmer_mode
    return ensure_palette(mode)
end

function M.get_gradient_params(mode_name)
    local mode = mode_name or shimmer_mode
    local config = shimmer_config[mode]
    return config and config.gradient
end

function M.set_gradient_params(mode_name, params)
    if not shimmer_config[mode_name] then return false end
    
    shimmer_config[mode_name].gradient = params
    color_palettes[mode_name] = nil
    
    return true
end

function M.clear_palette_cache(mode_name)
    if mode_name then
        color_palettes[mode_name] = nil
    else
        color_palettes = {}
    end
end

function M.add_preset(preset_config)
    local name = preset_config.name or "custom"
    local preset = {
        speed = preset_config.speed or 0.3,
        gradient = preset_config.gradient or {
            redFrequency = 0.05,
            grnFrequency = 0.08,
            bluFrequency = 0.02,
            phase1 = 0, phase2 = 2, phase3 = 4,
            center = 200, width = 50
        }
    }
    shimmer_config[name] = preset
    
    -- add to preset list if not already there
    local found = false
    for _, preset_name in ipairs(preset_list) do
        if preset_name == name then
            found = true
            break
        end
    end
    if not found then
        table.insert(preset_list, name)
    end
end

function M.get_preset_list()
    return preset_list
end

function M.get_current_preset()
    return shimmer_mode
end

function M.cycle_preset()
    current_preset_index = current_preset_index + 1
    if current_preset_index > #preset_list then
        current_preset_index = 1
    end
    
    local new_preset = preset_list[current_preset_index]
    M.set_mode(new_preset)
    return new_preset
end

-- cycle presets backwards
function M.cycle_preset_reverse()
    current_preset_index = current_preset_index - 1
    if current_preset_index < 1 then
        current_preset_index = #preset_list
    end
    
    local new_preset = preset_list[current_preset_index]
    M.set_mode(new_preset)
    return new_preset
end

-- // MARK: PER-CHARACTER CONTROLS

-- per-character toggle: enables/disables character-level phase variation
-- resets to first progression mode when re-enabled for predictable behavior
function M.toggle_per_character()
    per_character_enabled = not per_character_enabled
    
    -- when turning per-character back on, reset to first progression mode
    if per_character_enabled then
        current_per_character_mode = progression_modes_list[1]  -- reset to "uniform"
        current_progression_index = 1
    end
    
    -- when turning off per-character, align all character phases
    if not per_character_enabled then
        -- force immediate widget update to align phases
        local integrations = require('plugins.shimmer.integrations')
        integrations.update_widgets()
    end
    
    -- debug output to verify toggle is working
    -- print("[SHIMMER DEBUG] per_character_enabled:", per_character_enabled)
    -- print("[SHIMMER DEBUG] current_per_character_mode:", current_per_character_mode)
    return per_character_enabled
end

function M.set_per_character(enabled)
    per_character_enabled = enabled
end

function M.get_per_character()
    return per_character_enabled
end

-- direct progression mode setter: applies specific granular mode with visual refresh
-- validates mode exists before applying, returns success status
function M.set_per_character_mode(mode)
    if per_character_modes[mode] then
        current_per_character_mode = mode
        -- force immediate widget update to apply new progression
        local integrations = require('plugins.shimmer.integrations')
        integrations.update_widgets()
        return true
    end
    return false
end

function M.get_per_character_mode()
    return current_per_character_mode
end

-- progression mode cycling: steps through granular animation modes
-- forces widget refresh to immediately show new character phase patterns
function M.cycle_per_character_mode()
    local modes = progression_modes_list
    local current_index = current_progression_index
    
    for i, mode in ipairs(modes) do
        if mode == current_per_character_mode then
            current_index = i
            break
        end
    end
    
    current_index = current_index + 1
    if current_index > #modes then
        current_index = 1
    end
    
    current_per_character_mode = modes[current_index]
    current_progression_index = current_index
    
    -- force immediate widget update to show new progression
    local integrations = require('plugins.shimmer.integrations')
    integrations.update_widgets()
    
    return current_per_character_mode
end

-- cycle backwards through progression modes with immediate visual update
function M.cycle_per_character_mode_reverse()
    local modes = progression_modes_list
    local current_index = current_progression_index
    
    for i, mode in ipairs(modes) do
        if mode == current_per_character_mode then
            current_index = i
            break
        end
    end
    
    current_index = current_index - 1
    if current_index < 1 then
        current_index = #modes
    end
    
    current_per_character_mode = modes[current_index]
    current_progression_index = current_index
    
    -- force immediate widget update to show new progression
    local integrations = require('plugins.shimmer.integrations')
    integrations.update_widgets()
    
    return current_per_character_mode
end

function M.get_per_character_modes()
    return per_character_modes
end

-- per-character shimmer logic: applies granular progression modes to text
-- each character gets phase offset based on position and selected progression mode
-- modes range from uniform (all same) to chaos (high randomness)
function M.should_use_per_character(options)
    options = options or {}
    
    -- explicit override in options takes precedence
    if options.per_letter ~= nil then
        -- print("[SHIMMER DEBUG] using explicit per_letter option:", options.per_letter)
        return options.per_letter
    end
    
    -- global toggle state
    -- print("[SHIMMER DEBUG] should_use_per_character returning:", per_character_enabled)
    return per_character_enabled
end

-- // MARK: COLOR UTILITIES

-- enhanced color interpolation for smoother fade transitions
function M.interpolate_color(color1, color2, factor)
    -- parse hex colors
    local function parse_hex(hex)
        hex = hex:gsub("#", "")
        return {
            r = tonumber(hex:sub(1,2), 16) or 0,
            g = tonumber(hex:sub(3,4), 16) or 0, 
            b = tonumber(hex:sub(5,6), 16) or 0
        }
    end
    
    -- convert RGB to HSL for better color interpolation
    local function rgb_to_hsl(r, g, b)
        r, g, b = r/255, g/255, b/255
        local max = math.max(r, g, b)
        local min = math.min(r, g, b)
        local h, s, l = 0, 0, (max + min) / 2

        if max == min then
            h, s = 0, 0 -- achromatic
        else
            local d = max - min
            s = l > 0.5 and d / (2 - max - min) or d / (max + min)
            if max == r then
                h = (g - b) / d + (g < b and 6 or 0)
            elseif max == g then
                h = (b - r) / d + 2
            elseif max == b then
                h = (r - g) / d + 4
            end
            h = h / 6
        end
        return h, s, l
    end

    -- convert HSL back to RGB
    local function hsl_to_rgb(h, s, l)
        local function hue_to_rgb(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1/6 then return p + (q - p) * 6 * t end
            if t < 1/2 then return q end
            if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
            return p
        end

        local r, g, b
        if s == 0 then
            r, g, b = l, l, l -- achromatic
        else
            local q = l < 0.5 and l * (1 + s) or l + s - l * s
            local p = 2 * l - q
            r = hue_to_rgb(p, q, h + 1/3)
            g = hue_to_rgb(p, q, h)
            b = hue_to_rgb(p, q, h - 1/3)
        end
        return math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
    end
    
    local c1 = parse_hex(color1)
    local c2 = parse_hex(color2)
    
    -- use HSL interpolation for more natural color transitions
    local h1, s1, l1 = rgb_to_hsl(c1.r, c1.g, c1.b)
    local h2, s2, l2 = rgb_to_hsl(c2.r, c2.g, c2.b)
    
    -- interpolate in HSL space
    local h = h1 + (h2 - h1) * factor
    local s = s1 + (s2 - s1) * factor
    local l = l1 + (l2 - l1) * factor
    
    -- convert back to RGB
    local r, g, b = hsl_to_rgb(h, s, l)
    
    -- clamp values
    r = math.max(0, math.min(255, r))
    g = math.max(0, math.min(255, g))
    b = math.max(0, math.min(255, b))
    
    return string.format("#%02x%02x%02x", r, g, b)
end

return M

-- plugins/shimmer.lua
-- Shimmer animation system for tag text and client titles
-- Exposes:
--   shimmer.set_mode(mode)
--   shimmer.apply_to_widget(widget, text, status_symbols)
--   shimmer.get_color(mode_config, text_length)
--   shimmer.restart()
--   shimmer.start()
--   shimmer.stop()

local gears = require("gears")

local M = {}

-- Base gold color settings
local dark_gold = "#8B6914"
local base_gold = "#FFD700"
local light_gold = "#FFFACD"

-- Current animation mode ('candle', 'cloud', 'char_flicker', 'border_sync', 'deep_gold', or 'off')
local shimmer_mode = "border_sync"

-- Widget tracking system (per screen)
local active_tag_widgets = {}
local active_client_widgets = {}

-- Client status prefix function
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

-- Shimmer configuration for different animation modes (optimized for performance)
local shimmer_config = {
    candle = {
        speed = 0.25,  -- reduced frequency from 0.08 to 0.25
        intensity = 0.6,
        randomness = 0.4,
        base_phase = 0,
        random_offset = 0,
        min_factor = 0.2,
        max_factor = 0.8
    },
    cloud = {
        speed = 0.35,  -- reduced frequency from 0.12 to 0.35
        intensity = 0.4,
        wave_length = 100,
        base_phase = 0,
        min_factor = 0.3,
        max_factor = 0.7
    },
    char_flicker = {
        speed = 0.20,  -- reduced frequency from 0.06 to 0.20
        intensity = 0.5,
        char_phases = {},
        min_factor = 0.1,
        max_factor = 0.9
    },
    border_sync = {
        speed = 0.15,  -- reduced frequency from 0.05 to 0.15
        intensity = 0.8,
        min_factor = 0.2,
        max_factor = 0.8
    },
    deep_gold = {
        speed = 0.30,  -- reduced frequency from 0.1 to 0.30
        intensity = 0.7,
        base_phase = 0,
        min_factor = 0.3,
        max_factor = 0.8
    }
}

-- Get character-specific color for flicker mode
local function get_char_shimmer_color(char_index, text_length)
    local config = shimmer_config.char_flicker
    if not config or not config.char_phases then return base_gold end
    
    -- Initialize phase if not exists
    if not config.char_phases[char_index] then
        config.char_phases[char_index] = math.random() * math.pi * 2
    end
    
    local phase = config.char_phases[char_index]
    local wave = math.sin(phase) * 0.5 + 0.5
    local factor = config.min_factor + (config.max_factor - config.min_factor) * wave
    
    return blend_colors(dark_gold, light_gold, factor)
end

-- Timer for shimmer animation
local shimmer_timer = nil

-- Last known border color from border animation (for 'border_sync' mode)
local last_border_color = base_gold
-- subtle pulsing phase for border_sync mode
local sync_phase = 0

-- Function to blend two hex colors
local function blend_colors(color1, color2, factor)
    local function hex_to_rgb(hex)
        hex = hex:gsub("#", "")
        return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
    end
    
    local function rgb_to_hex(r, g, b)
        return string.format("#%02x%02x%02x", math.floor(r), math.floor(g), math.floor(b))
    end
    
    local r1, g1, b1 = hex_to_rgb(color1)
    local r2, g2, b2 = hex_to_rgb(color2)
    
    local r = r1 + (r2 - r1) * factor
    local g = g1 + (g2 - g1) * factor
    local b = b1 + (b2 - b1) * factor
    
    return rgb_to_hex(r, g, b)
end

-- Generate shimmer color based on mode
function M.get_color(mode_config, text_length)
    local config = shimmer_config[mode_config or shimmer_mode]
    if not config then return base_gold end

    local factor = 0.5 -- Start from middle (base gold)

    if mode_config == "candle" or (not mode_config and shimmer_mode == "candle") then
        -- Candle flicker: base sine wave + random flicker
        local base_flicker = math.sin(config.base_phase) * 0.5 + 0.5
        local random_flicker = config.random_offset
        local shimmer_amount = (base_flicker + random_flicker) * config.intensity
        factor = 0.5 + (shimmer_amount - 0.5) * 1.0

    elseif mode_config == "cloud" or (not mode_config and shimmer_mode == "cloud") then
        -- Cloud shadow: smooth sine wave
        local shimmer_amount = (math.sin(config.base_phase * 2 * math.pi / config.wave_length) * 0.5 + 0.5) * config.intensity
        factor = 0.5 + (shimmer_amount - 0.5) * 1.0

    elseif mode_config == "char_flicker" or (not mode_config and shimmer_mode == "char_flicker") then
        -- For character flicker, return base color and handle individual chars elsewhere
        local shimmer_amount = 0.15 * config.intensity
        factor = 0.5 + (shimmer_amount - 0.5) * 1.0

    elseif mode_config == "border_sync" or (not mode_config and shimmer_mode == "border_sync") then
        -- border sync mode - use latest border color, with a subtle pulse so it animates even
        -- when border animation is paused or color is static
        local base = last_border_color or base_gold
        local pulse = (math.sin(sync_phase) * 0.5 + 0.5) * 0.15 -- 0..0.15
        return blend_colors(base, light_gold, pulse)

    elseif mode_config == "deep_gold" or (not mode_config and shimmer_mode == "deep_gold") then
        -- Deep gold mode: rich spectrum avoiding whites/greys
        local base_flicker = math.sin(config.base_phase or 0) * 0.5 + 0.5
        local shimmer_amount = base_flicker * config.intensity
        factor = config.min_factor + shimmer_amount * (config.max_factor - config.min_factor)
    end

    -- Clamp factor to 0-1 range
    factor = math.max(0, math.min(1, factor))

    -- Choose color palette based on mode
    local color
    if mode_config == "deep_gold" or (not mode_config and shimmer_mode == "deep_gold") then
        -- Deep gold palette: rich amber to deep purple, avoiding whites
        local deep_amber = "#B8860B"
        local rich_purple = "#8B4B9B"
        color = blend_colors(deep_amber, rich_purple, factor)
    else
        -- Normal shimmer colors
        color = blend_colors(dark_gold, light_gold, factor)
    end

    return color
end

-- Enhanced apply_to_widget function with status prefix support
function M.apply_to_widget(widget, text, status_symbols)
    if not widget or not widget.set_markup then return end
    text = text or ""
    -- do not override explicit hover color or active fade-out animation
    if widget.__hover_lock or widget.__hover_fade_lock then return end
    
    if shimmer_mode == "off" then
        widget:set_markup('<span color="' .. base_gold .. '">' .. text .. '</span>')
        return
    end

    local config = shimmer_config[shimmer_mode]
    if not config then
        widget:set_markup('<span color="' .. base_gold .. '">' .. text .. '</span>')
        return
    end

    local colored_text = ""
    
    if shimmer_mode == "char_flicker" then
        -- Apply different colors to each character
        for i = 1, #text do
            local char = text:sub(i, i)
            local color = get_char_shimmer_color(i, #text)
            colored_text = colored_text .. '<span color="' .. color .. '">' .. char .. '</span>'
        end
    else
        -- Apply single color to entire text
        local color = M.get_color(shimmer_mode, #text)
        colored_text = '<span color="' .. color .. '">' .. text .. '</span>'
    end
    
    widget:set_markup(colored_text)
end

-- Register a tag widget for shimmer tracking
function M.register_tag_widget(screen_index, tag, textbox)
    if not active_tag_widgets[screen_index] then
        active_tag_widgets[screen_index] = {}
    end
    
    table.insert(active_tag_widgets[screen_index], {
        tag = tag,
        textbox = textbox
    })
end

-- Register a client widget for shimmer tracking  
function M.register_client_widget(screen_index, client, textbox, prefixbox)
    if not active_client_widgets[screen_index] then
        active_client_widgets[screen_index] = {}
    end
    
    table.insert(active_client_widgets[screen_index], {
        client = client,
        textbox = textbox,
        prefixbox = prefixbox
    })
end

-- Update focused client shimmer (immediate, bypasses batching)
function M.update_focused_client()
    if not client.focus or shimmer_mode == "off" then return end
    
    local c = client.focus
    local screen_index = c.screen.index
    local client_widgets = active_client_widgets[screen_index] or {}
    
    for _, widget in pairs(client_widgets) do
        if widget.client and widget.client.valid and widget.client == c then
            local client_name = c.name or c.class or ""
            local status_prefix = get_client_status_prefix(c)
            
            -- Update prefix box if available
            if widget.prefixbox and widget.prefixbox.set_markup then
                local content = (status_prefix and #status_prefix > 0) and status_prefix or ' '
                widget.prefixbox:set_markup('<span color="' .. base_gold .. '">' .. content .. '</span>')
            end
            
            -- Apply shimmer to main text
            M.apply_to_widget(widget.textbox, client_name, nil)
            break
        end
    end
end

-- Update selected tag shimmer  
function M.update_selected_tag()
    if shimmer_mode == "off" then return end
    for s in screen do
        local selected_tags = s.selected_tags or (s.selected_tag and { s.selected_tag } ) or {}
        if #selected_tags > 0 then
            local tag_widgets = active_tag_widgets[s.index] or {}
            for _, t in ipairs(selected_tags) do
                local tag_name = t.name or ""
                for _, w in pairs(tag_widgets) do
                    if w.tag == t then
                        M.apply_to_widget(w.textbox, tag_name, nil)
                    end
                end
            end
        end
    end
end

-- Set shimmer mode
function M.set_mode(mode)
    if shimmer_config[mode] or mode == "off" then
        shimmer_mode = mode
        M.restart()
    end
end

-- Get current mode
function M.get_mode()
    return shimmer_mode
end

-- Expose base colors for external use
function M.get_base_gold()
    return base_gold
end

function M.get_status_prefix(c)
    return get_client_status_prefix(c)
end

-- Restart shimmer timer
function M.restart()
    if shimmer_timer then
        shimmer_timer:stop()
        if shimmer_mode ~= "off" then
            shimmer_timer.timeout = shimmer_config[shimmer_mode].speed
            shimmer_timer:again()
        end
    end
end

-- Start shimmer system
function M.start()
    if shimmer_timer then return end
    
    shimmer_timer = gears.timer {
        timeout = shimmer_config[shimmer_mode].speed,
        autostart = false,
        callback = function()
            if shimmer_mode == "off" then
                shimmer_timer:stop()
                return
            end

            local config = shimmer_config[shimmer_mode]
            if not config then return end

            -- Update timer speed if it changed
            if shimmer_timer.timeout ~= config.speed then
                shimmer_timer.timeout = config.speed
            end

            -- Update animation states
            if shimmer_mode == "candle" then
                config.base_phase = config.base_phase + 0.1
                if math.random() < 0.3 then
                    config.random_offset = (math.random() - 0.5) * config.randomness
                end

            elseif shimmer_mode == "cloud" then
                config.base_phase = config.base_phase + 1
                if config.base_phase >= config.wave_length then
                    config.base_phase = 0
                end

            elseif shimmer_mode == "char_flicker" then
                -- Update individual character phases
                for i = 1, 50 do -- Reasonable limit
                    if config.char_phases[i] then
                        config.char_phases[i] = config.char_phases[i] + (math.random() * 0.4 + 0.1)
                        if config.char_phases[i] > 2 * math.pi then
                            config.char_phases[i] = config.char_phases[i] - 2 * math.pi
                        end
                    end
                end

            elseif shimmer_mode == "deep_gold" then
                config.base_phase = config.base_phase + 0.08
                if config.base_phase > 2 * math.pi then
                    config.base_phase = 0
                end
            elseif shimmer_mode == "border_sync" then
                -- advance pulse phase for border_sync subtle shimmer
                sync_phase = sync_phase + 0.07
                if sync_phase > 2 * math.pi then
                    sync_phase = 0
                end
            end

            -- Update widgets with shimmer (only active ones)
            M.update_selected_tag()
            M.update_focused_client()
            
            -- Emit signal for external listeners
            awesome.emit_signal("shimmer::update")
        end
    }
    
    if shimmer_mode ~= "off" then
        shimmer_timer:start()
    end
end

-- Stop shimmer system
function M.stop()
    if shimmer_timer then
        shimmer_timer:stop()
        shimmer_timer = nil
    end
end

-- Apply/override a preset's configuration at runtime
function M.apply_preset(name, cfg)
    if type(name) ~= "string" or type(cfg) ~= "table" then return end
    local target = shimmer_config[name]
    if not target then return end
    for k, v in pairs(cfg) do
        target[k] = v
    end
    -- If we modified the active mode, reflect changes immediately
    if shimmer_mode == name and shimmer_timer then
        M.restart()
    end
end

-- Signals interface: allow external control and border sync input
awesome.connect_signal("shimmer::set_mode", function(mode)
    if type(mode) == "string" then M.set_mode(mode) end
end)

awesome.connect_signal("shimmer::apply_preset", function(name, cfg)
    M.apply_preset(name, cfg)
end)

-- Client focus/unfocus signal handlers
client.connect_signal("focus", function(c)
    if shimmer_mode ~= "off" then
        M.update_focused_client()
    end
end)

-- Initialize shimmer system
M.start()

-- Receive current border color each tick to support 'border_sync'
awesome.connect_signal("border_animation::tick", function(index, len, color)
    if color then last_border_color = color end
end)

-- Widget tracking for automatic shimmer application
local tracked_widgets = {}
local widget_update_callbacks = {}

-- Track a widget for automatic shimmer updates
function M.track_widget(widget, get_text_fn, get_status_fn)
    if not widget or not get_text_fn then return end
    
    local widget_id = tostring(widget)
    tracked_widgets[widget_id] = {
        widget = widget,
        get_text = get_text_fn,
        get_status = get_status_fn or function() return "" end
    }
    
    -- do not apply shimmer immediately; only active elements shimmer
end

-- Untrack a widget
function M.untrack_widget(widget)
    if not widget then return end
    local widget_id = tostring(widget)
    tracked_widgets[widget_id] = nil
end

-- Batch update counter to reduce update frequency (only for background animations)
local update_batch_counter = 0
local BATCH_UPDATE_FREQUENCY = 2  -- reduced from 3 to 2 for better responsiveness

-- Update all tracked widgets with selective batching
local function update_tracked_widgets()
    -- Always update focused client and selected tag immediately for responsiveness
    M.update_focused_client()
    M.update_selected_tag()
    
    -- Batch update for other tracked widgets: disabled (only active elements shimmer)
    update_batch_counter = update_batch_counter + 1
    if update_batch_counter < BATCH_UPDATE_FREQUENCY then
        return  -- skip this update cycle for non-critical widgets
    end
    update_batch_counter = 0
    
    -- clean up invalid widgets only
    for widget_id, data in pairs(tracked_widgets) do
        if not data.widget or data.widget.valid == false then
            tracked_widgets[widget_id] = nil
        end
    end
end

-- Enhanced shimmer update signal handler
awesome.connect_signal("shimmer::update", function()
    update_tracked_widgets()
end)

-- Auto-integration with taglist widgets
awesome.connect_signal("request::desktop_decoration", function(s)
    -- This will be called when screens are set up
    gears.timer.delayed_call(function()
        if s.mytaglist then
            -- Connect to taglist updates
            s.mytaglist:connect_signal("widget::layout_changed", function()
                gears.timer.delayed_call(function()
                    -- Find and register all tag text widgets
                    local function find_tag_widgets(widget, depth)
                        if depth > 5 then return end -- prevent infinite recursion
                        
                        if widget.get_children_by_id then
                            local text_widgets = widget:get_children_by_id("text_role")
                            for _, text_widget in ipairs(text_widgets) do
                                if text_widget and text_widget.set_markup then
                                    -- Find associated tag
                                    local parent = widget
                                    local tag_obj = nil
                                    while parent and not tag_obj do
                                        tag_obj = parent._tag or parent.tag
                                        parent = parent.parent
                                    end
                                    
                                    if tag_obj then
                                        M.register_tag_widget(s.index, tag_obj, text_widget)
                                    end
                                end
                            end
                        end
                        
                        if widget.get_children then
                            local children = widget:get_children()
                            for _, child in ipairs(children) do
                                find_tag_widgets(child, depth + 1)
                            end
                        end
                    end
                    
                    find_tag_widgets(s.mytaglist, 0)
                end)
            end)
            -- initial scan to register tag widgets right away
            gears.timer.delayed_call(function()
                local function find_tag_widgets(widget, depth)
                    if depth > 5 then return end
                    if widget.get_children_by_id then
                        local text_widgets = widget:get_children_by_id("text_role")
                        for _, text_widget in ipairs(text_widgets) do
                            if text_widget and text_widget.set_markup then
                                local parent = widget
                                local tag_obj = nil
                                while parent and not tag_obj do
                                    tag_obj = parent._tag or parent.tag
                                    parent = parent.parent
                                end
                                if tag_obj then
                                    M.register_tag_widget(s.index, tag_obj, text_widget)
                                end
                            end
                        end
                    end
                    if widget.get_children then
                        local children = widget:get_children()
                        for _, child in ipairs(children) do
                            find_tag_widgets(child, depth + 1)
                        end
                    end
                end
                find_tag_widgets(s.mytaglist, 0)
                -- force an immediate shimmer of selected tags
                M.update_selected_tag()
            end)
        end
        
        if s.mytasklist then
            -- Connect to tasklist updates
            s.mytasklist:connect_signal("widget::layout_changed", function()
                gears.timer.delayed_call(function()
                    -- Find and register all task text widgets
                    local function find_task_widgets(widget, depth)
                        if depth > 5 then return end
                        
                        if widget.get_children_by_id then
                            local text_widgets = widget:get_children_by_id("text_role")
                            for _, text_widget in ipairs(text_widgets) do
                                if text_widget and text_widget.set_markup then
                                    -- Find associated client
                                    local parent = widget
                                    local client_obj = nil
                                    while parent and not client_obj do
                                        client_obj = parent._client or parent.client
                                        parent = parent.parent
                                    end
                                    
                                    if client_obj then
                                        M.register_client_widget(s.index, client_obj, text_widget, nil)
                                    end
                                end
                            end
                        end
                        
                        if widget.get_children then
                            local children = widget:get_children()
                            for _, child in ipairs(children) do
                                find_task_widgets(child, depth + 1)
                            end
                        end
                    end
                    
                    find_task_widgets(s.mytasklist, 0)
                end)
            end)
            -- initial scan to register client widgets right away
            gears.timer.delayed_call(function()
                local function find_task_widgets(widget, depth)
                    if depth > 5 then return end
                    if widget.get_children_by_id then
                        local text_widgets = widget:get_children_by_id("text_role")
                        for _, text_widget in ipairs(text_widgets) do
                            if text_widget and text_widget.set_markup then
                                local parent = widget
                                local client_obj = nil
                                while parent and not client_obj do
                                    client_obj = parent._client or parent.client
                                    parent = parent.parent
                                end
                                if client_obj then
                                    M.register_client_widget(s.index, client_obj, text_widget, nil)
                                end
                            end
                        end
                    end
                    if widget.get_children then
                        local children = widget:get_children()
                        for _, child in ipairs(children) do
                            find_task_widgets(child, depth + 1)
                        end
                    end
                end
                find_task_widgets(s.mytasklist, 0)
                -- force an immediate shimmer of focused client
                M.update_focused_client()
            end)
        end
    end)
end)

-- Initialize shimmer system automatically
M.start()

return M

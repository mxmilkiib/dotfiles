-- plugins/shimmer/integrations.lua
-- Widget integration and shimmer application for tags, tasks, and launcher
--
-- INTEGRATION ARCHITECTURE:
-- This module handles shimmer integration with AwesomeWM widgets:
-- • Taglist widgets - per-tag registration with hover effects
-- • Tasklist widgets - focused client shimmer with per-character support
-- • Launcher widget - continuous shimmer animation
-- • Tag hover system - smooth fade transitions with color interpolation
-- • Phase offset management - different timing for each component type
--
-- HOVER SYSTEM:
-- • Mouse enter: applies shimmer/gold with unique phase per tag
-- • Mouse leave: smooth fade using color interpolation over 15 steps
-- • Per-character aware: handles both solid and per-character fade modes
-- • Theme integration: fades to beautiful.taglist_fg_empty colors
--
-- PHASE OFFSETS:
-- • tag_phase = 0.0    (base timing)
-- • task_phase = 1.0   (offset for variety)
-- • launcher_phase = 2.0 (further offset)
-- • border_phase - managed by border module, tasklist, launcher

local gears = require("gears")
local awful = require("awful")

local M = {}

-- // MARK: CONFIGURATION STATE

-- shimmer configuration with phase offsets for component timing variety
local shimmer_config = {
    tag_phase = 0.0,      -- tags start at base phase
    task_phase = 1.0,     -- tasks offset by 1.0 (different timing)
    launcher_phase = 2.0, -- launcher offset by 2.0
    per_letter = {
        tags = false,
        tasks = false,
        launcher = false
    }
}

-- // MARK: WIDGET TRACKING

-- widget registration and reference storage
local registered_widgets = {
    taglist = {},  -- [screen_index][tag] = widget
    tasklist = {},
    tasklist_clients = {},  -- [client] = text_widget for direct shimmer updates
    launcher = nil
}

-- // MARK: MODULE DEPENDENCIES

-- get animation functions (lazy loading to avoid circular deps)
local function get_animation()
    return require("plugins.shimmer.animation")
end

-- // MARK: TAGLIST INTEGRATION

-- simplified taglist registration - map individual tag widgets to their tags
function M.register_taglist(taglist_widget, screen_index, tag)
    if not registered_widgets.taglist[screen_index] then
        registered_widgets.taglist[screen_index] = {}
    end
    -- store widget by tag reference for proper mapping
    if tag then
        registered_widgets.taglist[screen_index][tag] = taglist_widget
    else
        -- backward compatibility - store as array
        table.insert(registered_widgets.taglist[screen_index], taglist_widget)
    end
end

-- // MARK: TASKLIST INTEGRATION

-- simplified tasklist registration  
function M.register_tasklist(tasklist_widget)
    table.insert(registered_widgets.tasklist, tasklist_widget)
    
    -- immediately check for focused client and apply shimmer
    local focused = client.focus
    if focused then
        -- force tasklist content update by triggering property changes
        focused:emit_signal("property::name")
        focused:emit_signal("property::class")
        tasklist_widget:emit_signal("widget::redraw_needed")
        
        -- defer shimmer application to prevent startup blocking
        gears.timer.start_new(0.2, function()
            local text_widget = registered_widgets.tasklist_clients[focused]
            if text_widget then
                local title = focused.name or focused.class or ""
                if title ~= "" then
                    local animation = get_animation()
                    local options = {
                        phase_offset = shimmer_config.task_phase
                    }
                    animation.apply_to_widget(text_widget, title, nil, options)
                end
            end
            return false
        end)
    end
end

-- tasklist update callback for shimmer integration with per-character support
function M.tasklist_update_callback(self, c, index, objects)
    gears.timer.start_new(0.05, function()
        local tb = self:get_children_by_id('text_role')[1]
        if tb and c then
            -- store client->widget mapping for continuous shimmer updates
            registered_widgets.tasklist_clients[c] = tb
            
            -- always check if this client is focused and apply shimmer accordingly
            local is_focused = (c == client.focus)
            local title = c.name or c.class or ""
            
            if title ~= "" then
                if is_focused then
                    local animation = get_animation()
                    local options = {
                        phase_offset = shimmer_config.task_phase
                        -- removed per_letter override to allow global toggle
                    }
                    animation.apply_to_widget(tb, title, nil, options)
                else
                    -- plain text for unfocused clients
                    tb:set_text(title)
                end
            end
        end
        return false
    end)
end

-- // MARK: LAUNCHER INTEGRATION

-- launcher registration for continuous shimmer
function M.register_launcher(launcher_widget)
    registered_widgets.launcher = launcher_widget
    if launcher_widget and launcher_widget.set_markup then
        local animation = get_animation()
        -- disable per-character shimmer for launcher to avoid UTF-8 issues
        local launcher_options = {
            phase_offset = shimmer_config.launcher_phase,
            per_letter = false  -- force solid color for launcher
        }
        animation.apply_to_widget(launcher_widget, 'gear', nil, launcher_options)
    end
end

-- // MARK: TAG HOVER SYSTEM

-- tag hover handler with smooth fade transitions and per-character support
function M.handle_tag_hover(tag_widget, tag, mode)
    local text_widget = tag_widget and tag_widget:get_children_by_id('text_role')[1]
    if not text_widget or not text_widget.set_markup then return end
    
    local current = tag.name or ''
    local animation = get_animation()
    local base_gold = animation.get_base_gold()
    
    if mode == "enter" then
        if tag.selected then return end
        
        local dnd_to_tag = package.loaded["plugins.dnd_to_tag"]
        if dnd_to_tag and dnd_to_tag.drag_active then
            -- when dragging, delegate hover to dnd module and skip shimmer hover FX
            dnd_to_tag.set_hover(tag, tag_widget)
            return
        end
        
        text_widget.__hover_lock = true
        
        -- use per-character shimmer if enabled, otherwise use current palette gold
        if animation.should_use_per_character() then
            -- each tag gets slightly different hover phase for variety
            local hover_phase = shimmer_config.tag_phase + (tag.index or 1) * 0.3
            local hover_options = { per_character_mode = animation.get_per_character_mode() }
            local hover_markup = animation.get_letter_shimmer_markup(current, hover_phase, hover_options)
            text_widget:set_markup(hover_markup)
        else
            -- use current palette color for consistent gold shine
            local palette_color = animation.get_color(nil, 1, shimmer_config.tag_phase + (tag.index or 1) * 0.3)
            text_widget:set_markup('<span color="' .. palette_color .. '">' .. current .. '</span>')
        end
        
        tag_widget.__hover_text_colored = true
        
    elseif mode == "leave" then
        -- when dragging, clear dnd hover and skip shimmer leave FX
        local dnd_to_tag = package.loaded["plugins.dnd_to_tag"]
        if dnd_to_tag and dnd_to_tag.drag_active then
            dnd_to_tag.clear_hover()
            return
        end
        if tag_widget.__hover_text_colored then
            text_widget.__hover_lock = nil
            tag_widget.__hover_text_colored = nil

            if tag.selected then
                local options = {
                    phase_offset = shimmer_config.tag_phase,
                    per_letter = shimmer_config.per_letter.tags
                }
                animation.apply_to_widget(text_widget, current, nil, options)
            else
                if text_widget.__hover_fade_timer and text_widget.__hover_fade_timer.stop then
                    text_widget.__hover_fade_timer:stop()
                end
                
                local fade_steps = 20
                local fade_duration = 1.5
                local step_time = fade_duration / fade_steps
                local step = 0
                
                -- determine fade target based on theme with better fallbacks
                local beautiful = require("beautiful")
                local animation = get_animation()
                
                -- improved fade target selection with debug info
                local fade_target
                if beautiful.taglist_fg_empty then
                    fade_target = beautiful.taglist_fg_empty
                    print("[FADE DEBUG] Using taglist_fg_empty:", fade_target)
                elseif beautiful.fg_normal then
                    fade_target = beautiful.fg_normal  -- use theme color directly
                    print("[FADE DEBUG] Using fg_normal:", fade_target)
                else
                    -- instead of harsh white, use a warm neutral
                    fade_target = "#c0c0c0"  -- light gray instead of white
                    print("[FADE DEBUG] Using fallback gray:", fade_target)
                end
                
                text_widget.__hover_fade_timer = gears.timer {
                    timeout = step_time,
                    autostart = true,
                    callback = function()
                        step = step + 1
                        local linear_progress = step / fade_steps
                        
                        -- easing curves for smoother fade animation
                        local progress
                        if linear_progress >= 1.0 then
                            progress = 1.0
                        else
                            -- ease-out cubic: fast start, slow end (most natural for fade out)
                            progress = 1 - math.pow(1 - linear_progress, 3)
                            
                            -- alternative easing options (comment/uncomment to try):
                            -- ease-in-out cubic: slow start and end, fast middle
                            -- progress = linear_progress < 0.5 and 4 * linear_progress^3 or 1 - math.pow(-2 * linear_progress + 2, 3) / 2
                            
                            -- ease-out quad: gentler curve
                            -- progress = 1 - (1 - linear_progress)^2
                            
                            -- ease-out exponential: very fast start, very slow end
                            -- progress = linear_progress == 1 and 1 or 1 - math.pow(2, -10 * linear_progress)
                        end
                        
                        if animation.should_use_per_character() then
                            -- fade per-character shimmer to plain text
                            local hover_phase = shimmer_config.tag_phase + (tag.index or 1) * 0.3
                            local fade_options = { per_character_mode = animation.get_per_character_mode() }
                            
                            if progress >= 1.0 then
                                text_widget:set_markup('<span color="' .. fade_target .. '">' .. current .. '</span>')
                            else
                                -- gradually reduce shimmer intensity
                                local fade_alpha = 1.0 - progress
                                local shimmer_color = animation.get_color(nil, 1, hover_phase)
                                local interpolated = animation.interpolate_color(shimmer_color, fade_target, progress)
                                text_widget:set_markup('<span color="' .. interpolated .. '">' .. current .. '</span>') 
                            end
                        else
                            -- fade to proper foreground color using simple linear interpolation
                            if progress >= 1.0 then
                                text_widget:set_markup('<span color="' .. fade_target .. '">' .. current .. '</span>')
                            else
                                local hover_phase = shimmer_config.tag_phase + (tag.index or 1) * 0.3
                                local start_color = animation.get_color(nil, 1, hover_phase)
                                
                                -- simple linear RGB interpolation to target color
                                local function lerp_color(c1, c2, t)
                                    local function hex_to_rgb(hex)
                                        hex = hex:gsub("#", "")
                                        return tonumber(hex:sub(1,2), 16), tonumber(hex:sub(3,4), 16), tonumber(hex:sub(5,6), 16)
                                    end
                                    local r1, g1, b1 = hex_to_rgb(c1)
                                    local r2, g2, b2 = hex_to_rgb(c2)
                                    local r = math.floor(r1 + (r2 - r1) * t)
                                    local g = math.floor(g1 + (g2 - g1) * t)
                                    local b = math.floor(b1 + (b2 - b1) * t)
                                    return string.format("#%02x%02x%02x", r, g, b)
                                end
                                
                                local interpolated = lerp_color(start_color, fade_target, progress)
                                text_widget:set_markup('<span color="' .. interpolated .. '">' .. current .. '</span>')
                            end
                        end
                        
                        if step >= fade_steps then
                            text_widget.__hover_fade_timer:stop()
                            text_widget.__hover_fade_timer = nil
                            text_widget.__hover_fade_lock = nil
                            -- final state: plain text with theme color
                            text_widget:set_markup(current)
                        end
                    end
                }
                
                text_widget.__hover_fade_lock = true
            end
        end
    elseif mode == "dnd_enter" then
        text_widget.__hover_lock = true
        text_widget:set_markup('<span color="' .. base_gold .. '">' .. current .. '</span>')
        tag_widget.__dnd_hover_active = true
        
    elseif mode == "dnd_leave" then
        if tag_widget.__dnd_hover_active then
            text_widget.__hover_lock = nil
            tag_widget.__dnd_hover_active = nil
            if tag.selected then
                local options = {
                    phase_offset = shimmer_config.tag_phase,
                    per_letter = shimmer_config.per_letter.tags
                }
                animation.apply_to_widget(text_widget, current, nil, options)
            else
                if text_widget.__hover_fade_timer and text_widget.__hover_fade_timer.stop then
                    text_widget.__hover_fade_timer:stop()
                end
                text_widget:set_markup(current)
            end
        end
    end
end

-- // MARK: WIDGET UPDATE SYSTEM

-- update all registered widgets with current shimmer on each animation frame application
function M.update_widgets()
    local animation = get_animation()
    
    -- update all tags with proper tag-to-widget mapping
    for screen_index, tag_widgets in pairs(registered_widgets.taglist) do
        local s = screen[screen_index]
        if s then
            for _, tag in pairs(s.tags) do
                local widget = tag_widgets[tag]  -- get specific widget for this tag
                if widget then
                    local text_widget = widget:get_children_by_id('text_role')[1]
                    if text_widget and not text_widget.__hover_lock and not text_widget.__hover_fade_lock then
                        if tag.selected then
                            -- apply shimmer to selected tag with its own name
                            local options = {
                                phase_offset = shimmer_config.tag_phase
                                -- removed per_letter override to allow global toggle
                            }
                            animation.apply_to_widget(text_widget, tag.name or "", nil, options)
                        else
                            -- ensure unselected tags show their correct plain text names
                            text_widget:set_markup(tag.name or "")
                        end
                    end
                end
            end
        end
    end
    
    -- update focused client in tasklist with direct shimmer application
    local focused = client.focus
    if focused then
        local text_widget = registered_widgets.tasklist_clients[focused]
        if text_widget and not text_widget.__hover_lock then
            local title = focused.name or focused.class or ""
            if title ~= "" then
                local options = {
                    phase_offset = shimmer_config.task_phase
                    -- removed per_letter override to allow global toggle
                }
                animation.apply_to_widget(text_widget, title, nil, options)
            end
        end
        
        -- also trigger general tasklist redraw for other updates
        for _, tasklist in pairs(registered_widgets.tasklist) do
            tasklist:emit_signal("widget::redraw_needed")
        end
    end
    
    -- update launcher widget if registered
    if registered_widgets.launcher then
        local launcher_options = {
            phase_offset = shimmer_config.launcher_phase,
            per_letter = false  -- force solid color for launcher
        }
        animation.apply_to_widget(registered_widgets.launcher, 'gear', nil, launcher_options)
    end
end

-- initialize shimmer for currently focused client (called after system startup)
function M.initialize_focused_client()
    local focused = client.focus
    if focused then
        -- manually scan tasklist widgets to find focused client widget
        for _, tasklist in pairs(registered_widgets.tasklist) do
            -- force tasklist to rebuild by triggering client property changes
            focused:emit_signal("property::name")
            focused:emit_signal("property::class")
            tasklist:emit_signal("widget::redraw_needed")
        end
        
        -- immediate direct widget application attempt
        local text_widget = registered_widgets.tasklist_clients[focused]
        if text_widget then
            local title = focused.name or focused.class or ""
            if title ~= "" then
                local animation = get_animation()
                local options = {
                    phase_offset = shimmer_config.task_phase
                }
                animation.apply_to_widget(text_widget, title, nil, options)
            end
        else
            -- fallback with reasonable delay to prevent blocking
            gears.timer.start_new(0.15, function()
                local text_widget = registered_widgets.tasklist_clients[focused]
                if text_widget then
                    local title = focused.name or focused.class or ""
                    if title ~= "" then
                        local animation = get_animation()
                        local options = {
                            phase_offset = shimmer_config.task_phase
                        }
                        animation.apply_to_widget(text_widget, title, nil, options)
                    end
                end
                return false
            end)
        end
    end
end

-- setup client focus signal handling to ensure shimmer on focus changes
function M.setup_focus_signals()
    -- connect to client focus signal to ensure shimmer is applied
    client.connect_signal("focus", function(c)
        -- immediate update without delay
        M.update_widgets()
        
        -- force tasklist content update by triggering property changes
        if c then
            c:emit_signal("property::name")
            c:emit_signal("property::urgent")
            c:emit_signal("property::minimized")
        end
        
        -- also force tasklist redraw to ensure widget mapping
        for _, tasklist in pairs(registered_widgets.tasklist) do
            tasklist:emit_signal("widget::redraw_needed")
        end
    end)
    
    -- also connect to unfocus to clear shimmer from unfocused clients
    client.connect_signal("unfocus", function(c)
        local text_widget = registered_widgets.tasklist_clients[c]
        if text_widget then
            local title = c.name or c.class or ""
            if title ~= "" then
                text_widget:set_text(title)  -- plain text for unfocused
            end
        end
    end)
    
    -- connect to client list changes to handle startup scenarios
    client.connect_signal("list", function()
        gears.timer.start_new(0.1, function()
            M.update_widgets()
            return false
        end)
    end)
end

-- getter function for registered tasklists
function M.get_registered_tasklists()
    return registered_widgets.tasklist
end

-- // MARK: CONFIGURATION FUNCTIONS

-- phase offset configuration functions
function M.set_phase_offsets(config)
    if config.tag_phase ~= nil then shimmer_config.tag_phase = config.tag_phase end
    if config.task_phase ~= nil then shimmer_config.task_phase = config.task_phase end
    if config.launcher_phase ~= nil then shimmer_config.launcher_phase = config.launcher_phase end
end

function M.get_phase_offsets()
    return {
        tag_phase = shimmer_config.tag_phase,
        task_phase = shimmer_config.task_phase,
        launcher_phase = shimmer_config.launcher_phase
    }
end

-- per-letter mode configuration functions
function M.set_per_letter_modes(config)
    if config.tags ~= nil then shimmer_config.per_letter.tags = config.tags end
    if config.tasks ~= nil then shimmer_config.per_letter.tasks = config.tasks end
    if config.launcher ~= nil then shimmer_config.per_letter.launcher = config.launcher end
end

function M.get_per_letter_modes()
    return {
        tags = shimmer_config.per_letter.tags,
        tasks = shimmer_config.per_letter.tasks,
        launcher = shimmer_config.per_letter.launcher
    }
end

-- internal accessor for registered widgets map (for cooperating modules)
-- intentionally underscored to signify internal use
function M._get_registered_widgets()
    return registered_widgets
end

return M

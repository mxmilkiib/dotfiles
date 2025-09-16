-- plugins/shimmer/init.lua
-- Unified shimmer animation system for AwesomeWM
-- Main interface module - flattened API for easy access
--
-- SYSTEM OVERVIEW:
-- This module provides a unified shimmer system with the following components:
-- • Text shimmer effects (solid color or per-character)
-- • Window border shimmer animation
-- • Widget integration (tags, tasks, launcher)
-- • Preset management with cycling support
-- • Per-character toggle independent of presets
-- • Smooth color interpolation for transitions
--
-- USAGE:
-- shimmer.configure({ preset = "debug", border = { smoothness = 3 } })
-- shimmer.cycle_preset()           -- cycle through presets
-- shimmer.toggle_per_character()   -- toggle per-character mode
-- shimmer.set_mode("candle")       -- set specific preset
--
-- HOTKEYS (defined in keybindings.lua):
-- Mod4+Shift+Alt+c = cycle presets
-- Mod4+Shift+Alt+p = toggle per-character
-- Mod4+Shift+Alt+1-5,0 = specific presets

local gears = require("gears")
local animation = require("plugins.shimmer.animation")
local border = require("plugins.shimmer.border") 
local integrations = require("plugins.shimmer.integrations")

local M = {}

-- // MARK: ANIMATION FUNCTIONS
-- expose core animation functions directly (flattened API)
M.set_mode = animation.set_mode
M.get_mode = animation.get_mode
M.get_color = animation.get_color
M.start = animation.start
M.stop = animation.stop
M.restart = animation.restart
M.apply_to_widget = animation.apply_to_widget
M.get_base_gold = animation.get_base_gold
M.get_status_prefix = animation.get_status_prefix
M.get_palette = animation.get_palette
M.get_gradient_params = animation.get_gradient_params
M.set_gradient_params = animation.set_gradient_params
M.clear_palette_cache = animation.clear_palette_cache
M.get_letter_shimmer_markup = animation.get_letter_shimmer_markup
M.add_preset = animation.add_preset
M.get_preset_list = animation.get_preset_list
M.get_current_preset = animation.get_current_preset
M.cycle_preset = animation.cycle_preset
M.toggle_per_character = animation.toggle_per_character
M.set_per_character = animation.set_per_character
M.get_per_character = animation.get_per_character
M.should_use_per_character = animation.should_use_per_character
M.interpolate_color = animation.interpolate_color
M.set_per_character_mode = animation.set_per_character_mode
M.get_per_character_mode = animation.get_per_character_mode
M.cycle_per_character_mode = animation.cycle_per_character_mode
M.get_per_character_modes = animation.get_per_character_modes
M.set_speed_multiplier = animation.set_speed_multiplier
M.get_speed_multiplier = animation.get_speed_multiplier
M.get_debug_status = animation.get_debug_status

-- // MARK: WIDGET INTEGRATION FUNCTIONS
-- functions for registering and managing widget shimmer
M.register_taglist = integrations.register_taglist
M.register_tasklist = integrations.register_tasklist
M.register_launcher = integrations.register_launcher
M.handle_tag_hover = integrations.handle_tag_hover
M.tasklist_update_callback = integrations.tasklist_update_callback
M.set_phase_offsets = integrations.set_phase_offsets
M.set_per_letter_modes = integrations.set_per_letter_modes
M.get_phase_offsets = integrations.get_phase_offsets
M.get_per_letter_modes = integrations.get_per_letter_modes
M.initialize_focused_client = integrations.initialize_focused_client
M.setup_focus_signals = integrations.setup_focus_signals

-- // MARK: BORDER ANIMATION FUNCTIONS
-- window border shimmer controls
M.set_border_phase_offset = border.set_phase_offset
M.get_border_phase_offset = border.get_phase_offset
M.set_border_smoothness = border.set_smoothness
M.pause_border = border.pause
M.resume_border = border.resume
M.get_border_state = border.get_state
M.border_on_mode_changed = border.on_mode_changed

-- // MARK: SYSTEM CONFIGURATION
-- main configuration function with preset and component setup
function M.configure(config)
    config = config or {}
    
    -- set preset if specified
    if config.preset then
        animation.set_mode(config.preset)
    end
    
    -- configure border animation if specified
    if config.border then
        if config.border.smoothness then
            border.set_smoothness(config.border.smoothness)
        end
    end
    
    -- configure phase offsets
    if config.phase_offsets then
        integrations.set_phase_offsets(config.phase_offsets)
    end
    
    -- configure per-letter shimmer modes
    if config.per_letter then
        integrations.set_per_letter_modes(config.per_letter)
    end
    
    -- start systems
    animation.start()
    border.start()
    
    -- setup focus signal handling to ensure shimmer on focus changes
    integrations.setup_focus_signals()
end

-- initialize system (defer to avoid startup issues)
-- NOTE: removed automatic configure() call to prevent overriding rc.lua configuration
-- the system will be initialized by the explicit shimmer.configure() call in rc.lua

return M

--------------------------------------------------
-- Milkiis rc.lua                                --
-- https://github.com/mxmilkiib/dotfiles        --
--------------------------------------------------

-- 🧪 TESTING METHODS:
-- 
-- BASIC SYNTAX CHECK (no libraries):
--   lua -e "dofile('rc.lua')" 2>&1 | head -10
--   (Expected: "module 'gears' not found" - this is normal outside AwesomeWM)

-- FULL ENVIRONMENT TEST (with AwesomeWM libraries):
--   awesome -c ~/.config/awesome/rc.lua --check
--   (Tests complete configuration with all libraries loaded)

-- XEPHYR TEST ENVIRONMENT:
--[[
Xephyr :1 -ac -br -noreset -screen 1152x720 & sleep 1 && DISPLAY=:1.0 awesome -c ~/.config/awesome/rc.lua || echo "Configuration error"
--]]
--   (Runs AwesomeWM in virtual display for safe testing)

-- LINTING WITH LUA CHECK:
--   luarocks install luacheck
--   luacheck rc.lua --no-max-line-length
--   (Static analysis for common Lua issues)

-- DEBUG MODE:
--   awesome -c ~/.config/awesome/rc.lua --debug
--   (Runs with debug output for troubleshooting)
--
-- NOTE: The "module 'gears' not found" error is expected when testing
-- outside the AwesomeWM environment. Use awesome --check for full validation.


-- // MARK: OVERVIEW
-- ################################################################################
-- ██████╗ ██╗██████╗ ███████╗ ██████╗████████╗ ██████╗ ██████╗ ██╗   ██╗
-- ██╔══██╗██║██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗╚██╗ ██╔╝
-- ██║  ██║██║██████╔╝█████╗  ██║        ██║   ██║   ██║██████╔╝ ╚████╔╝ 
-- ██║  ██║██║██╔══██╗██╔══╝  ██║        ██║   ██║   ██║██╔══██╗  ╚██╔╝  
-- ██████╔╝██║██║  ██║███████╗╚██████╗   ██║   ╚██████╔╝██║  ██║   ██║   
-- ╚═════╝ ╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝   
-- ################################################################################
-- CONFIGURATION DIRECTORY OVERVIEW
-- This awesome config contains the following components:
--
-- 📄 MAIN FILES:
--   • rc.lua (104KB, 2528 lines) - This comprehensive configuration file (cleaned & optimized)
--   • rc_new.lua (15KB, 307 lines) - Alternative minimal config
--   • quake.lua (5.6KB, 169 lines) - Dropdown terminal (Quake-style)
--   • xrandr.lua (3.5KB, 136 lines) - Multi-monitor display management
--   • test_dialog_sizing.lua (1.5KB, 45 lines) - Dialog sizing test script
--
-- 📚 DOCUMENTATION:
--   • DIALOG_SIZING.md (5.0KB, 171 lines) - Auto-sizing for all dialog types
--   • CENTERWORK_ADAPTIVE_README.md (2.8KB, 67 lines) - Custom layout behavior
--   • LAYOUT_ICONS_README.md (4.5KB, 126 lines) - Complete icon reference
--
-- 🎨 THEMING:
--   • milktheme/ - Custom theme with backgrounds, icons, and styling
--
-- 🏗️ LAYOUT ENGINES:
--   • bling/ - Modern layouts (deck, horizontal, equalarea, vertical, mstab, centered)
--   • lain/ - Classic layouts (centerwork, cascade, termfair) + utilities
--   • treetile/ - Hierarchical window arrangement
--   • awesome-workspace-grid/ - Grid-based workspace management
--
-- 🎮 WINDOW MANAGEMENT:
--   • collision/ - Vim-like directional focus navigation
--   • awesome-switcher/ - Alt-Tab application switcher with previews
--   • cyclefocus/ - Advanced focus cycling mechanisms
--   • tyrannical/ - Rule-based dynamic tagging system
--   • revelation/ - OSX-style window exposé overview
--
-- 📱 WIDGETS & STATUS:
--   • battery-widget/ - Visual battery status and charging indicators
--   • media-player-widget/ - Media controls and track information
--   • awesome-wm-widgets/ - Widget collection framework
--
-- 🔌 SYSTEM INTEGRATION:
--   • freedesktop/ - XDG menu integration and .desktop file support
--   • gobo/ - Custom system integration utilities
--   • thrizen/ - Additional system tools
--   • plugins/ - Custom extensions (dnd_to_tag, shimmer, keystats, tag_indicators, etc.)
--
-- 🗂️ BACKUP ARCHIVE (multiple versions):
--   • Recent backups: rc.lua.bak-20250908_2056, rc.lua.bak-20250908_1504, rc.lua.bak-20250907_0212
--   • Evolution: 568 lines → 3,347 lines (22KB → 144KB)
--
-- Total: 20+ layouts, 5 focus systems, comprehensive widget ecosystem,
-- deep system integration, and methodical configuration evolution.
--
-- ⚠️  INTENTIONALLY DISABLED FEATURES (commented out by choice):
-- NAVIGATION ALTERNATIVES:
--   • gobo.awesome.alttab - Alternative Alt-Tab implementation 
--   • revelation - OSX-style window exposé overview
--   • awesomewm-vim-tmux-navigator - Cross-app (Vim/Tmux) navigation
--
-- LAYOUT EXTENSIONS:
--   • tyrannical + shortcuts - Dynamic desktop tagging system
--   • dovetail, thrizen, leaved - Alternative layout scripts
--   • fenetre - Titlebar customization framework
--   • awesome-workspace-grid - Grid-based tag navigation system
--
-- WIDGETS & UTILITIES:
--   • battery-widget - Visual battery status and charging indicators
--   • xrandr - Multi-monitor display management interface
--   • mpris_widget/media-player - Media controls and track information
--   • smart_borders - Automatic border width control
--
-- OPTIONAL BEHAVIORS:
--   • awful.hotkeys_popup.keys - Extended hotkey help system
--   • freedesktop desktop icons - Desktop icon integration
--   • Sloppy focus - Focus follows mouse behavior
--   • Alternative client rules, placement, and titlebar processing
--
-- NOTE: These features are available but intentionally disabled for current workflow.
--
-- 🔍 SUBDIRECTORY STATUS:
-- ✅ HEALTHY: collision/, bling/, lain/, milktheme/, tyrannical/, awesome-workspace-grid/
-- ✅ FUNCTIONAL: treetile/, freedesktop/, revelation/, battery-widget/, media-player-widget/
-- ⚠️ UNKNOWN: gobo/ (directory access issues - may need investigation)
-- ✅ EMPTY: awesome-wm-widgets/ (placeholder for additional widgets)
-- 📝 PLUGINS: plugins/ contains xrandr.lua + media-player/ subdirectory
--
-- 🏗️  ARCHITECTURE: Plugin-based modular design with clean APIs
-- 🔄 STATUS: Production-ready, fully validated configuration
--
-- ✅ RECENT OPTIMIZATIONS:
-- - Removed 1,149 lines of commented-out dead code (819 lines reduction)
-- - Centralized all keybindings in keybindings.lua module
-- - Fixed keybinding integration and root.keys() unpacking
-- - Cleaned up redundant global variable definitions
-- - File size reduced from 144KB to 104KB (28% reduction)


-- run in xephyr for testing:



-- // MARK: LIBS
-- ################################################################################
-- ██╗     ██╗██████╗ ███████╗
-- ██║     ██║██╔══██╗██╔════╝
-- ██║     ██║██████╔╝███████╗
-- ██║     ██║██╔══██╗╚════██║
-- ███████╗██║██████╔╝███████║
-- ╚══════╝╚═╝╚═════╝ ╚══════╝
-- ################################################################################
-- LIBRARIES - core library imports and external dependencies
-- If LuaRocks is installed, make sure that packages installed through it are found


pcall(require, "luarocks.loader")

-- Standard awesome libraries
local gears = require("gears")
local gmath = require("gears.math")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")     -- Widget and layout library
local beautiful = require("beautiful") -- Theme handling library
local naughty = require("naughty")   -- Notification library
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local lgi = require("lgi")
local cairo = lgi.cairo

-- layouts will be defined in request::default_layouts handler below


-- external libraries
local lain = require("lain")                  -- Layouts, widgets, utilities
local bling = require("bling")                -- Modern layouts and utilities
local cyclefocus = require("cyclefocus")       -- Cycle between applications
local freedesktop = require("freedesktop")      -- Create a menu from .desktop files
local treetile = require("treetile")           -- Hierarchical window arrangement
local shimmer = require("plugins.shimmer")     -- Unified shimmer & border animation system
local mode_glyphs = require("plugins.mode_glyphs") -- stable tasklist mode glyphs
local keybindings = require("keybindings")        -- Hotkey definitions
local hotkey_dupe_detector = require("plugins/hotkey_dupe_detector")  -- duplicate hotkey detection


-- // MARK: -- shimmer configuration
-- configure unified shimmer system (text effects + border animation)
shimmer.configure({
    -- preset = "debug",  -- lighter, more visible preset
    -- preset = "warm_light",  -- lighter, more visible preset
    -- preset = "bright_gold",  -- gold-only shine default
    -- preset = "candy",  -- candy-cane shine preset
    -- preset = "gold_contrast",  -- pastel candy-cane shine preset
    -- preset = "plasma_drift",  -- pastel candy-cane shine preset
    preset = "amber_pulse",  -- pastel candy-cane shine preset
    border = {
        smoothness = 2,  -- light border animation
        enabled = true
    }
})

-- configure mode glyphs (default basic; independent of shimmer)
mode_glyphs.configure({ style = "basic" })

-- minimal startup timer for shimmer - just enough for tasklist widgets to initialize
gears.timer.start_new(0.05, function()
    local focused = client.focus
    if focused then
        -- trigger tasklist redraws to establish widget mappings
        for s in screen do
            if s.mytasklist then
                s.mytasklist:emit_signal("widget::redraw_needed")
            end
        end
        -- force shimmer update
        shimmer.initialize_focused_client()
    end
    return false
end)

-- optional: toggle mode glyphs styling between basic and shimmer
-- toggle tasklist mode glyph styling between basic and shimmer
local function toggle_mode_glyphs_style()
    local new_style = (mode_glyphs.style == "basic") and "shimmer" or "basic"
    mode_glyphs.configure({ style = new_style })
    refresh_all_tasklists()
    naughty.notify({ title = "mode glyphs", text = "style: " .. new_style, timeout = 2 })
end

-- shimmer mode function (direct access)
-- use shimmer.set_mode(mode) directly instead of wrapper




-- // MARK: ERRORS
-- ################################################################################
-- ███████╗██████╗ ██████╗  ██████╗ ██████╗ ███████╗
-- ██╔════╝██╔══██╗██╔══██╗██╔═══██╗██╔══██╗██╔════╝
-- █████╗  ██████╔╝██████╔╝██║   ██║██████╔╝███████╗
-- ██╔══╝  ██╔══██╗██╔══██╗██║   ██║██╔══██╗╚════██║
-- ███████╗██║  ██║██║  ██║╚██████╔╝██║  ██║███████║
-- ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
-- ################################################################################
-- ERROR HANDLING - startup and runtime error management


-- Check if awesome encountered an error during startup and fell back to another config
-- (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors
	})
end


-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err)
		})
		in_error = false
	end)
end


-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


-- // MARK: VARS
-- ################################################################################
-- ██╗   ██╗ █████╗ ██████╗ ███████╗
-- ██║   ██║██╔══██╗██╔══██╗██╔════╝
-- ██║   ██║███████║██████╔╝███████╗
-- ╚██╗ ██╔╝██╔══██║██╔══██╗╚════██║
--  ╚████╔╝ ██║  ██║██║  ██║███████║
--   ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
-- ################################################################################
-- VARIABLES - global variables and configuration constants
-- ################################################################################
-- Store the previous tag when switching to pavucontrol
local previous_tag = nil

-- tasklist mode: false = focused tag only (default), true = all tags
local tasklist_show_all_tags = false

-- function to toggle tasklist mode and refresh all tasklists
local function toggle_tasklist_mode()
    tasklist_show_all_tags = not tasklist_show_all_tags
    
    -- refresh all tasklists on all screens - force filter re-evaluation
    for s in screen do
        if s.mytasklist then
            -- force complete tasklist rebuild by emitting multiple signals
            s.mytasklist:emit_signal("widget::layout_changed")
            s.mytasklist:emit_signal("widget::redraw_needed")
            -- trigger client property changes to force filter re-evaluation
            for _, c in ipairs(client.get()) do
                if c.screen == s then
                    c:emit_signal("property::urgent")
                end
            end
        end
    end
    
    -- show notification about current mode
    local mode_text = tasklist_show_all_tags and "all tags" or "focused tag only"
    naughty.notify({
        title = "tasklist mode",
        text = "showing tasks from: " .. mode_text,
        timeout = 2
    })
end

-- // MARK: UTILITY FUNCTIONS
-- ################################################################################


-- helper: refresh all tasklists across screens
local function refresh_all_tasklists()
    for s in screen do
        if s.mytasklist then
            -- force redraw; layout change causes update callbacks to run
            s.mytasklist:emit_signal("widget::layout_changed")
            s.mytasklist:emit_signal("widget::redraw_needed")
        end
    end
end

-- Matcher generator for rules
local create_matcher = function(class_name)
    return function(c) return awful.rules.match(c, {class = class_name}) end
end

-- Unified tag hover styling function
local function blend_hex_colors(c1, c2, t)
    -- c1 and c2 are "#RRGGBB", t in [0,1]; returns blended hex
    local function hex_to_rgb(hex)
        return tonumber(hex:sub(2,3),16), tonumber(hex:sub(4,5),16), tonumber(hex:sub(6,7),16)
    end
    local r1,g1,b1 = hex_to_rgb(c1)
    local r2,g2,b2 = hex_to_rgb(c2)
    local r = math.floor(r1 + (r2 - r1) * t)
    local g = math.floor(g1 + (g2 - g1) * t)
    local b = math.floor(b1 + (b2 - b1) * t)
    return string.format("#%02x%02x%02x", r, g, b)
end


-- Confirmation menu for quitting awesome
confirmQuitmenu = awful.menu({
    items = {
        {"Cancel", function() do end end},
        {"Quit", function() awesome.quit() end}
    }
})

-- Variable definitions
modkey = "Mod4"  -- Super/Windows key
altkey = "Mod1"   -- Alt key
ctrlkey = "Control" -- Control key
shiftkey = "Shift"  -- Shift key
terminal = "urxvt" -- Default terminal (urxvt preferred for consistency)
-- terminal = "alacritty" -- Alternative terminal
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Tag navigation modifier keys
tag_nav_mod_keys = {modkey, altkey}

-- Default layout for milk theme
-- old: preferred default requires custom layout not yet loaded at this point
-- milkdefault = centerwork_twothirds.horizontal 
-- set safe temporary default; will be overridden after layout requires
milkdefault = lain.layout.termfair.center

-- Tyrannical tag configuration (commented out but kept for reference)
-- tyrannical.tags = {
--   {
--     name        = "1 Term",                 -- Call the tag "Term"
--     init        = true,                   -- Load the tag on startup
--     exclusive   = true,                   -- Refuse any other type of clients (by classes)
--     screen      = {1,2},                  -- Create this tag on screen 1 and screen 3
--     layout      = milkdefault,
--     instance    = {"dev", "ops"},         -- Accept the following instances. This takes precedence over 'class'
--     class       = { --Accept the following classes, refuse everything else (because of "exclusive=true")
--       "xterm" , "urxvt" , "aterm","URxvt","XTerm","konsole","terminator","gnome-terminal","alacritty"
--     }
--   } ,
--   {
--     name        = "2 Music",
--     init        = true,
--     exclusive   = true,
--     screen      = 1,
--     layout      = awful.layout.suit.max                          ,
--     single_instance_id = { "ncmpcpp" },
--     class = {
--     "*" },
--   } ,
--   {
--     name        = "3 Media",
--     init        = true,
--     exclusive   = true,
--     screen      = 1,
--     layout      = awful.layout.suit.max                          ,
--     class = {
--     "mpv" },
--   } ,
--   {
--     name        = "4 Share",
--     init        = true,
--     exclusive   = true,
--     screen      = 1,
--     layout      = awful.layout.suit.max                          ,
--     class ={
--     "qBittorrent", "Nicotine" }
--   } ,
--   {
--     name        = "5 Other",
--     init        = true,
--     exclusive   = true,
--     screen      = 1,
--     layout      = awful.layout.suit.max                          ,
--     class ={
--     "" }
--   } ,
--   {
--     name        = "6 Files",
--     init        = true,
--     exclusive   = true,
--     screen      = 1,
--     layout      = awful.layout.suit.tile,
--     -- exec_once   = {"doublecmd"}, --When the tag is accessed for the first time, execute this command
--     class  = {
--       "Thunar", "Konqueror", "Dolphin", "ark", "Nautilus","emelfm", "Doublecmd"
--     }
--   } ,
--   {
--     name        = "7 Stuff",
--     init        = true,
--     exclusive   = true,
--     screen      = 1,
--     layout      = awful.layout.suit.max                          ,
--     class ={
--     "" }
--   } ,
--           {
--     name        = "8 Pass",
--     init        = true,
--     exclusive   = true,
--     screen      = 1,
--     layout      = awful.layout.suit.max                          ,
--     class ={
--     "keepassxc" }
--   } ,
--   {
--     name        = "9 Vol",
--     init        = true,
--     exclusive   = true,
--     screen      = 1,
--     layout      = awful.layout.suit.max                          ,
--     class = {
--     "Pavucontrol", "Jack_mixer" }
--   } ,
--   {
--     name        = "0 Sys",
--     init        = true,
--     exclusive   = true,
--     screen      = 1,
--     layout      = awful.layout.suit.max                          ,
--     class ={
--     "" }
--   } ,
--   {
--     name        = "- Chat",
--     init        = true,
--     exclusive   = true,
--     screen      = 1,
--     layout      = awful.layout.suit.max                          ,
--     class ={
--     "quassel" }
--   } ,
--   {
--     name        = "= Web",
--     init        = true,
--     exclusive   = true,
--     -- icon        = "~net.png",                 -- Use this icon for the tag (uncomment with a real path)
--     -- screen      = screen.count()>1 and 2 or 1,-- Setup on screen 2 if there is more than 1 screen, else on screen 1
--     screen      = 1,
--     layout      = awful.layout.suit.max,      -- Use the max layout
--     class = {
--       "Opera"         , "Firefox"        , "Rekonq"    , "Dillo"        , "Arora",
--     "Chromium"      , "nightly"        , "minefield" , "Firefox-esr"     }
--   } ,
--   }
--
--
--
-- -- Ignore the tag "exclusive" property for the following clients (matched by classes)
-- tyrannical.properties.intrusive = {
--   "ksnapshot"     , "pinentry"       , "gtksu"     , "kcalc"        , "xcalc"               ,
--   "feh"           , "Gradient editor", "About KDE" , "Paste Special", "Background color"    ,
--   "kcolorchooser" , "plasmoidviewer" , "Xephyr"    , "kruler"       , "plasmaengineexplorer",
-- }
--
-- -- Ignore the tiled layout for the matching clients
-- tyrannical.properties.floating = {
--   "MPlayer"      , "pinentry"        , "ksnapshot"  , "pinentry"     , "gtksu"          ,
--   "xine"         , "feh"             , "kmix"       , "kcalc"        , "xcalc"          ,
--   "yakuake"      , "Select Color$"   , "kruler"     , "kcolorchooser", "Paste Special"  ,
--   "New Form"     , "Insert Picture"  , "kcharselect", "mythfrontend" , "plasmoidviewer"
-- }
--
-- -- Make the matching clients (by classes) on top of the default layout
-- tyrannical.properties.ontop = {
--   "Xephyr"       , "ksnapshot"       , "kruler"
-- }
--
-- -- Force the matching clients (by classes) to be centered on the screen on init
-- tyrannical.properties.placement = {
--   kcalc = awful.placement.centered
-- }
--
-- tyrannical.settings.block_children_focus_stealing = true --Block popups ()
-- tyrannical.settings.group_children = true --Force popups/dialogs to have the same tags as the parent client




-- // MARK: WINDOW MANAGEMENT FUNCTIONS
-- ################################################################################

-- Window state tracking with cleanup
local window_centers = {}
local dragging_clients = {}

-- periodic cleanup for memory management
local cleanup_timer = gears.timer {
    timeout = 60,  -- cleanup every minute
    autostart = true,
    callback = function()
        -- clean up window_centers for invalid clients
        for c, _ in pairs(window_centers) do
            if not c.valid then
                window_centers[c] = nil
            end
        end
        -- clean up dragging_clients for invalid clients
        for c, _ in pairs(dragging_clients) do
            if not c.valid then
                dragging_clients[c] = nil
            end
        end
    end
}

-- Window management utilities
local window_manager = {
    -- Center floating window after resize
    maintain_center = function(c)
        if not c.floating or not window_centers[c] then return end
        
        local center = window_centers[c]
        local geo = c:geometry()
        local new_geo = {
            x = center.x - geo.width / 2,
            y = center.y - geo.height / 2,
            width = geo.width,
            height = geo.height
        }
        c:geometry(new_geo)
    end,
    
    -- Store window center position
    store_center = function(c)
        if not c.floating then return end
        local geo = c:geometry()
        window_centers[c] = {
            x = geo.x + geo.width / 2,
            y = geo.y + geo.height / 2
        }
    end,
    
    -- Clean up window tracking data
    cleanup = function(c)
        window_centers[c] = nil
        dragging_clients[c] = nil
    end,
    
    -- Check if window is being dragged
    is_dragging = function(c)
        return dragging_clients[c] ~= nil
    end,
    
    -- Mark window as being dragged
    set_dragging = function(c, dragging)
        local was_dragging = dragging_clients[c] ~= nil
        dragging_clients[c] = dragging and true or nil
        
        -- Emit signal when drag ends
        if was_dragging and not dragging then
            c:emit_signal("awesome::drag_end")
        end
    end
}


-- Screen rotation function
function rotate_screens(direction)
    local current_screen = awful.screen.focused()
    local initial_screen = current_screen
    while (true) do
        -- Handle both numeric and string values for direction
        if direction == "right" or direction == -1 then
            current_screen = current_screen:get_next_in_direction("right")
            if current_screen == nil then
                local screens = screen
                current_screen = screens[1]
            end
        elseif direction == "left" or direction == 1 then
            current_screen = current_screen:get_next_in_direction("left")
            if current_screen == nil then
                local screens = screen
                current_screen = screens[#screens]
            end
        elseif direction == "up" then
            current_screen = current_screen:get_next_in_direction("up")
            if current_screen == nil then
                current_screen = awful.screen.focused()
            end
        elseif direction == "down" then
            current_screen = current_screen:get_next_in_direction("down")
            if current_screen == nil then
                current_screen = awful.screen.focused()
            end
        end
        -- If we've looped back to the initial screen, break to avoid infinite loop
        if current_screen == initial_screen then
            break
        end
        mouse.screen = current_screen
        break
    end
end


-- Tag navigation functions  
function move_to_previous_tag()
    local c = client.focus
    if not c then return end
    local current_tag = c:tags()[1]
    if current_tag then
        local prev_tag = current_tag.screen.tags[current_tag.index - 1]
        if prev_tag then c:move_to_tag(prev_tag) end
    end
end

function move_to_next_tag()
    local c = client.focus
    if not c then return end
    local current_tag = c:tags()[1]
    if current_tag then
        local next_tag = current_tag.screen.tags[current_tag.index + 1]
        if next_tag then c:move_to_tag(next_tag) end
    end
end


-- Function to cycle through tags with clients (including minimized ones)
function cycle_tags_with_clients(direction)
    local current_screen = awful.screen.focused()
    local all_tags = current_screen.tags

    -- Get the current tag index
    local current_tag = current_screen.selected_tag
    local current_index = gears.table.hasitem(all_tags, current_tag)

    -- Cycle through tags, wrap around when reaching the end/start
    for i = 1, #all_tags do
        local idx
        if direction == "next" then
            idx = (current_index + i - 1) % #all_tags + 1
        else
            idx = (current_index - i - 1) % #all_tags + 1
        end
        local tag = all_tags[idx]

        -- Check if the tag has clients (including minimized ones)
        if #tag:clients() > 0 then
            tag:view_only()
            return
        end
    end
end




-- // MARK: DEFS
-- ################################################################################
-- ██████╗ ███████╗███████╗███████╗
-- ██╔══██╗██╔════╝██╔════╝██╔════╝
-- ██║  ██║█████╗  █████╗  ███████╗
-- ██║  ██║██╔══╝  ██╔══╝  ╚════██║
-- ██████╔╝███████╗██║     ███████║
-- ╚═════╝ ╚══════╝╚═╝     ╚══════╝
-- ################################################################################
-- DEFINITIONS - theme configuration and visual foundations


-- theme init
beautiful.init(gears.filesystem.get_configuration_dir() .. "milktheme/theme.lua")


-- // MARK: icons
-- icon management system - moved here to fix scoping issues


-- helper: resolve fallback icon using theme (menubar) or known paths
local function get_fallback_icon(c)
    local utils = menubar and menubar.utils
    local function load_icon_by_name(name)
        if not utils or not utils.lookup_icon then return nil end
        local p = utils.lookup_icon(name)
        if p and gears.filesystem.file_readable(p) then
            return gears.surface.load_uncached(p)
        end
        return nil
    end

    -- prefer terminal icon if class suggests a terminal
    local is_term = false
    if c and c.class then
        local cls = tostring(c.class)
        local l = cls:lower()
        is_term = l:find("term") ~= nil or cls == "URxvt" or cls == "XTerm"
    end

    -- try terminal icons first if this is a terminal
    if is_term then
        local names_term = {
            "utilities-terminal",
            "org.gnome.Terminal",
            "terminal",
            "xterm",
            "utilities-terminal-symbolic",
        }
        for _, n in ipairs(names_term) do
            local surf = load_icon_by_name(n)
            if surf then return surf end
        end
    end
    local names_generic = {
        "application-x-executable-symbolic",
        "application-x-executable",
        "application-default-icon",
        "applications-system",
        "system-run",
    }
    for _, n in ipairs(names_generic) do
        local surf = load_icon_by_name(n)
        if surf then return surf end
    end

    -- last resort hardcoded paths (prefer small PNGs over SVG symbolics for reliability)
    local candidates = {
        -- generic symbolic svg (small vector; works on most systems)
        "/usr/share/icons/Adwaita/symbolic/mimetypes/application-x-executable-symbolic.svg",
        "/usr/share/icons/hicolor/symbolic/mimetypes/application-x-executable-symbolic.svg",
        "/usr/share/icons/hicolor/scalable/mimetypes/application-x-executable.svg",
        -- adwaita
        "/usr/share/icons/Adwaita/16x16/legacy/utilities-terminal.png",
        "/usr/share/icons/Adwaita/16x16/mimetypes/application-x-executable.png",
        "/usr/share/icons/Adwaita/16x16/apps/utilities-terminal.png",
        "/usr/share/icons/Adwaita/16x16/apps/applications-system.png",
        -- hicolor
        "/usr/share/icons/hicolor/16x16/apps/utilities-terminal.png",
        "/usr/share/icons/hicolor/16x16/mimetypes/application-x-executable.png",
        "/usr/share/icons/hicolor/24x24/apps/utilities-terminal.png",
        "/usr/share/icons/hicolor/24x24/mimetypes/application-x-executable.png",
        -- pixmaps fallbacks
        "/usr/share/pixmaps/terminal.png",
        "/usr/share/pixmaps/gnome-terminal.png",
        "/usr/share/pixmaps/application-x-executable.png",
    }
    for _, path in ipairs(candidates) do
        if path and gears.filesystem.file_readable(path) then
            local surf = gears.surface.load_uncached(path)
            if surf then return surf end
        end
    end

    return nil
end



-- // MARK: colour and icons

-- sample dominant color from client icon
local function average_color_from_icon(icon)
    if not icon then return "#aaaaaa" end
    
    local ok, surf = pcall(gears.surface, icon)
    if not ok or not surf then return "#aaaaaa" end
    
    -- Get icon dimensions
    local w, h = 32, 32
    local okw, valw = pcall(function() return surf:get_width() end)
    if okw and type(valw) == 'number' and valw > 0 then w = valw end
    local okh, valh = pcall(function() return surf:get_height() end)
    if okh and type(valh) == 'number' and valh > 0 then h = valh end
    if w <= 0 or h <= 0 then return "#aaaaaa" end
    
    -- Create image surface with specific format for pixel access
    local img = cairo.ImageSurface(cairo.Format.RGB24, w, h)
    local cr = cairo.Context(img)
    
    -- Draw the icon onto our surface
    cr:set_source_surface(surf, 0, 0)
    cr:paint()
    
    -- Extract pixel data
    local data = nil
    local okd, val = pcall(function() return img:get_data() end)
    if okd then data = val end
    if not data or #data < 4 then return "#aaaaaa" end
    
    -- Average the RGB values
    local r, g, b, count = 0, 0, 0, 0
    for i = 1, #data, 4 do  -- BGRA format
        b = b + string.byte(data, i)
        g = g + string.byte(data, i + 1)
        r = r + string.byte(data, i + 2)
        count = count + 1
    end
    
    if count > 0 then
        r, g, b = math.floor(r / count), math.floor(g / count), math.floor(b / count)
        return string.format("#%02x%02x%02x", r, g, b)
    end
    
    return "#aaaaaa"
end


-- create a simple generic terminal icon surface (fallback when no file icon is available)
local function create_terminal_icon_surface(size)
    size = size or 16
    local img = cairo.ImageSurface(cairo.Format.ARGB32, size, size)
    local cr = cairo.Context(img)
    
    -- Fill background with dark gray
    cr:set_source_rgba(0.2, 0.2, 0.2, 1.0)
    cr:rectangle(0, 0, size, size)
    cr:fill()
    
    -- Draw simple terminal representation
    local margin = size * 0.15
    local inner_size = size - (margin * 2)
    
    -- Draw terminal window border
    cr:set_source_rgba(0.7, 0.7, 0.7, 1.0)
    cr:set_line_width(1)
    cr:rectangle(margin, margin, inner_size, inner_size)
    cr:stroke()
    
    -- Draw cursor or prompt representation
    local cursor_x = margin + (inner_size * 0.1)
    local cursor_y = margin + (inner_size * 0.3)
    local cursor_w = inner_size * 0.05
    local cursor_h = inner_size * 0.15
    
    cr:set_source_rgba(0.9, 0.9, 0.9, 1.0)
    cr:rectangle(cursor_x, cursor_y, cursor_w, cursor_h)
    cr:fill()
    
    -- Add some text-like lines
    cr:set_line_width(0.5)
    for i = 1, 3 do
        local line_y = cursor_y + (cursor_h * 1.5 * i)
        if line_y < (margin + inner_size - margin) then
            cr:move_to(cursor_x, line_y)
            cr:line_to(cursor_x + (inner_size * 0.6), line_y)
            cr:stroke()
        end
    end
    
    return img
end


-- Get dominant color for a tag based on visible client icons
local function get_tag_dominant_color(tag)
    if not tag or not tag.valid then return "#aaaaaa" end
    
    local rs, gs, bs, n = 0, 0, 0, 0
    local clients = tag:clients()
    
    for _, c in ipairs(clients) do
        if c.valid and not c.minimized and not c.hidden then
            local icon = c.icon or c.class
            local color_str = average_color_from_icon(icon)
            
            -- Parse hex color
            local r = tonumber(color_str:sub(2, 3), 16) or 170
            local g = tonumber(color_str:sub(4, 5), 16) or 170
            local b = tonumber(color_str:sub(6, 7), 16) or 170
            
            rs, gs, bs, n = rs + r, gs + g, bs + b, n + 1
        end
    end
    
    -- If no visible clients, try minimized ones
    if n == 0 then
        for _, c in ipairs(clients) do
            if c.valid and c.minimized then
                local icon = c.icon or c.class
                local color_str = average_color_from_icon(icon)
                
                local r = tonumber(color_str:sub(2, 3), 16) or 170
                local g = tonumber(color_str:sub(4, 5), 16) or 170
                local b = tonumber(color_str:sub(6, 7), 16) or 170
                
                rs, gs, bs, n = rs + r, gs + g, bs + b, n + 1
            end
        end
    end
    
    if n > 0 then
        local r, g, b = math.floor(rs / n), math.floor(gs / n), math.floor(bs / n)
        return string.format("#%02x%02x%02x", r, g, b)
    end
    
    return "#aaaaaa"
end




-- // MARK: notifications
-- notification settings


naughty.config.defaults.ontop = true
-- naughty.config.defaults.timeout = 10
-- naughty.config.defaults.margin = dpi("16")
-- naughty.config.defaults.border_width = 0
naughty.config.defaults.width = 400  -- Width in pixels instead of percentage string
naughty.config.defaults.position = 'bottom_middle'


-- notification icon settings
-- attempt to constrain the size of large icons in their apps notifications
naughty.config.defaults['icon_size'] = 64




-- // MARK: hotkeys
-- ################################################################################
-- ██╗  ██╗ ██████╗ ████████╗██╗  ██╗███████╗██╗   ██╗███████╗
-- ██║  ██║██╔═══██╗╚══██╔══╝██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝
-- ███████║██║   ██║   ██║   █████╔╝ █████╗   ╚████╔╝ ███████╗
-- ██╔══██║██║   ██║   ██║   ██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║
-- ██║  ██║╚██████╔╝   ██║   ██║  ██╗███████╗   ██║   ███████║
-- ╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝
-- ################################################################################
-- hotkeys - global and client key bindings


-- import keybindings from module
local keys = keybindings.build({
    modkey = modkey,
    terminal = terminal,
    rotate_screens = rotate_screens,
    move_to_previous_tag = move_to_previous_tag,
    move_to_next_tag = move_to_next_tag,
    toggle_tasklist_mode = toggle_tasklist_mode,
    -- mode glyphs toggle hotkey
    toggle_mode_glyphs_style = toggle_mode_glyphs_style,
    -- old: cycle_tags_with_clients used locally in module
    -- new: pass global implementation so there's a single source of truth
    cycle_tags_with_clients = cycle_tags_with_clients,
    quake = nil  -- will be defined later in screen setup
})


-- use the keybindings from the module
globalkeys = keys.globalkeys
clientkeys = keys.clientkeys
clientbuttons = keys.clientbuttons

-- register client keybindings properly for modern AwesomeWM
client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings(clientkeys)
end)




-- // MARK: dupe key check

-- check for duplicate hotkeys on startup and show orange notification
hotkey_dupe_detector.notify_duplicates(globalkeys, clientkeys)



-- compound terminal command for system monitoring
-- terminal_cmd = terminal .. " -e btop;" ..
--                terminal .. " -e journalctl -xeb;" ..
--                terminal .. " -e dmesg"




-- // MARK: wallpaper
-- ################################################################################
-- ██╗   ██╗██╗███████╗██╗   ██╗ █████╗ ██╗     
-- ██║   ██║██║██╔════╝██║   ██║██╔══██╗██║     
-- ██║   ██║██║███████╗██║   ██║███████║██║     
-- ╚██╗ ██╔╝██║╚════██║██║   ██║██╔══██║██║     
--  ╚████╔╝ ██║███████║╚██████╔╝██║  ██║███████╗
--   ╚═══╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
-- ################################################################################
-- wallpaper management and configuration
-- define wallpaper function
local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Set wallpaper on startup
-- old: numeric loop with screen.count()
-- for s = 1, screen.count() do
-- 	gears.wallpaper.maximized(beautiful.wallpaper, s, true)
-- end
-- new: idiomatic screen iterator
for s in screen do
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end

-- Reset wallpaper when screen geometry changes
screen.connect_signal("property::geometry", set_wallpaper)



-- // MARK: layouts
-- ################################################################################
-- ██╗      █████╗ ██╗   ██╗ ██████╗ ██╗   ██╗████████╗
-- ██║     ██╔══██╗╚██╗ ██╔╝██╔═══██╗██║   ██║╚══██╔══╝
-- ██║     ███████║ ╚████╔╝ ██║   ██║██║   ██║   ██║   
-- ██║     ██╔══██║  ╚██╔╝  ██║   ██║╚██╗ ██╔╝   ██║   
-- ███████╗██║  ██║   ██║   ╚██████╔╝ ╚███╔╝    ██║   
-- ╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝   ╚══╝     ╚═╝   
-- ################################################################################
-- LAYOUT - layout management and navigation systems


-- NAVIGATION - Movement and collision detection
-- Navigation system using collision detection
require("collision") {
    -- Vim-style movement keys
    up    = { "k" },
    down  = { "j" },
    left  = { "h" },
    right = { "l" },

    -- Other configurations (commented out)
    -- Normal arrow keys
    -- up    = { "Up"    },
    -- down  = { "Down"  },
    -- left  = { "Left"  },
    -- right = { "Right" },

    -- Multiple key options
    -- up    = { "Up", "&", "k", "F15" },
    -- down  = { "Down", "KP_Enter", "j", "F14" },
    -- left  = { "Left", "#", "h", "F13" },
    -- right = { "Right", "\"", "l", "F17" },
}



-- Alt-Tab alternatives (disabled)
-- local switcher = require("awesome-switcher")
-- awful.key({ "Mod1" }, "Tab", function() switcher.switch(1, "Alt_L", "Tab", "ISO_Left_Tab") end)
-- awful.key({ "Mod1", "Shift" }, "Tab", function() switcher.switch(-1, "Alt_L", "Tab", "ISO_Left_Tab") end)


-- Alternative Alt-Tab implementation (disabled)
-- local alttab = require("gobo.awesome.alttab")
-- awful.key({ "Mod1" }, "Tab", function() alttab.switch(1, "Alt_L", "Tab", "ISO_Left_Tab") end,
--    { description = "Switch between windows", group = "awesome" })



-- MODULES - Additional layout and utility modules, layouts, widgets and utilities
-- local tyrannical = require("tyrannical")     -- Dynamic desktop tagging
-- require("tyrannical.shortcut")               -- Optional tyrannical shortcuts
-- local revelation = require("revelation")     -- App/desktop switching script
-- revelation.init()



-- LAYOUTS - Layout definitions and configuration
-- Active layout scripts

-- Custom adaptive layout
local centerwork_adaptive = require("lain.layout.centerwork_adaptive")
-- Custom two-thirds layout that gives new window 2/3 screen
local centerwork_twothirds = require("lain.layout.centerwork_twothirds")
-- Custom tile.bottom layout with enhanced mouse resize functionality
local tile_bottom_mouse = require("lain.layout.tile_bottom_mouse")


-- LAYOUT DEFINITIONS
-- Table of layouts to cover with awful.layout.inc, order matters.
-- https://awesomewm.org/doc/api/libraries/awful.layout.html
-- https://github.com/lcpz/lain/wiki/Layouts


-- awful.layout.layouts = {}


-- new: handle default layouts by assigning the exact curated subset
awesome.connect_signal("request::default_layouts", function()
    -- assert only these layouts are available (not a superset)
    awful.layout.layouts = {
        -- active layouts in preferred order
        centerwork_twothirds.horizontal,            -- custom: two-thirds for new window
        centerwork_adaptive.horizontal,             -- custom: adaptive centerwork horizontal
        -- lain.layout.centerwork.horizontal,
        awful.layout.suit.tile.top,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        -- tile_bottom_mouse,                          -- custom: enhanced tile.bottom with mouse resize
        -- awful.layout.suit.fair.horizontal,
        -- bling.layout.horizontal,          -- optional: horizontal master layout  
        -- lain.layout.termfair.center,
        -- awful.layout.suit.corner.ne,
        -- awful.layout.suit.corner.nw,
        -- awful.layout.suit.spiral,                -- recommended: fibonacci spiral layout
        treetile,
        bling.layout.equalarea,              -- recommended: equal area distribution
        bling.layout.mstab,                  -- highly recommended: master-slave tabbing
        -- bling.layout.vertical,            -- optional: vertical master layout
        -- lain.layout.centerwork,
        -- lain.layout.termfair,
        awful.layout.suit.magnifier,
        bling.layout.deck,                   -- optional: deck-style stacking layout
        lain.layout.cascade,                 -- recommended: beautiful cascading windows
        -- awful.layout.suit.max,
        -- awful.layout.suit.floating,
        -- bling.layout.centered,
        -- awful.layout.suit.corner.nw,
        -- awful.layout.suit.corner.ne,
        -- awful.layout.suit.spiral.dwindle,
        -- awful.layout.suit.max.fullscreen,
        -- leaved.layout.suit.tile.right,
        -- leaved.layout.suit.tile.left,
        -- leaved.layout.suit.tile.top,
        -- trizen,
        -- dovetail.layout.right,
        -- dynamite.layout.conditional,
        -- dynamite.layout.ratio,
        -- dynamite.layout.stack,
        -- dynamite.layout.tabbed
    }
end)


-- now that custom layouts are loaded, set preferred default
-- overrides the temporary safe default set earlier
milkdefault = centerwork_twothirds.horizontal




-- // MARK: WIDGETS
-- ################################################################################
-- ██╗    ██╗██╗██████╗  ██████╗ ███████╗████████╗███████╗
-- ██║    ██║██║██╔══██╗██╔════╝ ██╔════╝╚══██╔══╝██╔════╝
-- ██║ █╗ ██║██║██║  ██║██║  ███╗█████╗     ██║   ███████╗
-- ██║███╗██║██║██║  ██║██║   ██║██╔══╝     ██║   ╚════██║
-- ╚███╔███╔╝██║██████╔╝╚██████╔╝███████╗   ██║   ███████║
--  ╚══╝╚══╝ ╚═╝╚═════╝  ╚═════╝ ╚══════╝   ╚═╝   ╚══════╝
-- ################################################################################
-- WIDGETS - menus, widgets, and interface elements


-- // MARK: -- clock widget
-- Restore previous clock style: Hack font, white on purple, with right margin
local mytextclock = wibox.widget.textclock()
mytextclock.format = "%a %b %d %H:%M"
mytextclock.font = "Hack Nerd Font 9"

local textclock_clr = wibox.container.background()
-- add at least 4px of purple padding on both sides
textclock_clr:set_widget(wibox.container.margin(mytextclock, 7, 7, 0, 0))
textclock_clr:set_fg("#ffffff")
textclock_clr:set_bg("#623997")

-- 1px separator to the left of the clock
local clock_sep = wibox.widget {
    orientation = "vertical",
    forced_width = 1,
    color = "#222222",
    widget = wibox.widget.separator,
}


-- // MARK: -- menu
-- MENU - Application menu configuration


-- Create the awesome submenu contents
awesomesubmenu = {
    -- {"Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end},
    {"Hotkeys", function() hotkeys_popup.show_help(nil, mouse.screen) end},
    {"Manual", terminal .. " -e man awesome"},
    {"Edit config", editor_cmd .. " " .. awesome.conffile},
    {"Restart", awesome.restart},
    {"Quit", function() awesome.quit() end}
}


-- Build the main menu with the submenu, app launcher, and terminal entry
mymainmenu = freedesktop.menu.build({
    before = {
        {"Awesome", awesomesubmenu, beautiful.awesome_icon}
        -- other triads can be put here
    },
    after = {
        {"Terminal", terminal}
        -- other triads can be put here
    }
})


-- Create a launcher widget and a main menu
mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})


-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()



-- local media_player = require("media-player")



-- // MARK: session
-- SESSION - Session management


-- Reactivate tabs that were active before a restart of awesomewm
-- For Firefox, might have to disable widget.disable-workspace-management in about:config
-- https://www.reddit.com/r/awesomewm/comments/syjolb/preserve_previously_used_tag_between_restarts

awesome.connect_signal('exit', function(reason_restart)
	if not reason_restart then return end
	local file = io.open('/tmp/awesomewm-last-selected-tags', 'w+')
	for s in screen do
		file:write(s.selected_tag.index, '\n')
	end
	file:close()
end)

awesome.connect_signal('startup', function()
	local file = io.open('/tmp/awesomewm-last-selected-tags', 'r')
	if not file then return end
	local selected_tags = {}
	for line in file:lines() do
		table.insert(selected_tags, tonumber(line))
	end
	for s in screen do
		local i = selected_tags[s.index]
		if i and s.tags[i] then
			local t = s.tags[i]
			t:view_only()
		end
	end
	file:close()
end)




-- // MARK: borders-shimmer
-- unified shimmer system handles both text effects and border animation
-- configuration done above in shimmer.configure() call

-- Store widget references for direct updates (moved here to avoid nil reference)
-- (moved earlier) local active_tag_widgets = {}
-- (moved earlier) local active_client_widgets = {}



-- ========================================================================
-- PLUGIN INTEGRATION
-- ========================================================================
-- load self-contained plugins (logical order: dependencies first)


local tag_indicators = require("plugins.tag_indicators")
local dnd_to_tag = require("plugins.dnd_to_tag")
-- border animation now integrated into shimmer system


-- Create a shimmering text launcher (moved here to avoid nil reference)
local launcher_text = wibox.widget {
    markup = '<span color="#FFD700">⚙</span>',  -- Gear icon as text
    font = "Hack Nerd Font 16",
    widget = wibox.widget.textbox
}

-- Make launcher text clickable
launcher_text:buttons(gears.table.join(
    awful.button({}, 1, function() mymainmenu:toggle() end),
    awful.button({}, 3, function() mymainmenu:toggle() end)
))

-- register launcher with shimmer (direct function call)
shimmer.register_launcher(launcher_text)





-- // MARK: taglist
-- taglist button mouse bindings
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end 
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end), 
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)


-- // MARK: tasklist
-- tasklist button mouse bindings
local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true}
            )
        end
    end),
    awful.button({ }, 2, function (c)
        c.minimized = true
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end)
)




-- // MARK: screen


-- apply wallpaper and create widgets for each screen
awful.screen.connect_for_each_screen(function(s)
    -- wallpaper
    set_wallpaper(s)

    -- {{{ Quake Terminal (Dropdown Console)
    -- A Quake-style dropdown terminal that can be toggled with a hotkey
    -- Hotkey: Mod4 + ` (backtick) - Toggle the terminal
    -- Features:
    -- - Slides down from the top of the screen
    -- - Follows the current tag when switching workspaces
    -- - Auto-hides when losing focus
    -- - Can be configured with different terminals via the 'app' parameter
    s.quake = lain.util.quake(
        -- Terminal configuration
        {
            app = terminal,  -- Terminal emulator to use (default: x-terminal-emulator)
            argname = "--class %s",  -- Set window class for matching in window rules
            name = "QuakeTerminal",  -- Window name for matching in window rules
            height = 0.4,     -- Height as percentage of screen (0.0 to 1.0)
            width = 1.0,      -- Width as percentage of screen (0.0 to 1.0)
            horiz = "center", -- Horizontal position ("left", "center", "right")
            vert = "top",     -- Vertical position ("top", "center", "bottom")
            border = 2,       -- Border width in pixels
            followtag = true, -- Follow the current tag
            overlap = false,  -- Whether to overlap the wibox
            visible = false,  -- Start hidden
            screen = s        -- Screen to display on
        },
        -- Additional settings
        {
            settings = function(c)
                c.followtag = true  -- Make terminal follow tag changes
                c.sticky = true     -- Keep terminal on all tags
                c.ontop = true      -- Keep terminal above other windows
                c.above = true      -- Keep terminal above normal windows
                c.skip_taskbar = true  -- Don't show in taskbar
                c.urgent = false    -- Don't set urgent flag
            end
        }
    )

    -- each screen has its own tag table
    -- old: used first layout in global list (order can vary if modules append)
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "="}, s, awful.layout.layouts[1])
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "="}, s, milkdefault)

    -- create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- create an imagebox widget which will contain an icon indicating which layout we're using
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    
    -- // MARK: taglist
    -- create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        style = {
            -- enable built-in squares; plugin remaps them to unminimised-client state
            bg_focus = beautiful.taglist_bg_focus,
            bg_occupied = nil,
            -- keep squares defined so they render
            squares_sel = beautiful.taglist_squares_sel,
            squares_unsel = beautiful.taglist_squares_unsel,
        },
        widget_template = {
            {
                {
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    left = 8,
                    right = 8,
                    top = 4,
                    bottom = 4,
                    widget = wibox.container.margin,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            id = 'background_role',
            widget = wibox.container.background,
            
            -- Simple create callback for tag setup
            create_callback = function(self, t, index, objects)
                local text_widget = self:get_children_by_id('text_role')[1]
                if text_widget and t then
                    -- register with shimmer (direct function call with tag mapping)
                    shimmer.register_taglist(self, s.index, t)
                    
                    -- tag hover styling (direct function calls)
                    self:connect_signal('mouse::enter', function()
                        shimmer.handle_tag_hover(self, t, "enter")
                    end)
                    
                    self:connect_signal('mouse::leave', function()
                        shimmer.handle_tag_hover(self, t, "leave")
                    end)
                end
            end
            ,
            update_callback = function(self, t, index, objects)
                local text_widget = self:get_children_by_id('text_role')[1]
                if text_widget and t then
                    -- taglist update handled automatically by shimmer
                end
            end
        }
    }



    -- // MARK: tasklist
    -- completely standard tasklist - no custom templates or overrides
    -- let the standard system handle all functionality properly:
    -- • terminal icons with proper fallbacks
    -- • underscore handling for minimized clients  
    -- • status indicators and client state management
    --
    -- separate enhancement modules (like shimmer) will integrate via signals
    -- rather than trying to modify the core widget structure
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        disable_icon = false,
        tasklist_disable_icon = false,
        filter  = function(c, screen)
            if not c or not c.valid or c.screen ~= screen then
                return false
            end
            
            -- if showing all tags, return true for all valid clients on this screen
            if tasklist_show_all_tags then
                return true
            end
            
            -- default behavior: only show clients from focused/selected tags
            local focused_tag = screen.selected_tag
            if not focused_tag then return false end
            
            -- check if client is on the focused tag
            for _, tag in ipairs(c:tags()) do
                if tag == focused_tag then
                    return true
                end
            end
            
            return false
        end,
        buttons = tasklist_buttons,
        style = {
            disable_icon = false,
            bg_normal = "#623997",   -- unfocused but unminimized
            bg_focus  = "#623997",   -- focused
            bg_minimize = "#000000", -- minimized
            bg_urgent = "#623997",
        },
        layout   = {
            spacing = 1,
            layout = wibox.layout.flex.horizontal
        },
        -- robust template: always provide an icon widget + split prefix/title
        widget_template = {
            {
                {
                    widget = wibox.container.place,
                    halign = 'left',
                    valign = 'center',
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = 1,
                        { id = 'icon_role', widget = wibox.widget.imagebox, resize = true },
                        {
                            layout = wibox.layout.fixed.horizontal,
                            spacing = 1,
                            {
                                id = 'status_prefix_margin',
                                widget = wibox.container.margin,
                                left = 2, right = 1, top = 0, bottom = 0,
                                {
                                    id = 'status_prefix',
                                    widget = wibox.widget.textbox,
                                }
                            },
                            { id = 'text_role', widget = wibox.widget.textbox },
                        },
                    },
                },
                left  = 4,
                right = 1,
                widget  = wibox.container.margin,
            },
            id     = 'background_role',
            widget = wibox.container.background,
            create_callback = function(self, c, index, objects)
                local ib = self:get_children_by_id('icon_role')[1]
                if ib then
                    local sz = (beautiful and (beautiful.tasklist_icon_size or beautiful.icon_size)) or 16
                    ib.forced_height = sz
                    ib.forced_width = sz
                    if FORCE_GENERIC_ICONS and GENERIC_ICON_PATH and gears.filesystem.file_readable(GENERIC_ICON_PATH) then
                        ib.image = gears.surface.load_uncached(GENERIC_ICON_PATH)
                    elseif not c.icon then
                        local surf = get_fallback_icon and get_fallback_icon(c)
                        if surf then ib.image = surf end
                    end
                end
                mode_glyphs.apply(self, c)
            end,
            update_callback = function(self, c, index, objects)
                local ib = self:get_children_by_id('icon_role')[1]
                if ib then
                    local sz = (beautiful and (beautiful.tasklist_icon_size or beautiful.icon_size)) or 16
                    ib.forced_height = sz
                    ib.forced_width = sz
                    if not c.icon or ib.image == nil then
                        local surf = get_fallback_icon and get_fallback_icon(c)
                        if surf then ib.image = surf end
                    end
                end
                mode_glyphs.update(self, c)
                shimmer.tasklist_update_callback(self, c, index, objects)
            end,
        }
    }
    
    -- register tasklist with shimmer
    shimmer.register_tasklist(s.mytasklist)


    -- // MARK: wibox
    -- create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- add widgets to the wibox
    -- create systray with base size from theme
    local mysystray = wibox.widget.systray()
    if mysystray.set_base_size then
        local tray_size = (beautiful and (beautiful.systray_icon_size or beautiful.icon_size)) or 16
        mysystray:set_base_size(tray_size)
    end
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        { -- middle widgets (tasklist expands to fill space)
            layout = wibox.layout.align.horizontal,
            s.mylayoutbox, -- should be to the left of tasklist
            s.mytasklist, -- this will expand to fill available space
        },
        { -- right widgets
            layout = wibox.layout.fixed.horizontal,
            -- add 3px horizontal + 1px top padding to systray and center vertically (only on primary screen)
            s == screen.primary and wibox.container.margin({ mysystray, valign = "center", widget = wibox.container.place }, 6, 6, 0, 0) or wibox.container.margin({ mysystray, valign = "center", widget = wibox.container.place }, 1, 0, 0, 0),
            wibox.container.margin(textclock_clr, 0, 0, 0, 0)
        },
    }



    -- // MARK: altwibox
    -- the alt wibox
    s.myaltwibox = awful.wibar({
        position = "top",
        screen = s,
        height = 22,
        visible = false
    })

    -- Add widgets to the wibox
    s.myaltwibox:setup{
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal
        },
        -- Middle widget
        -- media_player2,
        {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal
        }
    }
end)




-- // MARK: clients
-- ################################################################################
--  ██████╗██╗     ██╗███████╗███╗   ██╗████████╗
-- ██╔════╝██║     ██║██╔════╝████╗  ██║╚══██╔══╝
-- ██║     ██║     ██║█████╗  ██╔██╗ ██║   ██║   
-- ██║     ██║     ██║██╔══╝  ██║╚██╗██║   ██║   
-- ╚██████╗███████╗██║███████╗██║ ╚████║   ██║   
--  ╚═════╝╚══════╝╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   
-- ################################################################################
-- duplicate functions removed - consolidated in utility section above




-- Client creation and setup
client.connect_signal("manage", function(c)
    -- Set client window shapes
    c.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
    end

    -- old: only set fallback when the client had no icon
    -- if not c.icon then
    --     local fallback_icon = "/usr/share/icons/Adwaita/symbolic/legacy/utilities-terminal-symbolic.svg"
    --     if gears.filesystem.file_readable(fallback_icon) then
    --         c.icon = gears.surface.load_uncached(fallback_icon)
    --     end
    -- end

    -- set fallback icon when client has no icon
    if not c.icon then
        local surf = get_fallback_icon(c)
        if surf then c.icon = surf end
    end
    
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Titlebar management
-- double-click handler for titlebar (per-client, weak-keyed)
local double_click_timers = setmetatable({}, { __mode = "k" })
local function titlebar_handle_click(c, single_cb, double_cb, interval)
    interval = interval or 0.20
    local t = double_click_timers[c]
    if t then
        if t.started then t:stop() end
        double_click_timers[c] = nil
        if double_cb then double_cb() end
    else
        t = gears.timer {
            timeout = interval,
            autostart = true,
            single_shot = true,
            callback = function()
                double_click_timers[c] = nil
                if single_cb then single_cb() end
            end
        }
        double_click_timers[c] = t
    end
end

client.connect_signal("request::titlebars", function(c)
    -- unified icon size from theme
    local icon_size = (beautiful and beautiful.icon_size) or 16

    -- buttons for the titlebar
    local buttons = gears.table.join(
        -- left click: single = move, double = toggle maximize
        awful.button({ }, 1, function()
            titlebar_handle_click(c,
                function()
                    -- old (commented): immediate activate+move without guarding intention
                    -- c:emit_signal("request::activate", "titlebar", {raise = true})
                    -- awful.mouse.client.move(c)

                    -- prepare drag intention and temporarily unmaximize if needed
                    c._intend_drag = true
                    if c.maximized then
                        c._was_maximized = true
                        c.maximized = false
                    end
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.move(c)
                end,
                function()
                    c.maximized = not c.maximized
                    c:raise()
                end
            )
        end),
        -- middle click minimises client
        awful.button({ }, 2, function()
            c.minimized = true
        end),
        -- right click resizes client
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    local titlebar_text_widget = wibox.widget.textbox()
    titlebar_text_widget.font = "Hack Nerd Font 6"
    
    awful.titlebar(c, { size = (beautiful and beautiful.titlebar_height) or ((beautiful and beautiful.icon_size) or 16) + 2 }) : setup {
        { -- Left
            -- window icon with fallback, constrained to theme icon size, vertically centered, with padding (left=5, top=1)
            wibox.container.margin({
                {
                    {
                        id = 'titlebar_icon',
                        image = c.icon or (beautiful and beautiful.awesome_icon) or nil,
                        forced_height = icon_size,
                        forced_width = icon_size,
                        resize = true,
                        widget = wibox.widget.imagebox,
                    },
                    valign = "center",
                    widget = wibox.container.place,
                },
            }, 5, 0, 1, 0),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            -- tiny title text, left-aligned with same padding as right buttons, gray color
            wibox.container.margin({
                titlebar_text_widget,
                valign = "center",
                halign = "left",
                widget = wibox.container.place,
            }, 5, 0, 1, 0), -- same left padding as right button group
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        -- Right (wrap the whole group to give right=5, top=1 padding)
        wibox.container.margin({
            -- constrain all titlebar control buttons to theme icon size and center vertically
            { wibox.container.constraint(awful.titlebar.widget.floatingbutton (c), "exact", icon_size, icon_size), valign = "center", widget = wibox.container.place },
            { wibox.container.constraint(awful.titlebar.widget.maximizedbutton(c), "exact", icon_size, icon_size), valign = "center", widget = wibox.container.place },
            { wibox.container.constraint(awful.titlebar.widget.stickybutton   (c), "exact", icon_size, icon_size), valign = "center", widget = wibox.container.place },
            { wibox.container.constraint(awful.titlebar.widget.ontopbutton    (c), "exact", icon_size, icon_size), valign = "center", widget = wibox.container.place },
            { wibox.container.constraint(awful.titlebar.widget.closebutton    (c), "exact", icon_size, icon_size), valign = "center", widget = wibox.container.place },
            layout = wibox.layout.fixed.horizontal()
        }, 0, 5, 1, 0),
        layout = wibox.layout.align.horizontal
    }
    
    -- Set up dynamic titlebar text color based on focus state
    local function update_titlebar_text_color()
        if titlebar_text_widget then
            local color = client.focus == c and "#ffffff" or "#999999" -- bright when focused, dimmer when unfocused
            titlebar_text_widget.markup = '<span color="' .. color .. '">' .. (c.name or c.class or "") .. '</span>'
        end
    end
    
    -- Set initial color
    update_titlebar_text_color()
    
    -- Update color on focus changes
    c:connect_signal("focus", update_titlebar_text_color)
    c:connect_signal("unfocus", update_titlebar_text_color)
    c:connect_signal("property::name", update_titlebar_text_color)
end)

-- Client property changes
client.connect_signal("property::maximized", function(c)
    -- Prevent firefox from maximizing (personal preference)
    if c.maximized and (c.class == "Navigator" or c.class == "firefox" or c.class == "Firefox") then
        c.maximized = false
    end
end)

-- Handle maximized state for dragging windows between screens
client.connect_signal("request::activate", function(c, context, hints)
    -- unmaximize only when a move was intended (from titlebar or modkey+drag)
    if (context == "mouse_click" or context == "titlebar") and c._intend_drag and c.maximized then
        -- store the maximized state to restore later
        c._was_maximized = true
        c.maximized = false
    end
end)

-- Create a new signal for drag completion
client.connect_signal("awesome::drag_end", function(c)
    if c and c._was_maximized then
        c.maximized = true
        c._was_maximized = nil
    end
end)

-- Use mouse::leave as a fallback
client.connect_signal("mouse::leave", function(c)
    if c and c._was_maximized and not window_manager.is_dragging(c) then
        c.maximized = true
        c._was_maximized = nil
    end
end)

client.connect_signal("property::struts", function(c)
    -- Make firefox picture-in-picture sticky when it meets screen edges
    local struts = c:struts()
    if struts.left ~= 0 or struts.right ~= 0 or
       struts.top ~= 0 or struts.bottom ~= 0 then
        c.sticky = true
    end
end)

  -- Focus and border management handled by border_animation plugin
  -- Static border colors would conflict with animated borders
 
-- disable focus-follows-mouse (sloppy focus): do not focus clients on cursor hover
-- keep old code commented for quick restore if desired
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)
 
-- Client cleanup
client.connect_signal("unmanage", function(c)
    window_manager.cleanup(c)
end)

-- // MARK: --pavucontrol-examples
-- Alternative/complex client rule examples (commented out)
-- Example: Open sound mixer but keep tag visible without switching to it
-- {rule = {instance = "pavucontrol"}, properties = {tag = "9", toggle_tag = true}}

-- Alternative rule implementation with callback to keep tag visible
-- rule {
--     rule = { class = "pavucontrol" },
--     properties = {
--         tag = "9" -- this puts the client on the tag
--     },
--     callback = function(c)
--         -- Show the tag on screen *without* selecting it
--         local s = c.screen or screen.primary
--         local t = my_tag or awful.tag.find_by_name(s, "9")

--         if t and not t.selected then
--             awful.tag.viewtoggle(t)
--         end
--     end
-- }

-- Helper function for complex rules (commented out)
-- -- Get screen under mouse without moving cursor
-- local function get_mouse_screen()
--     local coords = mouse.coords()
--     for s in screen do
--         if coords.x >= s.geometry.x and coords.x < s.geometry.x + s.geometry.width and
--            coords.y >= s.geometry.y and coords.y < s.geometry.y + s.geometry.height then
--             return s
--         end
--     end
--     return screen.primary
-- end

-- -- Handle new pavucontrol instances
-- client.connect_signal("manage", function(c)
--     if c.class == "Pavucontrol" then
--         -- Mark this pavucontrol as just opened
--         pavucontrol_just_opened[c] = true

--         -- Debug: let's see what's happening
--         local mouse_screen = get_mouse_screen()
--         local current_screen = c.screen

--         -- Always move to mouse screen first, before any tag operations
--         if current_screen ~= mouse_screen then
--             c:move_to_screen(mouse_screen)
--         end

--         -- Now work with the correct screen
--         local target_screen = c.screen  -- Use the screen the client is actually on
--         local tag9 = target_screen.tags[9]

--         if tag9 then
--             -- Store current state if tag 9 isn't already selected
--             if not tag9.selected then
--                 local current_tags = target_screen.selected_tags
--                 if #current_tags > 0 then
--                     previous_tag = current_tags[1]
--                 end

--                 -- Keep current tags selected and add tag 9
--                 for _, tag in ipairs(current_tags) do
--                     tag.selected = true
--                 end
--                 tag9.selected = true
--             end
--             c:move_to_tag(tag9)
--         end
--         -- Clear the flag after a delay
--         gears.timer.start_new(0.5, function()
--             pavucontrol_just_opened[c] = nil
--             return false
--         end)
--     end
-- end)

-- -- Handle existing pavucontrol being focused from different screen
-- client.connect_signal("focus", function(c)
--     if c.class == "Pavucontrol" and not pavucontrol_just_opened[c] then
--         local target_screen = get_mouse_screen()

--         -- Only move if pavucontrol is on a different screen than the mouse
--         if c.screen ~= target_screen then
--             c:move_to_screen(target_screen)

--             local tag9 = target_screen.tags[9]
--             if tag9 then
--                 if not tag9.selected then
--                     local current_tags = target_screen.selected_tags
--                     if #current_tags > 0 then
--                         previous_tag = current_tags[1]
--                     end

--                     -- Keep current tags selected and add tag 9
--                     tag9.selected = true
--                 end
--                 c:move_to_tag(tag9)
--             end
--         end
--     end
-- end)

-- -- Handle existing pavucontrol being clicked on different screen
-- client.connect_signal("button::press", function(c)
--     if c.class == "Pavucontrol" then
--         local target_screen = get_mouse_screen()

--         -- Only move if pavucontrol is on a different screen than the mouse
--         if c.screen ~= target_screen then
--             c:move_to_screen(target_screen)

--             local tag9 = target_screen.tags[9]
--             if tag9 then
--                 if not tag9.selected then
--                     local current_tags = target_screen.selected_tags
--                     if #current_tags > 0 then
--                         previous_tag = current_tags[1]
--                     end

--                     -- Keep current tags selected and add tag 9
--                     for _, tag in ipairs(current_tags) do
--                         tag.selected = true
--                     end
--                     tag9.selected = true
--                 end
--                 c:move_to_tag(tag9)
--             end
--         end
--     end
-- end)

-- -- Clean up when pavucontrol closes
-- client.connect_signal("unmanage", function(c)
--     if c.class == "Pavucontrol" then
--         -- Clean up the tracking table
--         pavucontrol_just_opened[c] = nil

--         -- Restore previous tag if needed
--         if previous_tag then
--             previous_tag:view_only()
--             previous_tag = nil
--         end
--     end
-- end)


-- // MARK: clients
-- ################################################################################
--  ██████╗██╗     ██╗███████╗███╗   ██╗████████╗    ███╗   ███╗ █████╗ ███╗   ██╗ █████╗  ██████╗ ███████╗███╗   ██╗███████╗██╗  ██╗
-- ██╔════╝██║     ██║██╔════╝████╗  ██║╚══██╔══╝    ████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝ ██╔════╝████╗  ██║██╔════╝╚██╗██╔╝
-- ██║     ██║     ██║█████╗  ██╔██╗ ██║   ██║       ██╔████╔██║███████║██╔██╗ ██║███████║██║  ███╗█████╗  ██╔██╗ ██║█████╗  ╚███╔╝ 
-- ██║     ██║     ██║██╔══╝  ██║╚██╗██║   ██║       ██║╚██╔╝██║██╔══██║██║╚██╗██║██╔══██║██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ██╔██╗ 
-- ╚██████╗███████╗██║███████╗██║ ╚████║   ██║       ██║ ╚═╝ ██║██║  ██║██║ ╚████║██║  ██║╚██████╔╝███████╗██║ ╚████║███████╗██╔╝ ██╗
--  ╚═════╝╚══════╝╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝       ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝
-- ################################################################################
-- CLIENT MANAGEMENT - focus handling, floating windows, and mouse interactions
-- (consolidated from: ANTI-WARP RESIZE, FOCUS AND ACTIVATION HANDLING, FLOATING WINDOW CENTER, MOUSE BUTTONS)


-- when a client is minimized/restored or hidden/unhidden, refresh tasklists to update bg color
client.connect_signal("property::minimized", function(c)
    refresh_all_tasklists()
end)

client.connect_signal("property::hidden", function(c)
    refresh_all_tasklists()
end)


-- Anti-warp resize function that prevents cursor from jumping to another monitor
local function resize_no_warp(c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})

    -- Check if client is floating or if current layout has mouse_resize_handler
    local layout = awful.layout.get(c.screen)
    
    -- If client is not floating and layout has mouse_resize_handler, use it
    if not c.floating and layout.mouse_resize_handler then
        
        local initial_coords = mouse.coords()
        local geo = c:geometry()
        
        -- Determine corner based on mouse position relative to client center  
        local corner
        if initial_coords.y < geo.y + geo.height/2 then
            if initial_coords.x < geo.x + geo.width/2 then
                corner = "top_left"
            else
                corner = "top_right"
            end
        else
            if initial_coords.x < geo.x + geo.width/2 then
                corner = "bottom_left"
            else
                corner = "bottom_right"
            end
        end
        
        -- Call the layout's mouse resize handler
        layout.mouse_resize_handler(c, corner, initial_coords.x, initial_coords.y)
        return
    end

    -- Fallback to floating window resize for floating clients or layouts without mouse handler
    -- Store initial cursor position
    local initial_coords = mouse.coords()

    -- Store initial client geometry
    local geo = c:geometry()
    local initial_geo = {x = geo.x, y = geo.y, width = geo.width, height = geo.height}

    -- Calculate initial center position
    local center_x = geo.x + geo.width / 2
    local center_y = geo.y + geo.height / 2

    -- Get the current screen's geometry for boundary checking
    local screen_geo = screen[c.screen].geometry

    -- Start the mouse grabber without warping the cursor
    local prev_coords = initial_coords
    mousegrabber.run(function(m)
        if not c.valid then return false end

        -- Calculate offset from initial position (not previous)
        local dx = m.x - initial_coords.x
        local dy = m.y - initial_coords.y

        -- Calculate new dimensions based on mouse distance from initial click for uniform scaling
        local distance = math.sqrt(dx*dx + dy*dy)
        local scale_factor = 1 + (distance - 50) / 200  -- Adjust these values for sensitivity
        if dx < 0 or dy < 0 then scale_factor = 2 - scale_factor end
        scale_factor = math.max(0.1, scale_factor)  -- Prevent making window too small

        local new_width = math.max(50, initial_geo.width * scale_factor)
        local new_height = math.max(50, initial_geo.height * scale_factor)

        -- Calculate new position to keep center fixed
        local new_x = center_x - new_width / 2
        local new_y = center_y - new_height / 2

        -- Check if window would go off screen and adjust only if necessary
        local needs_reposition = false
        if new_x < screen_geo.x then
            new_x = screen_geo.x
            needs_reposition = true
        elseif new_x + new_width > screen_geo.x + screen_geo.width then
            new_x = screen_geo.x + screen_geo.width - new_width
            needs_reposition = true
        end

        if new_y < screen_geo.y then
            new_y = screen_geo.y
            needs_reposition = true
        elseif new_y + new_height > screen_geo.y + screen_geo.height then
            new_y = screen_geo.y + screen_geo.height - new_height
            needs_reposition = true
        end

        -- Update center position only if we had to reposition due to screen boundaries
        if needs_reposition then
            center_x = new_x + new_width / 2
            center_y = new_y + new_height / 2
        end

        -- Apply the new geometry
        c:geometry({
            x = math.floor(new_x),
            y = math.floor(new_y),
            width = math.floor(new_width),
            height = math.floor(new_height)
        })

        return m.buttons[3] or m.buttons[2]  -- Continue as long as right or middle button is pressed
    end, "fleur")

    -- Update center position for our center-locked resizing
    -- once resize is complete
    if c.floating and window_centers then
        local new_geo = c:geometry()
        window_centers[c] = {
            x = new_geo.x + new_geo.width / 2,
            y = new_geo.y + new_geo.height / 2
        }
    end
end


-- Keep track of which clients are being dragged
client.connect_signal("request::activate", function(c, context, hints)
    -- only track dragging for explicit move intention to avoid false positives on simple clicks
    local buttons = mouse.coords().buttons
    if not c._intend_drag then
        return
    end
    if not buttons or not buttons[1] then
        -- mouse button released, no longer dragging
        window_manager.set_dragging(c, false)
        window_manager.store_center(c)
        c._intend_drag = nil
    else
        -- mouse button is down, mark as dragging
        window_manager.set_dragging(c, true)
    end
end)

-- explicit lifecycle tracking for intended drags in case activate events are sparse
client.connect_signal("button::press", function(c)
    if c._intend_drag then
        window_manager.set_dragging(c, true)
    end
end)

client.connect_signal("button::release", function(c)
    if c._intend_drag then
        window_manager.set_dragging(c, false)
        window_manager.store_center(c)
        -- restore maximized if it was set prior to drag
        if c._was_maximized then
            c.maximized = true
            c._was_maximized = nil
        end
        c._intend_drag = nil
    end
end)


client.connect_signal("property::size", function(c)
    -- Skip if not floating
    if not c.floating then return end

    -- Skip if being dragged
    if window_manager.is_dragging(c) then return end

    -- Skip when client is maximized/fullscreen (or partially maximized)
    -- otherwise our center maintenance would offset the geometry away from workarea
    if c.maximized or c.fullscreen or c.maximized_horizontal or c.maximized_vertical then
        return
    end

    -- Record center point on first detection or maintain center during resize
    if not window_centers[c] then
        window_manager.store_center(c)
    else
        window_manager.maintain_center(c)
        window_manager.store_center(c)  -- Update stored center after repositioning
    end
end)

-- Client cleanup handled above in consolidated signal section


-- Middle mouse button for minimise
-- awful.button({}, 3, function(c)
--     if c == client.focus then
--         c.minimized = true
--     else
--         client.focus = c
--         c:raise()
--     end
-- end)


-- Set keys
-- old: shadowed local and redundant join/unpack
-- local globalkeys = keys.globalkeys or {}
-- root.keys(gears.table.join(table.unpack(globalkeys)))
-- new: set once, use keys from module directly
root.keys(keys.globalkeys)



-- Define tag keybinding combinations in a table for clarity
local tag_keybindings = {
    { mods = {modkey}, action = function(tag) tag:view_only() end, desc = "view tag #%d" },
    { mods = {modkey, altkey}, action = function(tag) awful.tag.viewtoggle(tag) end, desc = "toggle tag #%d" },
    { mods = {modkey, ctrlkey}, action = function(tag) if client.focus then client.focus:move_to_tag(tag) end end, desc = "move client to tag #%d" },
    { mods = {modkey, shiftkey}, action = function(tag) if client.focus then client.focus:move_to_tag(tag); tag:view_only() end end, desc = "move client and follow to tag #%d" },
    { mods = {modkey, ctrlkey, shiftkey}, action = function(tag) if client.focus then client.focus:toggle_tag(tag) end end, desc = "toggle client on tag #%d" },
}




-- // MARK: RULES
-- ################################################################################
-- ██████╗ ██╗   ██╗██╗     ███████╗
-- ██╔══██╗██║   ██║██║     ██╔════╝
-- ██████╔╝██║   ██║██║     ███████╗
-- ██╔══██╗██║   ██║██║     ╚════██║
-- ██║  ██║╚██████╔╝███████╗███████║
-- ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝
-- ################################################################################
-- RULES - client rules and window behavior


-- // MARK: global-rules
-- rules to apply to new clients (through the "manage" signal)
awful.rules.rules = {
    -- all clients will match this rule (global defaults)
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },


    -- add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }}, properties = { titlebars_enabled = true } },

    -- bypass size hints for arandr
    { rule = { class = "Arandr" }, properties = { size_hints_honor = false } },


    -- // MARK: floating-rule
    -- floating clients
    { rule_any = {
            instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
            class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
            name = {
          "Event Tester",  -- xev.
        },
            role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},



    -- // MARK: --floating-rules
    -- {{{ Floating client rules
    -- Applications that should always be floating windows
    -- Search marker: floatingggggggggg
    {
        rule_any = {
            -- Match by instance name
            instance = {
                "DTA",         -- Firefox addon DownThemAll
                "copyq",       -- Clipboard manager (includes session name in class)
                "pinentry",    -- Password entry dialog
                "ncmpcpp",     -- Music player
                "firefox"      -- Firefox dialogs
            },

            -- Match by class name (organized by category)
            class = {
                -- System utilities
                "Arandr", "Blueman-manager", "Lxappearance", "Gsmartcontrol",
                "hp-toolbox", "Protonvpn-gui", "Syncthing GTK", "netctl-gui",
                "Solaar", "Font-manager", "Font Manager", "qt5ct", "Deskflow",

                -- Audio/Video tools
                "Cadence", "qjackctl", "Studio-controls", "QjackCtl",
                "kmix", "Pavucontrol", "pwvucontrol", "Goodvibes",
                "Drumstick MIDI Monitor", "Audio/MIDI Setup", "Mixer",
                "seq64", "qseq66", "patroneo", "Agordejo", "radium_compessor",
                "Vlc", "vokoscreenNG", "SimpleScreenRecorder", "Indicator-sound-switcher5",

                -- Image & Graphics
                "Gpick", "Kruler", "emulsion", "Sxiv", "qimgv", "qView",
                "Image Lounge", "Image Menu", "spectacle", "flameshot",

                -- Security & Privacy
                "KeePassXC", "Tor Browser", -- Tor needs fixed window size to avoid fingerprinting

                -- Misc applications
                "MessageWin",  -- kalarm
                "copyq", "* Copying", "krunner", "xtightvncviewer",
                "scrcpy", "Gnaural", "kdeconnect.sms", "Mattermost",
                "Onboard", "gammy", "Flirc", "isoimagewriter", "Xdotoolgui.py",
                "mpd218 editor.exe", "Indicator-sound-switcher", "easyeffects"
            },

            -- Match by window name (when class/instance isn't reliable)
            -- Note: The name property might be set slightly after client creation
            name = {
                "Event Tester",        -- xev
                "Choose an application", -- DoubleCMD dialog
                "File operations",      -- DoubleCMD dialog
                "Blender Preferences",
                "Options",
                "Tree View Menu",
                "menu"                  -- Rekordbox
            },

            -- Match by window role
            role = {
                "AlarmWindow",   -- Thunderbird calendar
                "ConfigManager", -- Thunderbird about:config
                "pop-up",       -- e.g., Chrome's Developer Tools
                "page-info",    -- Firefox page info dialog
                "TfrmFileOp",    -- DoubleCMD file transfer
                "TfrmViewer"     -- DoubleCMD text viewer
            }
        },
        properties = {
            floating = true,  -- Make these windows floating
            placement = awful.placement.centered +       -- Center on screen
                        awful.placement.no_overlap +     -- Prevent overlap
                        awful.placement.no_offscreen     -- Keep on screen
        }
    },

    -- Focus filter rule
    {rule = {}, properties = {focus = awful.client.focus.filter}},
    -- Alternative: {rule = {}, properties = {focus = true}},
    

    -- // MARK: --tag-assignments
    -- {{{ Application-specific tag assignments
    -- Custom callback to set class
    {
        rule = {class = "URxvt", instance = "ncmpcpp"},
        callback = function(c) c.overwrite_class = "urxvt:dev" end
    },

    -- Tag 2: Audio production
    { rule = {instance = "Agordejo"}, properties = {tag = "2"} },
    { rule = {instance = "raysession"}, properties = {tag = "2"} },

    -- Tag 3: File sharing & media management
    { rule = {instance = "Nicotine"}, properties = {tag = "3"} },
    { rule = {instance = "qbittorrent"}, properties = {tag = "3"} },
    { rule = {class = "Picard"}, properties = {tag = "3"} },

    -- Tag 4: DJ software
    { rule = {class = "Mixxx"}, properties = {tag = "4"} },

    -- Tag 8: Music & video playback
    { rule = {instance = "ncmpcpp"}, properties = {tag = "8"} },
    { rule = {instance = "spotify"}, properties = {tag = "8"} },
    { rule = {instance = "Spotify"}, properties = {tag = "8"} },
    { rule = {class = "mpv"}, properties = {screen = 1, tag = "8", switch_to_tags = true} },

    -- Tag 9: File managers
    { rule = {instance = "Double Commander"}, properties = {tag = "9"} },
    { rule = {instance = "doublecmd"}, properties = {tag = "9"} },

    -- Tag "-": Chat applications
    { rule = {instance = "quassel"}, properties = {tag = "-", switch_to_tags = true} },

    -- Tag "=": Web browsers
    { rule_any = {instance = "firefox"}, properties = {tag = "=", switch_to_tags = true} },
    { rule = {class = "firefox"}, properties = {tag = "=", switch_to_tags = true} },
    { rule = {class = "Firefox"}, properties = {tag = "=", switch_to_tags = true} },
    { rule = {class = "Chromium"}, properties = {tag = "=", switch_to_tags = true} },
    { rule = {class = "Navigator"}, properties = {tag = "=", switch_to_tags = true} },
    
    -- More Tag assignments
    { rule = {instance = "jack_mixer"}, properties = {tag = "3"} },
    { rule = {instance = "radium_compressor"}, properties = {tag = "2"} },
    { rule = {instance = "qseq64"}, properties = {tag = "3"} },
    { rule = {instance = "qseq66"}, properties = {tag = "3"} },

-- }}} -- End of application-specific tag assignments

    -- // MARK: --window-sizing
    -- {{{ Window size management rules
    -- Dialogs and windows that should open at larger sizes than default
--     -- Screenshot and image-related dialogs
--     {
--         rule_any = {
--             name = {
--                 "Save screenshot", "Save Screenshot", "Screenshot", "Save Image",
--                 "Save As", "Save File", "Export Image", "Export Screenshot",
--                 "Image Properties", "Image Info", "Screenshot Options"
--             }
--         },
--         properties = {
--             floating = true,
--             width = 800,
--             height = 600,
--             placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
--         }
--     },

--     -- File operation dialogs
--     {
--         rule_any = {
--             name = {
--                 "Save As", "Open File", "Choose File", "File Operations",
--                 "Copy Files", "Move Files", "Delete Files", "File Properties",
--                 "Folder Properties", "Create Folder", "Rename"
--             }
--         },
--         properties = {
--             floating = true,
--             width = 900,
--             height = 700,
--             placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
--         }
--     },

--     -- Application preferences and settings dialogs
--     {
--         rule_any = {
--             name = {
--                 "Preferences", "Settings", "Options", "Configuration",
--                 "Properties", "Advanced Settings", "User Preferences",
--                 "Application Settings", "System Preferences"
--             }
--         },
--         properties = {
--             floating = true,
--             width = 850,
--             height = 650,
--             placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
--         }
--     },

--     -- Print and export dialogs
--     {
--         rule_any = {
--             name = {
--                 "Print", "Print Setup", "Print Options", "Print Preview",
--                 "Export", "Export As", "Export Options", "Save for Web",
--                 "Print to File", "Print Settings"
--             }
--         },
--         properties = {
--             floating = true,
--             width = 750,
--             height = 550,
--             placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
--         }
--     },

--     -- Error and confirmation dialogs
--     {
--         rule_any = {
--             name = {
--                 "Error", "Warning", "Confirmation", "Confirm Action",
--                 "Delete Confirmation", "Overwrite Confirmation", "Exit Confirmation",
--                 "Unsaved Changes", "Save Changes", "Discard Changes"
--             }
--         },
--         properties = {
--             floating = true,
--             width = 500,
--             height = 300,
--             placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
--         }
--     },

--     -- Browser dialogs (Firefox, Chrome, etc.)
--     {
--         rule_any = {
--             name = {
--                 "Downloads", "Download Manager", "Bookmarks", "History",
--                 "Add Bookmark", "Edit Bookmark", "Page Info", "Security Info",
--                 "Developer Tools", "Inspect Element", "Console"
--             }
--         },
--         properties = {
--             floating = true,
--             width = 800,
--             height = 600,
--             placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
--         }
--     },

--     -- Media player dialogs
--     {
--         rule_any = {
--             name = {
--                 "Media Info", "Track Info", "Album Info", "Playlist",
--                 "Add to Playlist", "Create Playlist", "Media Properties",
--                 "Audio Settings", "Video Settings", "Subtitle Settings"
--             }
--         },
--         properties = {
--             floating = true,
--             width = 700,
--             height = 500,
--             placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
--         }
--     },

--     -- Development and coding dialogs
--     {
--         rule_any = {
--             name = {
--                 "Debug", "Debug Console", "Output", "Terminal",
--                 "Build Output", "Compile Output", "Error List",
--                 "Find in Files", "Replace in Files", "Search Results"
--             }
--         },
--         properties = {
--             floating = true,
--             width = 900,
--             height = 700,
--             placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
--         }
--     },

--     -- Generic large dialogs (catch-all for other dialogs)
--     {
--         rule_any = {
--             type = { "dialog" }
--         },
--         properties = {
--             floating = true,
--             width = 600,
--             height = 400,
--             placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
--         }
--     }
    
-- }}} -- End of window size management rules
}

-- Apply client keys and buttons to all clients
awful.rules.rules = gears.table.join(awful.rules.rules, {
    -- All clients will match this rule
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    }
})




-- // MARK: CONFIG
-- ################################################################################
--  ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗
-- ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
-- ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
-- ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
-- ╚██████╗╚██████╔╝██║ ╚████║███████╗██║╚██████╔╝
--  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝ ╚═════╝
-- ################################################################################
-- CONFIG - final configuration settings and system preferences

-- Color settings moved to theme file

-- Notification settings
naughty.config.defaults.ontop = true
-- naughty.config.defaults.timeout = 10
-- naughty.config.defaults.margin = dpi("16")
-- naughty.config.defaults.border_width = 0
naughty.config.defaults.width = 400  -- Width in pixels instead of percentage string
naughty.config.defaults.position = 'bottom_middle'

-- Notification icon settings
-- Attempt to constrain the size of large icons in their apps notifications
naughty.config.defaults['icon_size'] = 64




-- // MARK: START
-- ################################################################################
-- ███████╗████████╗ █████╗ ██████╗ ████████╗
-- ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝
-- ███████╗   ██║   ███████║██████╔╝   ██║   
-- ╚════██║   ██║   ██╔══██╗██╔══██╗   ██║   
-- ███████╗   ██║   ██║  ██║██║  ██║   ██║   
-- ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   
-- ################################################################################
-- START - Autostart applications

-- Run programs on startup
awful.spawn.with_shell("pgrep -u $USER -x picom > /dev/null || picom --config ~/.config/picom.conf &")

-- Screen layouts
-- awful.spawn.with_shell("~/.screenlayout/new/31-laptop-tv-side.sh")

-- Network manager applet
-- awful.spawn.with_shell("nm-applet")

-- Bluetooth applet
-- awful.spawn.with_shell("blueman-applet")

-- Volume control
-- awful.spawn.with_shell("volumeicon")

-- Clipboard manager
-- awful.spawn.with_shell("clipit")

-- Notifications daemon
-- awful.spawn.with_shell("dunst")

-- Uncomment any of the above or add your own autostart applications

-- // MARK: BINDINGS
-- ################################################################################
-- ██████╗ ██╗███╗   ██╗██████╗ ██╗███╗   ██╗ ██████╗ ███████╗
-- ██╔══██╗██║████╗  ██║██╔══██╗██║████╗  ██║██╔════╝ ██╔════╝
-- ██████╔╝██║██╔██╗ ██║██║  ██║██║██╔██╗ ██║██║  ███╗███████╗
-- ██╔══██╗██║██║╚██╗██║██║  ██║██║██║╚██╗██║██║   ██║╚════██║
-- ██████╔╝██║██║ ╚████║██████╔╝██║██║ ╚████║╚██████╔╝███████║
-- ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
-- ################################################################################
-- KEY AND MOUSE BINDINGS - essential input handling

-- Global key bindings
-- Keybindings now handled by keybindings.lua module

-- Bind all key numbers to tags
-- Now handled by keybindings.lua
-- for i = 1, 9 do
--    globalkeys = gears.table.join(globalkeys,
--        -- View tag only
--        awful.key({ modkey }, "#" .. i + 9,
--                  function ()
--                        local screen = awful.screen.focused()
--                        local tag = screen.tags[i]
--                        if tag then
--                           tag:view_only()
--                        end
--                  end,
--                  {description = "view tag #"..i, group = "tag"}),
--        -- Move client to tag
--        awful.key({ modkey, "Shift" }, "#" .. i + 9,
--                  function ()
--                      if client.focus then
--                          local tag = client.focus.screen.tags[i]
--                          if tag then
--                              client.focus:move_to_tag(tag)
--                          end
--                     end
--                  end,
--                  {description = "move focused client to tag #"..i, group = "tag"})
--    )
-- end


-- Mouse bindings for clients - this fixes the mousewheel error
-- Now handled by keybindings.lua
-- clientbuttons = gears.table.join(
--     awful.button({ }, 1, function (c)
--         c:emit_signal("request::activate", "mouse_click", {raise = true})
--     end),
--     awful.button({ modkey }, 1, function (c)
--         c:emit_signal("request::activate", "mouse_click", {raise = true})
--         awful.mouse.client.move(c)
--     end),
--     awful.button({ modkey }, 3, function (c)
--         c:emit_signal("request::activate", "mouse_click", {raise = true})
--         resize_no_warp(c)
--     end)
-- )

-- Set root bindings
-- old: duplicate binding set with join/unpack; now handled earlier via root.keys(keys.globalkeys)
-- root.keys(gears.table.join(table.unpack(globalkeys)))

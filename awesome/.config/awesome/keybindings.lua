-- // MARK: HOTKEYS MODULE
-- ################################################################################
-- ██╗  ██╗ ██████╗ ████████╗██╗  ██╗███████╗██╗   ██╗███████╗
-- ██║  ██║██╔═══██╗╚══██╔══╝██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝
-- ███████║██║   ██║   ██║   █████╔╝ █████╗   ╚████╔╝ ███████╗
-- ██╔══██║██║   ██║   ██║   ██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║
-- ██║  ██║╚██████╔╝   ██║   ██║  ██╗███████╗   ██║   ███████║
-- ╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝
-- ################################################################################
--
-- KEYBINDINGS MODULE
--
-- This Lua module provides centralized keybinding management for Awesome WM.
-- It exports a single build() function that creates and returns keybinding tables.
--
-- STRUCTURE:
--   • Two separate keybinding systems:
--     - Global keys: work anywhere in the window manager (globalkeys table)
--     - Client keys: only work when a client window has focus (clientkeys table)
--
--   • Consistent table format for all keybindings:
--     {modifiers, key, function_or_string, description, class_name, group}
--     - modifiers: table of modifier keys (e.g., {modkey, shiftkey})
--     - key: string key name (e.g., "w", "Return", "F1")
--     - function_or_string: function to execute or shell command string
--     - description: human-readable description for help system
--     - class_name: optional window class for application matching
--     - group: category for organization in help system
--
-- USAGE:
--   local keybindings = require("keybindings")
--   local keys = keybindings.build({
--     modkey = "Mod4",
--     terminal = "urxvt",
--     rotate_screens = rotate_screens_function,
--     move_to_previous_tag = move_prev_function,
--     move_to_next_tag = move_next_function,
--     toggle_tasklist_mode = toggle_function,
--     quake = quake_terminal_object
--   })
--   
--   -- Use the returned tables:
--   root.keys(keys.globalkeys)
--   -- Client keys are applied via awful.rules in rc.lua
--
-- RETURNS:
--   {
--     globalkeys = table,    -- Global keybindings for root window
--     clientkeys = table,    -- Per-client keybindings
--     clientbuttons = table  -- Mouse button bindings for clients
--   }
--
-- ################################################################################

local gears = require("gears")
local awful = require("awful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local naughty = require("naughty")
local shimmer = require("plugins/shimmer") -- For shimmer mode functions

-- Matcher generator for rules
local create_matcher = function(class_name)
    return function(c) return awful.rules.match(c, {class = class_name}) end
end

-- Shimmer mode function - delegates to plugin
local function set_shimmer_mode(mode)
    shimmer.set_mode(mode)
end

-- Define modifier keys locally
local altkey = "Mod1"   -- Alt key
local ctrlkey = "Control" -- Control key
local shiftkey = "Shift"  -- Shift key


local M = {}

function M.build(ctx)
  assert(ctx and ctx.modkey, "keybindings.build: ctx.modkey is required")
  assert(ctx.terminal, "keybindings.build: ctx.terminal is required")
  assert(ctx.rotate_screens, "keybindings.build: ctx.rotate_screens is required")
  assert(ctx.move_to_previous_tag, "keybindings.build: ctx.move_to_previous_tag is required")
  assert(ctx.move_to_next_tag, "keybindings.build: ctx.move_to_next_tag is required")
  assert(ctx.toggle_tasklist_mode, "keybindings.build: ctx.toggle_tasklist_mode is required")

  local modkey = ctx.modkey
  local terminal = ctx.terminal
  local rotate_screens = ctx.rotate_screens
  local move_to_previous_tag = ctx.move_to_previous_tag
  local move_to_next_tag = ctx.move_to_next_tag
  local toggle_tasklist_mode = ctx.toggle_tasklist_mode
  local quake = ctx.quake  -- optional

  -- // MARK: SHIMMER CONTROLS
  local globalkeys = {}

  -- Helper function to add client keys from a table
  -- Standard structure: {modifiers, key, function, description, class_name, group}
  local function add_client_keys(keys_table)
    if not keys_table then return {} end
    
    local clientkeys = {}
    for _, key in ipairs(keys_table) do
      if key and type(key) == "table" and #key >= 4 then
        local modifiers = key[1]
        local key_name = key[2]
        local func = key[3]
        local description = key[4]
        local class_name = key[5]
        local group = key[6] or "client"
        
        if type(func) == "function" then
          table.insert(clientkeys, awful.key(modifiers, key_name, func, 
            {description = description, group = group}))
        end
      end
    end
    return clientkeys
  end

  -- Helper function to add multiple keys from a table
  -- Standard structure: {modifiers, key, function_or_string, description, class_name, group}
  local function add_keys(keys_table)
    if not keys_table then return end  -- Skip if table is nil
    
    for _, key in ipairs(keys_table) do
      if key and type(key) == "table" and #key >= 4 then  -- Ensure key is a valid table with enough elements
        local modifiers = key[1]
        local key_name = key[2]
        local func_or_string = key[3]
        local description = key[4]
        local class_name = key[5]  -- Optional, for window matching
        local group = key[6] or "awesome"
        
        if type(func_or_string) == "string" then
          if class_name then
            -- Special handling for F-key launchers with window matching
            local matcher = create_matcher(class_name)
            table.insert(globalkeys, awful.key(modifiers, key_name, function()
              awful.spawn.raise_or_spawn(func_or_string, nil, matcher, class_name)
            end, {description = description, group = group}))
          elseif group == "menu" then
            -- Special handling for menu keys that use os.execute
            table.insert(globalkeys, awful.key(modifiers, key_name, function()
              os.execute(func_or_string)
            end, {description = description, group = group}))
          else
            table.insert(globalkeys, awful.key(modifiers, key_name, function()
              awful.spawn.with_shell(func_or_string, false)
            end, {description = description, group = group}))
          end
        elseif type(func_or_string) == "function" then
          table.insert(globalkeys, awful.key(modifiers, key_name, func_or_string, 
            {description = description, group = group}))
        elseif type(func_or_string) == "number" then
          -- Handle special cases like rotation keys that pass numbers
          table.insert(globalkeys, awful.key(modifiers, key_name, function()
            rotate_screens(func_or_string)
          end, {description = description, group = group}))
        end
      end
    end
  end

  -- // MARK: NAVIGATION
  -- Basic navigation keys
  local nav_keys = {
    -- show help on mouse screen
    {{modkey}, "s", function() hotkeys_popup.show_help(nil, mouse.screen) end, "show help", nil, "awesome"},
    {{modkey}, "Left", function() awful.tag.viewprev() end, "view previous tag", nil, "tag"},
    {{modkey}, "Right", function() awful.tag.viewnext() end, "view next tag", nil, "tag"},
    {{modkey}, "Escape", function() awful.tag.history.restore() end, "go back", nil, "tag"},
    {{modkey}, "j", function() awful.client.focus.byidx(1) end, "focus next client", nil, "client"},
    {{modkey}, "k", function() awful.client.focus.byidx(-1) end, "focus previous client", nil, "client"},
    {{modkey}, "Tab", function() 
      awful.client.focus.history.previous()
      if client.focus then client.focus:raise() end
    end, "go back", nil, "client"}
  }

  -- // MARK: LAYOUT
  -- Layout manipulation keys
  local layout_keys = {
    {{modkey, shiftkey}, "j", function() awful.client.swap.byidx(1) end, "swap with next client", nil, "client"},
    {{modkey, shiftkey}, "k", function() awful.client.swap.byidx(-1) end, "swap with previous client", nil, "client"},
    {{modkey, ctrlkey}, "j", function() awful.screen.focus_relative(1) end, "focus next screen", nil, "screen"},
    {{modkey, ctrlkey}, "k", function() awful.screen.focus_relative(-1) end, "focus previous screen", nil, "screen"},
    {{modkey}, "u", function() awful.client.urgent.jumpto() end, "jump to urgent client", nil, "client"},
    {{modkey}, "l", function() awful.tag.incmwfact(0.05) end, "increase master width factor", nil, "layout"},
    {{modkey}, "h", function() awful.tag.incmwfact(-0.05) end, "decrease master width factor", nil, "layout"},
    {{modkey, shiftkey}, "h", function() awful.tag.incnmaster(1, nil, true) end, "increase number of master clients", nil, "layout"},
    {{modkey, shiftkey}, "l", function() awful.tag.incnmaster(-1, nil, true) end, "decrease number of master clients", nil, "layout"},
    {{modkey, ctrlkey}, "h", function() awful.tag.incncol(1, nil, true) end, "increase number of columns", nil, "layout"},
    {{modkey, ctrlkey}, "l", function() awful.tag.incncol(-1, nil, true) end, "decrease number of columns", nil, "layout"},
    {{modkey}, "r", function() awful.layout.inc(1) end, "select next layout", nil, "layout"},
    {{modkey, shiftkey}, "r", function() awful.layout.inc(-1) end, "select previous layout", nil, "layout"}
  }

  -- Program launchers
  local program_keys = {
    {{modkey}, "Return", function() awful.spawn(terminal) end, "open terminal", nil, "launcher"},
    {{modkey, ctrlkey}, "r", function() awesome.restart() end, "reload awesome", nil, "awesome"},
    {{modkey, shiftkey}, "q", function() awesome.quit() end, "quit awesome", nil, "awesome"},
    {{modkey, ctrlkey}, "n", function()
      local c = awful.client.restore()
      if c then c:emit_signal("request::activate", "key.unminimize", {raise = true}) end
    end, "restore minimized", nil, "client"},
    {{modkey}, "p", function() menubar.show() end, "show menubar", nil, "launcher"}
  }

  -- // MARK: PROMPT
  -- Prompt keys
  local prompt_keys = {
    {{modkey, ctrlkey}, "space", function()
      awful.screen.focused().mypromptbox:run()
    end, "run prompt", nil, "launcher"},
    {{modkey}, "x", function()
      awful.prompt.run {
        prompt = "Run Lua code: ",
        textbox = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
      }
    end, "lua execute prompt", nil, "awesome"}
  }

  -- Shimmer control keys in table format
  local shimmer_keys = {
    {{modkey, shiftkey, altkey}, "1", function() set_shimmer_mode("candle") end, "candle shimmer mode", nil, "shimmer"},
    {{modkey, shiftkey, altkey}, "2", function() set_shimmer_mode("cloud") end, "cloud shimmer mode", nil, "shimmer"},
    {{modkey, shiftkey, altkey}, "3", function() set_shimmer_mode("char_flicker") end, "character flicker shimmer mode", nil, "shimmer"},
    {{modkey, shiftkey, altkey}, "4", function() set_shimmer_mode("border_sync") end, "border sync shimmer mode", nil, "shimmer"},
    {{modkey, shiftkey, altkey}, "0", function() set_shimmer_mode("off") end, "turn off shimmer", nil, "shimmer"},
    {{modkey, shiftkey, altkey}, "5", function() set_shimmer_mode("deep_gold") end, "deep gold shimmer mode", nil, "shimmer"}
  }

  -- // MARK: F-KEY LAUNCHERS
  -- F-key application launchers
  local f_key_defs = {
    {{modkey}, "F1", "urxvt -e sh -c 'ncmpcpp' -name 'ncmpcpp'", "run ncmpcpp", "ncmpcpp", "launcher"},
    {{modkey, shiftkey}, "F1", "spotify", "run spotify", "spotify", "launcher"},
    {{modkey}, "F2", "raysession", "run raysession", nil, "launcher"},
    {{modkey, shiftkey}, "F2", "urxvt -e sh -c 'nsm'", "run argodejo in a terminal", "nsm", "launcher"},
    {{modkey}, "F3", "qbittorrent", "run qbittorrent", "qBittorrent", "launcher"},
    {{modkey, shiftkey}, "F3", "nicotine", "run nicotine++", nil, "launcher"},
    {{modkey}, "F4", "picard", "run picard", "Picard", "launcher"},
    {{modkey, shiftkey}, "F4", "simplescreenrecorder", "run simplescreenrecorder", nil, "launcher"},
    {{modkey, shiftkey}, "F6", "qseq66", "run qseq66", nil, "launcher"},
    {{modkey, shiftkey}, "F7", "signal-desktop", "run signal-desktop", nil, "launcher"},
    {{modkey}, "F8", "keepassxc ~/state/nextcloud/sync/keepassxc-mb.kdbx", "run keepassxc", "keepassxc", "launcher"},
    {{modkey}, "F9", "doublecmd", "run doublecmd", "doublecmd", "launcher"},
    {{modkey}, "F11", "quasselclient", "run quasselclient", "quasselclient", "launcher"},
    {{modkey}, "F12", "firefox", "run firefox", nil, "launcher"},
    {{modkey, shiftkey}, "F12", "chromium", "run chromium", nil, "launcher"}
  }
  
  -- // MARK: UTILITY
  -- Utility keys
  local utility_keys = {
    {{modkey}, "Print", "flameshot gui", "take a screenshot with flameshot", nil, "utility"},
    {{modkey, altkey}, "e", "emote", "run emote emoji picker", nil, "utility"},
    {{modkey, altkey}, "q", "xkill", "xkill to kill a hung gui app", nil, "utility"},
    {{modkey, altkey}, "c", "xcolor -s clipboard", "colour picker to clipboard", nil, "utility"},
    {{modkey, ctrlkey}, "a", "arandr", "run arandr", nil, "utility"}
  }
  
  -- // MARK: MENU
  -- Monitor and power menus
  local menu_keys = {
    {{modkey, altkey}, "r", "monitor_rofi.sh", "monitor Rofi menu", nil, "menu"},
    {{modkey, altkey}, "p", "rofi_power", "power Rofi menu", nil, "menu"}
  }
  
  -- // MARK: SCREEN ROTATION
  -- Screen rotation
  local rotation_keys = {
    {{modkey, altkey}, "Left", 1, "rotate screens left", nil, "screen"},
    {{modkey, altkey}, "Right", -1, "rotate screens right", nil, "screen"}
  }
  
  -- // MARK: TAG NAVIGATION
  -- Tag navigation without following
  local tag_nav_keys = {
    {{modkey, ctrlkey}, "Left", move_to_previous_tag, "move client to prev tag without follow", nil, "tag"},
    {{modkey, ctrlkey}, "Right", move_to_next_tag, "move client to next tag without follow", nil, "tag"}
  }

  -- // MARK: AUDIO
  -- Volume and audio control keys
  local audio_keys = {
    {{}, "XF86AudioLowerVolume", "vol-dec-all-3.sh", "decrease volume", nil, "hotkeys"},
    {{}, "XF86AudioRaiseVolume", "vol-inc-all-3.sh", "increase volume", nil, "hotkeys"},
    {{}, "XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", "toggle mute", nil, "hotkeys"}
  }
  
  -- // MARK: DENON
  -- Denon amplifier control keys
  local denon_keys = {
    {{modkey, ctrlkey, altkey}, "b", "funiculi --host 192.168.1.24 up", "Denon amp increase volume", nil, "hotkeys"},
    {{modkey, ctrlkey, altkey}, "g", "funiculi --host 192.168.1.24 down", "Denon amp decrease volume", nil, "hotkeys"},
    {{modkey, ctrlkey, altkey}, "v", "denon_toggle_source.sh", "Denon amp source set toggle", nil, "hotkeys"},
    {{modkey, ctrlkey, altkey}, "r", "denon_toggle_power.sh", "Denon amp power toggle", nil, "hotkeys"}
  }
  
  -- // MARK: MEDIA
  -- Media control keys (both custom and XF86)
  local media_keys = {
    {{modkey, ctrlkey}, "z", "playerctl previous", "media previous (custom)", nil, "media"},
    {{}, "XF86AudioPrev", "playerctl previous", "media previous", nil, "media"},
    {{modkey, ctrlkey}, "x", "playerctl play", "media play (custom)", nil, "media"},
    {{}, "XF86AudioPlay", "playerctl play", "media play", nil, "media"},
    {{modkey, ctrlkey}, "c", "playerctl play-pause", "media pause (custom)", nil, "media"},
    {{}, "XF86AudioPause", "playerctl play-pause", "media pause", nil, "media"},
    {{modkey, ctrlkey}, "d", "playerctl stop", "media stop (custom)", nil, "media"},
    {{}, "XF86AudioStop", "playerctl stop", "media stop", nil, "media"},
    {{modkey, ctrlkey}, "v", "playerctl next", "media next (custom)", nil, "media"},
    {{}, "XF86AudioNext", "playerctl next", "media next", nil, "media"}
  }
  
  -- // MARK: BRIGHTNESS
  -- Brightness control keys
  local brightness_keys = {
    {{}, "XF86MonBrightnessDown", "brillo -U 10", "decrease brightness", nil, "hotkeys"},
    {{modkey, altkey}, "XF86AudioLowerVolume", "brillo -U 10", "decrease brightness (alt)", nil, "hotkeys"},
    {{}, "XF86MonBrightnessUp", "brillo -A 10", "increase brightness", nil, "hotkeys"},
    {{modkey, altkey}, "XF86AudioRaiseVolume", "brillo -A 10", "increase brightness (alt)", nil, "hotkeys"}
  }
  
  -- // MARK: LAUNCHER
  -- Application launcher keys
  local launcher_keys = {
    {{modkey}, "space", "/home/milk/bin/rofi_nice", "rofi app launcher", nil, "launcher"},
    {{modkey, altkey}, "space", "/home/milk/bin/rofi_nice_run", "rofi command launcher", nil, "launcher"}
  }

  -- Add all the keys to globalkeys
  add_keys(nav_keys)
  add_keys(layout_keys)
  add_keys(program_keys)
  add_keys(prompt_keys)
  add_keys(shimmer_keys)
  add_keys(f_key_defs)
  add_keys(utility_keys)
  add_keys(menu_keys)
  add_keys(rotation_keys)
  add_keys(tag_nav_keys)
  
  -- Add system control keys to globalkeys
  add_keys(audio_keys)
  add_keys(denon_keys)
  add_keys(media_keys)
  add_keys(brightness_keys)
  add_keys(launcher_keys)
  
  -- // MARK: TAGS
  -- Generate tag keybindings using standardized table approach
  local tag_keys = {}
  for i = 1, 9 do
    -- View tag only
    table.insert(tag_keys, {
      {modkey}, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then tag:view_only() end
      end,
      "view tag #" .. i, nil, "tag"
    })
    
    -- Toggle tag display
    table.insert(tag_keys, {
      {modkey, ctrlkey}, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then awful.tag.viewtoggle(tag) end
      end,
      "toggle tag #" .. i, nil, "tag"
    })
    
    -- Move client to tag
    table.insert(tag_keys, {
      {modkey, shiftkey}, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then client.focus:move_to_tag(tag) end
        end
      end,
      "move focused client to tag #" .. i, nil, "tag"
    })
    
    -- Toggle tag on focused client
    table.insert(tag_keys, {
      {modkey, ctrlkey, shiftkey}, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then client.focus:toggle_tag(tag) end
        end
      end,
      "toggle focused client on tag #" .. i, nil, "tag"
    })
  end

  -- // MARK: WIBOX
  -- Toggle wibox visibility and tasklist mode
  local wibox_keys = {
    {{modkey, altkey}, "v", function()
      for s in screen do
        s.mywibox.visible = not s.mywibox.visible
      end
    end, "toggle wibox visibility", nil, "awesome"},
    {{modkey, altkey}, "t", toggle_tasklist_mode, "toggle tasklist mode (focused tag vs all tags)", nil, "awesome"}
  }

  -- Add standardized tag and wibox keys
  add_keys(tag_keys)
  add_keys(wibox_keys)



  -- // MARK: CLIENT

  -- Client key bindings in table format
  local client_key_defs = {
    {{modkey}, "f", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end, "toggle fullscreen", nil, "client"},
    
    {{modkey}, "w", function(c) 
      c:kill() 
    end, "close window", nil, "client"},
    
    {{modkey}, "z", function(c)
      awful.client.floating.toggle(c)
    end, "toggle floating", nil, "client"},
    
    {{modkey, ctrlkey}, "Return", function(c)
      c:swap(awful.client.getmaster())
    end, "move to master", nil, "client"},
    
    {{modkey}, "o", function(c)
      c:move_to_screen()
    end, "move to screen", nil, "client"},
    
    {{modkey}, "t", function(c)
      c.ontop = not c.ontop
    end, "toggle keep on top", nil, "client"},
    
    {{modkey}, "n", function(c)
      c.minimized = true
    end, "minimize window", nil, "client"},
    
    {{modkey}, "m", function(c)
      c.maximized = not c.maximized
      c:raise()
    end, "toggle maximize", nil, "client"},
    
    {{modkey, ctrlkey}, "m", function(c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end, "toggle vertical maximize", nil, "client"},
    
    {{modkey, shiftkey}, "m", function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end, "toggle horizontal maximize", nil, "client"}
  }
  



  -- // MARK: HELPERS

  -- Helper function for tag cycling
  local function cycle_tags_with_clients(direction)
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

  
  -- // MARK: MOUSE BINDINGS
  -- Mouse bindings for clients
  local awesome_dnd = require("plugins.awesome_dnd")
  local clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    -- Standard move behavior (between screens)
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    -- Drag to tag behavior (with shift modifier)
    awful.button({ modkey, shiftkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awesome_dnd.start_custom_drag(c, {follow_on_drop = true})
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
  )

  -- Client keys
  local clientkeys = {}
  
  -- Add client keys using standard add_keys function
  local function add_client_keys(keys_table)
    if not keys_table then return end
    for _, key in ipairs(keys_table) do
      if key and type(key) == "table" and #key >= 4 then
        local modifiers = key[1]
        local key_name = key[2]
        local func = key[3]
        local description = key[4]
        local group = key[6] or "client"
        
        if type(func) == "function" then
          table.insert(clientkeys, awful.key(modifiers, key_name, func,
            {description = description, group = group}))
        end
      end
    end
  end
  
  add_client_keys(client_key_defs)

  -- Join all global keys into a single table
  -- local all_global_keys = {}
  -- for _, key in ipairs(globalkeys) do
  --   table.insert(all_global_keys, key)
  -- end

  -- Return the constructed keybindings
  return {
    globalkeys = globalkeys,
    clientkeys = clientkeys,
    clientbuttons = clientbuttons
  }
end

return M
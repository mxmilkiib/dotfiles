-- { description = "", group = "" }),

-- AwesomeWM config
-- Milkiis rc.lua
-- https://github.com/mxmilkiib/dotfiles


-- Xephyr :1 -ac -br -noreset -screen 1152x720 & DISPLAY=:1.0 awesome -c ~/.config/awesome/rc.lua


-- If LuaRocks is installed, make sure that packages installed through it are
-- found otherwise do nothing
pcall(require, "luarocks.loader")


-- awful.spawn.with_shell(
--      'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
--      'xrdb -merge <<< "awesome.started:true";' ..
--      -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
--      'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"' -- https://github.com/jceb/dex
--      )


-- Standard awesomewm libraries
local gears = require("gears")
local gmath = require("gears.math")

local awful = require("awful")
require("awful.autofocus")

local wibox = require("wibox") -- Widget and layout library
local beautiful = require("beautiful") -- Theme handling library
local naughty = require("naughty") -- Notification library
local menubar = require("menubar")

local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


-- local switcher = require("awesome-switcher")
-- awful.key({ "Mod1",           }, "Tab",
-- function () switcher.switch( 1, "Alt_L", "Tab", "ISO_Left_Tab") end)
--
-- awful.key({ "Mod1", "Shift"   }, "Tab",
-- function () switcher.switch(-1, "Alt_L", "Tab", "ISO_Left_Tab") end)

-- local alttab = require("gobo.awesome.alttab")
   -- Switch windows
   -- awful.key({ "Mod1" }, "Tab",
   --    function()
   --       alttab.switch(1, "Alt_L", "Tab", "ISO_Left_Tab")
   --    end,
   --    { description = "Switch between windows", group = "awesome" }
   -- )
   -- awful.key({ "Mod1", "Shift" }, "Tab",
   --    function()
   --       alttab.switch(-1, "Alt_L", "Tab", "ISO_Left_Tab")
   --    end,
   --    { description = "Switch between windows backwards", group = "awesome" }
   -- )


-- Navigation system
require("collision") {
        -- --        Normal    Xephyr       Vim      G510
        -- up    = { "Up"    , "&"        , "k"   , "F15" },
        -- down  = { "Down"  , "KP_Enter" , "j"   , "F14" },
        -- left  = { "Left"  , "#"        , "h"   , "F13" },
        -- right = { "Right" , "\""       , "l"   , "F17" },
        --        Vim
        up    = { "k" },
        down  = { "j" },
        left  = { "h" },
        right = { "l" },
    }



---- Extra awesomewm scripts

-- local tyrannical = require("tyrannical")       -- Dynamic desktop tagging
-- require("tyrannical.shortcut") --optional

local lain = require("lain") -- Layouts, widgets, something
local cyclefocus = require("cyclefocus") -- Cycle between apps

-- local revelation = require("revelation") -- App/desktop switching script
-- revelation.init()


-- Create a menu from .desktop files
local freedesktop = require("freedesktop")

-- Window titlebar as widget
-- local fenetre = require("fenetre")
-- local titlebar = fenetre {
--   max_vert_button = "Shift",
--   max_horiz_button = "Control",
--   order = { "max", "ontop", "sticky", "floating", "close" }
-- }

-- Layout scripts
-- local dovetail = require("awesome-dovetail")
-- local thrizen = require("thrizen")

-- local leaved = require "awesome-leaved"
local treetile = require("treetile")

-- navigate tags as a grid
-- local workspace_grid = require("awesome-workspace-grid")
-- grid = workspace_grid({
--     rows = 3,
--     columns = 4,
--     cycle = true,
--     icon_size = 100,
--     position = "bottom_middle",
--     visual = true
-- })

-- local xrandr = require("xrandr")

-- Unified cross AwesomeWM window / Vim pane / Tmux pane hotkey navigation
-- only got 60% working before
-- require("awesomewm-vim-tmux-navigator"){
--         up    = {"Up", "k"},
--         down  = {"Down", "j"},
--         left  = {"Left", "h"},
--         right = {"Right", "l"},
--     }

-- local mpris_widget = require("awesome-wm-widgets.mpris-widget")
-- local mpris_widget = require("plugins.media")
-- local media_player = require("media-player")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back tocollision_focus_bg_center
-- another config (This code will only ever execute for the fallback config)
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
		-- Make sure we dont go into an endless erroR LOO
		-- p
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
-- }}}


-- Reactivate tabs that were active before a restart of awesomewm
-- For Firefox, might have to disable widget.disable-workspace-management in about:config
-- https://www.reddit.com/r/awesomewm/comments/syjolb/preserve_previously_used_tag_between_restarts/
awesome.connect_signal('exit', function(reason_restart) if not reason_restart then return end
local file = io.open('/tmp/awesomewm-last-selected-tags', 'w+')
for s in screen do file:write(s.selected_tag.index, '\n') end
file:close() end)
awesome.connect_signal('startup', function() local file = io.open('/tmp/awesomewm-last-selected-tags', 'r') if not file then return end
local selected_tags = {}
for line in file:lines() do table.insert(selected_tags, tonumber(line)) end
for s in screen do local i = selected_tags[s.index] local t = s.tags[i] t:view_only() end
file:close() end)


---- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "milktheme/theme.lua")

beautiful.wallpaper = awful.util.get_configuration_dir() ..
"milktheme/background.png"

beautiful.bg_systray = "#000000"
-- beautiful.bg_systray = "#191919"

-- theme.notification_bg = "#000000"
beautiful.notification_bg = "#000000"

beautiful.hotkeys_modifiers_fg = "#dddddd"

naughty.config.defaults.ontop = true
-- naughty.config.defaults.timeout = 10
-- naughty.config.defaults.margin = dpi("16")
-- naughty.config.defaults.border_width = 0
naughty.config.defaults.width = '40%'
naughty.config.defaults.position = 'bottom_middle'
-- Attempt to constrain the size of large icons in their apps notifications
beautiful.notification_icon_size = "64"
naughty.config.defaults['icon_size'] = 64


-- Sortout wallpaper(s)
for s = 1, screen.count() do
	gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then wallpaper = wallpaper(s) end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

screen.connect_signal("property::geometry", set_wallpaper)


-- This is used later as the default terminal and editor to run.
-- terminal = "urxvt"
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

terminal_cmd = terminal .. " -e btop;" .. terminal .. " -e journalctl -xeb;" ..
terminal .. " -e dmesg"


-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"
ctrlkey = "Control"
shiftkey = "Shift"


-- Table of layouts to cover with awful.layout.inc, order matters.
-- https://awesomewm.org/doc/api/libraries/awful.layout.html
-- https://github.com/lcpz/lain/wiki/Layouts
awful.layout.layouts = {

	awful.layout.suit.tile.top,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.corner.sw,
  awful.layout.suit.fair.horizontal,
	awful.layout.suit.corner.se,
  lain.layout.centerwork.horizontal,
	lain.layout.centerwork,
	awful.layout.suit.max,
	awful.layout.suit.floating,
  awful.layout.suit.magnifier,
	-- awful.layout.suit.fair,
	awful.layout.suit.tile,
	treetile,
	-- lain.layout.termfair.center,
	-- awful.layout.suit.corner.nw,

	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.spiral,
	-- awful.layout.suit.spiral.dwindle,

	-- awful.layout.suit.max.fullscreen,
		-- lain.layout.cascade,
	-- lain.layout.termfair,
		-- leaved.layout.suit.tile.right,
		-- leaved.layout.suit.tile.left,
		-- leaved.layout.suit.tile.bottom,
		-- leaved.layout.suit.tile.top,
	-- thrizen,
	-- dovetail.layout.right,
	-- dynamite.layout.conditional,
	-- dynamite.layout.ratio,
	-- dynamite.layout.stack,
	-- dynamite.layout.tabbe
}
-- }}}


---- {{{ Menu
-- Create the awesome submenu contents
awesomesubmenu = {
	{"hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end},
  {"manual", terminal .. " -e man awesome"},
	{"edit config", editor_cmd .. " " .. awesome.conffile},
	{"restart", awesome.restart}, {"quit", function() awesome.quit() end}
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

-- Add icon entries to desktop
-- for s in screen do
--   freedesktop.desktop.add_icons({screen = s})
-- end


-- {{{ Animate active borders in a cycling rainbow ish way

-- Gradient generator, adapted from https://krazydad.com/tutorials/makecolors.php
border_animate_colours = {}
function makeColorGradient(frequency1, frequency2, frequency3, phase1, phase2,
	phase3, center, width, len)
	if center == nil then center = 128 end
	if width == nil then width = 127 end
	if len == nil then len = 120 end
	genLoop = 0
	while genLoop < len do
		red = string.format("%02x", (math.floor(
		math.sin(frequency1 * genLoop + phase1) * width +
		center)))
		grn = string.format("%02x", (math.floor(
		math.sin(frequency2 * genLoop + phase2) * width +
		center)))
		blu = string.format("%02x", (math.floor(
		math.sin(frequency3 * genLoop + phase3) * width +
		center)))
		border_animate_colours[genLoop] = "#" .. red .. grn .. blu
		genLoop = genLoop + 1
	end
end

-- redFrequency = .11
-- grnFrequency = .17
-- bluFrequency = .21
-- redFrequency = .11
-- grnFrequency = .13
-- bluFrequency = .17
-- redFrequency = .1
-- grnFrequency = .2
-- bluFrequency = .3
-- redFrequency = .11
-- grnFrequency = .13
-- bluFrequency = .17

-- phase1 = 0
-- phase2 = 2
-- phase3 = 4
-- phase1 = 0
-- phase2 = 30
-- phase3 = 60

-- center = 128
-- width = 127
-- center = 210
-- width = 45
-- center = 180
-- width = 60
-- len = 800o

a = 0.8

redFrequency = 0.4718/a
grnFrequency = 0.1618/a
bluFrequency = 0.1/a
phase1 = 0
phase2 = 120
phase3 = 270


-- redFrequency = 0.5
-- grnFrequency = 0.5
-- bluFrequency = 0.5
-- phase1 = 1
-- phase2 = 1.5
-- phase3 = 1

-- center = 160
-- width = 90
-- center = 168
-- width = 88
center = 185
width = 65
len = 2600

makeColorGradient(redFrequency, grnFrequency, bluFrequency, phase1, phase2,
phase3, center, width, len)

-- makeColorGradient(.3,.3,.3,0,2,4)
-- makeColorGradient(.3,.3,.3,10,10,10)      -- black and white
-- makeColorGradient(.3,.3,.3,50,50,50)
-- makeColorGradient(.3,.3,.3,0,230,25)
-- makeColorGradient(.2,.2,.2,0,230,25)
-- makeColorGradient(.1,.1,.1,0,120,240)
-- makeColorGradient(.1,.2,.1,1,260,50)
-- makeColorGradient(.02,.03,.04,0,120,240,90,150,300)

borderLoop = 1
border_animation_timer = gears.timer {
	timeout = 0.08,
	call_now = true,
	autostart = true,
	callback = function()
		-- debug
		-- naughty.notify({ preset = naughty.config.presets.critical, title = "- " .. borderLoop .. " -", bg = border_animate_colours[borderLoop], notification_border_width = 0 })
		local c = client.focus
		if c then
	  		c.border_color = border_animate_colours[borderLoop]
			if not borderLoopReverse then
				borderLoop = borderLoop + 1
				if borderLoop >= len then
					borderLoopReverse = true
				end
			end
			if borderLoopReverse then
				borderLoop = borderLoop - 1
				if borderLoop <= 1 then borderLoopReverse = false end
			end
		end
	end
}

-- {{{ Window borders
-- client.connect_signal("focus", function(c) c.border_color = "#ecbc34" end)
client.connect_signal("focus", function(c)
	c.border_color = border_animate_colours[borderLoop]
end)

client.connect_signal("border_animation_timer:timeout", function(c)
	c.border_color = border_animate_colours[borderLoop]
end)

-- Make border transparent black on unfocus
-- only works if you have a compositor running
client.connect_signal("unfocus", function(c) c.border_color = "#00000000" end)


-- setup launcher wih icon and menu
mylauncher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = mymainmenu
})

-- menubar configuration
-- menubar.utils.terminal = terminal -- set the terminal for applications that require it
-- }}}

-- keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- create a textclock widget
mytextclock = wibox.widget.textclock()

local textclock_clr = wibox.widget.background()
textclock_clr:set_widget(mytextclock)
textclock_clr:set_fg("#ffffff")
textclock_clr:set_bg("#623997")

-- Create a wibox for each tag and add it
local taglist_buttons = gears.table.join(
awful.button({}, 1, function(t) t:view_only() end),
awful.button({modkey}, 1, function(t)
	if client.focus then client.focus:move_to_tag(t) end
end), awful.button({}, 3, awful.tag.viewtoggle),
awful.button({modkey}, 3, function(t)
	if client.focus then client.focus:toggle_tag(t) end
end), awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
awful.button({}, 5, function(t)
	awful.tag.viewprev(t.screen)
end)
)

-- Create wibox for all applications
local tasklist_buttons = gears.table.join(
awful.button({}, 1, function(c)
	if c == client.focus then
		c.minimized = true
	else
		c:emit_signal("request::activate", "tasklist", {raise = true})
	end
end),
awful.button({}, 2, function(c) c.minimized = true end),
awful.button({}, 3, function() awful.menu.client_list({theme = {width = 200}}) end),
awful.button({}, 4, function() awful.client.focus.byidx(-1) end),
awful.button({}, 5, function() awful.client.focus.byidx(1) end),
awful.button({}, 8, awful.client.movetoscreen),
awful.button({}, 9, function(c) c:kill() end)
)


-- fallback terminal icon in the taskbar when none is found
client.connect_signal("manage", function(c)
	local cairo = require("lgi").cairo
	local default_icon =
	"/usr/share/icons/hicolor/32x32/apps/displaycal-scripting-client.png"
	if c and c.valid and not c.icon then
		local s = gears.surface(default_icon)
		local img = cairo.ImageSurface.create(cairo.Format.ARGB32,
		s:get_width(), s:get_height())
		local cr = cairo.Context(img)
		cr:set_source_surface(s, 0, 0)
		cr:paint()
		c.icon = img._native
	end
end)


-- https://www.reddit.com/r/awesomewm/comments/gu4uek/how_to_move_client_to_nextprevious_tag
local function move_to_previous_tag()
	local c = client.focus
	if not c then return end
	local t = c.screen.selected_tag
	local tags = c.screen.tags
	local idx = t.index
	local newtag = tags[gmath.cycle(#tags, idx - 1)]
	c:move_to_tag(newtag)
	-- awful.tag.viewprev()
end

local function move_to_next_tag()
	local c = client.focus
	if not c then return end
	local t = c.screen.selected_tag
	local tags = c.screen.tags
	local idx = t.index
	local newtag = tags[gmath.cycle(#tags, idx + 1)]
	c:move_to_tag(newtag)
	-- awful.tag.viewnext()
end

-- local battery_widget = require("battery-widget")
-- local BAT0 = battery_widget { adapter = "BAT0", ac = "AC" }
-- local BAT0 = battery_widget {
--     ac = "AC",
--     adapter = "BAT0",
--     ac_prefix = " AC",
--     battery_prefix = "Bat",
--     percent_colors = {
--         { 25, "red"   },
--         { 50, "orange"},
--         {999, "green" },
--     },
--     listen = true,
--     timeout = 10,
--    widget_text = "${color_on}${AC_BAT}${percent}%${color_off} ",
--     -- widget_font = "Deja Vu Sans Mono 16",
--     widget_font = "Hack Regular 9",
--     tooltip_text = "Battery ${state}${time_est}\nCapacity: ${capacity_percent}%",
--     alert_threshold = 10,
--     alert_timeout = 0,
--     alert_title = "Low battery !",
--     alert_text = "${AC_BAT}${time_est}"
-- }

-- Re-set wallpaper when a screens geometry changes (e.g. different resolution)
-- screen.connect_signal("property::geometry", set_wallpaper)


-- {{{ Quake-like terminal
local quake = lain.util.quake(),

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Quake application
	-- s.quake = lain.util.quake()
	-- s.quake = quake({ app = "urxvt",argname = "-name %s",extra = "-title QuakeDD -e tmux new-session -A -s quake", visible = true, height = 0.9 })
	s.quake = lain.util.quake({app = terminal},
	{settings = function(c) c.followtag = true end})


	---- {{{ Tags
	-- Each screen has its own tag table.
	awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "="}, s,
	awful.layout.layouts[1])
	-- awful.tag({" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 ", " 0 ", " - ", " = "}, s,
	-- awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 ", " 0 ", " - ", " = " }, s, awful.layout.layouts[1])
	-- https://stackoverrun.com/de/q/11351467
	tags = {} -- Generates tags with custom names
	-- for s = 1, screen.count() do tags[s] = awful.tag({ "I", "II", "III", "IV", "V", "VI", "VII", "IX" }), end


	---- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout were using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
	awful.button({}, 1, function() awful.layout.inc(-1)	end),
  awful.button({}, 3, function() awful.layout.inc(1) end),
	awful.button({}, 4, function() awful.layout.inc(-1) end),
  awful.button({}, 5, function() awful.layout.inc(1) end)))

	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist {
		screen = s,
		filter = awful.widget.taglist.filter.noempty,
		widget = wibox.container.constraint,

		-- wtf syntax does this mean
		widget_template = {{{{{id = 'text_role', widget = wibox.widget.textbox}, layout = wibox.layout.fixed.horizontal	}, widget = wibox.container.place },
		left = 8,
		right = 8,
		widget = wibox.container.margin
	},
	-- spacing = 1,
	id = 'background_role',
	widget = wibox.container.background

},

-- layout = {
--     spacing = 5,
--     spacing_widget = {
--         color = "#000000",
--         shape = gears.shape.powerline,
--         widget = wibox.widget.separator,
--     },
--     layout = wibox.layout.fixed.horizontal,
--   -- margins = 3
-- },

buttons = taglist_buttons
		}

		-- Create a tasklist widget
		s.mytasklist = awful.widget.tasklist {
			screen = s,
			filter = awful.widget.tasklist.filter.currenttags,
			buttons = tasklist_buttons,
			widget = wibox.container.margin,

			layout = {
				-- spacing = 10,
				layout = wibox.layout.flex.horizontal
			},
			-- Notice that there is *NO* wibox.wibox prefix, it is a template,
			-- not a widget instance.
			widget_template = {{{{{
				id = 'icon_role',
				forced_width = 16,
				widget = wibox.widget.imagebox
			},
			margins = 4,
			widget = wibox.container.margin
		},
		{id = 'text_role', widget = wibox.widget.textbox},
		layout = wibox.layout.fixed.horizontal
	},
	left = 2,
	right = 2,
	widget = wibox.container.margin
},
id = 'background_role',
widget = wibox.container.background
			}
		}

		-- Create the wibox
		s.mywibox = awful.wibar({position = "top", screen = s})

		-- Add widgets to the wibox
		s.mywibox:setup{
			layout = wibox.layout.align.horizontal,
			{
				-- Left widgets
				layout = wibox.layout.fixed.horizontal,
				s.mytaglist,
				-- mykeyboardlayout,
				s.mypromptbox
			},
			s.mytasklist,
			-- Middle widget
			{
				-- Right widgets
				layout = wibox.layout.fixed.horizontal,
				titlebar,
				-- wibox.widget.systray(),
				wibox.container.margin(wibox.widget.systray(), 3, 3, 0, 0, "#000", false),
				-- mytextclock,
				-- BAT0,
				textclock_clr,
				wibox.container.margin(s.mylayoutbox, 0, 6, 0, 0, "#623997", false),
				mylauncher
			}
		}

		milkdefault = lain.layout.termfair.center

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
		--

		-- Setup the media player widget for the alternative wibar
		-- local media_player2 = media_player({
		--     -- icons  = {
		--     --     play   = theme.play,
		--     --     pause  = theme.pause
		--     -- },
		--     -- font         = theme.font,
		--     name         = "mpd", -- target media player
		--     refresh_rate = 1 -- interval between widget update calls
		--   }).widget


		-- the alt wibox
		s.myaltwibox = awful.wibar({
			position = "top",
			screen = s,
			height = 23,
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


	-- {{{ Mouse bindings
	root.buttons(gears.table.join(awful.button({}, 3,
	function() mymainmenu:toggle() end)
	-- awful.button({ }, 4, awful.tag.viewnext),
	-- awful.button({ }, 5, awful.tag.viewprev)
	))

	-- matcher generator for rules
	local create_matcher = function(class_name)
		return function(c) return awful.rules.match(c, {class = class_name}) end
	end

	-- https://www.reddit.com/r/awesomewm/comments/izn34y/awesomewmlua_noob_confirmation_on_quit_using
	confirmQuitmenu = awful.menu({
		items = {
			{"Cancel", function() do end end},
			{"Quit", function() awesome.quit() end}
		}
	})


	tag_nav_mod_keys = {modkey, altkey}


	-- https://github.com/awesomeWM/awesome/issues/3277#issuecomment-1026811823
	function rotate_screens(direction)
		local current_screen = awful.screen.focused()
		local initial_scren = current_screen
		while (true) do
			awful.screen.focus_relative(direction)
			local next_screen = awful.screen.focused()
			if next_screen == initial_scren then
				return
			end

			local current_screen_tag_name = current_screen.selected_tag.name
			local next_screen_tag_name = next_screen.selected_tag.name

			for _, t in ipairs(current_screen.tags) do
				local fallback_tag = awful.tag.find_by_name(next_screen, t.name)
				local self_clients = t:clients()
				local other_clients

				if not fallback_tag then
					-- if not available, use first tag
					fallback_tag = next_screen.tags[1]
					other_clients = {}
				else
					other_clients = fallback_tag:clients()
				end

				for _, c in ipairs(self_clients) do
					c:move_to_tag(fallback_tag)
				end

				for _, c in ipairs(other_clients) do
					c:move_to_tag(t)
				end
			end
			awful.tag.find_by_name(next_screen, current_screen_tag_name):view_only()
			awful.tag.find_by_name(current_screen, next_screen_tag_name):view_only()
			current_screen = next_screen
		end
	end


-- Function to cycle through tags with clients (including minimized ones)
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



	-- {{{ Key bindings
globalkeys = gears.table.join(

	-- Show hotkey help popup dialog window
	awful.key({modkey}, "s", hotkeys_popup.show_help,
	{description = "show help", group = "awesome"}),

	awful.key({modkey, ctrlkey}, "b", function() os.execute("sleep 1; xset dpms force off")
	end, {description = "blank screen(s) temporarily", group = "awesome"}),

	awful.key({modkey}, "g", function() awful.screen.focused().quake:toggle()
	end, {description = "dropdown quake-like terminal", group = "launcher"}),

	awful.key({modkey, altkey}, "r", function() os.execute("monitor_rofi.sh") end,
  { description = "monitor Rofi menu", group = "awesome" }),

	awful.key({modkey, altkey}, "p", function() os.execute("rofi_power") end,
  { description = "power Rofi menu", group = "awesome" }),


-- Tags related keybindings

  -- Switch to prev/next tag
  -- awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
  -- {description = "view previous", group = "tag"}),
  -- awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
  -- {description = "view next", group = "tag"}),
  -- awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
  -- {description = "go back", group = "tag"}),

  -- Cycle back and forth through tags with clients
  awful.key({ modkey  }, "Left", function() cycle_tags_with_clients("prev")
  end, {description = "cycle to previous tag with clients", group = "tag"}),

  awful.key({ modkey  }, "Right", function() cycle_tags_with_clients("next")
  end, {description = "cycle to next tag with clients", group = "tag"}),

  -- Cycle back and forth only through tags with unminimised clients
  awful.key({ modkey, ctrlkey }, "Left",
  function ()
    -- tag_view_nonempty(-1)
    local focused = awful.screen.focused()
    for i = 1, #focused.tags do
      awful.tag.viewidx(-1, focused)
  if #focused.clients > 0 then
        return
      end
    end
  end,
  {description = "view previous non-empty tag", group = "tag"}),

  awful.key({ modkey, ctrlkey }, "Right",
  function ()
    -- tag_view_nonempty(1)
    local focused = awful.screen.focused()
    for i = 1, #focused.tags do
      awful.tag.viewidx(1, focused)
      if #focused.clients > 0 then
        return
      end
    end
  end,
  {description = "view next non-empty tag", group = "tag"}),


	-- awful.key(tag_nav_mod_keys, "Up", function() grid:navigate("up") end,	{description = "Up", group = "Tag"}),
	-- awful.key(tag_nav_mod_keys, "Down",	function() grid:navigate("down") end,	{description = "Down", group = "Tag"}),
	-- awful.key(tag_nav_mod_keys, "Left",	function() grid:navigate("left") end,	{description = "Left", group = "Tag"}),
	-- awful.key(tag_nav_mod_keys, "Right", function() grid:navigate("right") end,	{description = "Right", group = "Tag"}),


  -- modkey+Tab: cycle through all clients.
  awful.key({modkey}, "Tab", function(c) cyclefocus.cycle({modifier = "Super_L"}) end,
  { description = "cycle through clients", group = "client" }),

  -- modkey+Shift+Tab: backwards
  awful.key({modkey, shiftkey}, "Tab", function(c) cyclefocus.cycle({modifier = "Super_L"}) end,
  { description = "cycle backward through clients", group = "client" }),


	-- Cycle/switch through minimised windows
	awful.key({modkey}, ";", function()
		if client.focus then
			local c = client.focus
			local nxt = nil
			for x in awful.client.iterate(function(x)
				return x.minimized
			end) do
			if nxt then
				nxt:swap(x)
			else
				nxt = x
			end
		end
		c.minimized = true
		nxt.minimized = false
		c:swap(nxt)
		client.focus = nxt
	end
end, {description = "switch focused client with minimized", group = "tag"}),


	-- Restore all minimized clients
	awful.key({modkey, ctrlkey}, "n", function()
		local tag = awful.tag.selected()
		for i = 1, #tag:clients() do
			tag:clients()[i].minimized = false
			tag:clients()[i]:redraw()
		end
	end, {description = "restore last minimized client", group = "tag"}),


-- Default client focus
-- awful.key({modkey}, "j", function()
--   awful.client.focus.byidx(1)
--   if client.focus then client.focus:raise() end
-- end, {description = "focus next by index", group = "client"}),

-- awful.key({modkey}, "k", function()
--   awful.client.focus.byidx(-1)
--   if client.focus then client.focus:raise() end
-- end, {description = "focus previous by index", group = "client"}),


-- -- Focus on next window on current tag
-- awful.key({modkey}, "j", function() awful.client.focus.byidx(1) end,
--           {description = "focus next by index", group = "client"}),

-- -- Focus on previous window on current tag
-- awful.key({modkey}, "k", function() awful.client.focus.byidx(-1) end,
--           {description = "focus previous by index", group = "client"}),

-- -- Focus by direction, easier on some layouts
-- awful.key({ modkey }, "j",
--         function()
--             awful.client.focus.bydirection("down")
--             if client.focus then client.focus:raise() end
--         end),
--     awful.key({ modkey }, "k",
--         function()
--             awful.client.focus.bydirection("up")
--             if client.focus then client.focus:raise() end
--         end),
--     awful.key({ modkey }, "h",
--         function()
--             awful.client.focus.bydirection("left")
--             if client.focus then client.focus:raise() end
--         end),
--     awful.key({ modkey }, "l",
--         function()
--             awful.client.focus.bydirection("right")
--             if client.focus then client.focus:raise() end
--         end),

awful.key({modkey}, "0", awful.tag.viewidx(10)),

-- Jump between current and previous window on whatever tag
awful.key({modkey}, "Escape", awful.tag.history.restore,
{description = "go back", group = "tag"}),

-- Trigger relevation script to display and number all windows for quick switch
-- awful.key({modkey, ctrlkey}, "space", revelation, -- Show awesome menu
-- {	description = "revelation window switcher",	group = "awesome" }),

-- awful.key({modkey, ctrl}, "w", function() mymainmenu:show() end,
-- {description = "show main menu", group = "awesome"}),


-- Layout manipulation
awful.key({modkey, shiftkey}, "j", function() awful.client.swap.byidx(1) end, {
description = "swap with next client by index", group = "client" }),

awful.key({modkey, shiftkey}, "k", function() awful.client.swap.byidx(-1) end,
{ description = "swap with previous client by index", group = "client" }),


-- Change screen focus
awful.key({ modkey, ctrlkey }, "j", function () awful.screen.focus_relative( 1) end,
{description = "focus the next screen", group = "screen"}),

awful.key({modkey, ctrlkey }, "k", function() awful.screen.focus_relative(-1) end,
{description = "focus the previous screen", group = "screen"}),



-- awful.key({modkey}, "o", function() awful.screen.focus_relative(1) end,
-- { description = "focus the next screen", group = "screen" }),

-- Move window between monitor outputs
-- awful.key({ modkey, shiftkey  }, "o",      function (c) c:move_to_screen()               end,
-- awful.key({modkey, shiftkey}, "o", awful.client.movetoscreen,
-- {description = "move to next screen", group = "client"}),

-- awful.key({ modkey, ctrlkey, shiftkey }, "k", function (c) c:move_to_screen(c.screen.index - 1) end,
-- {description = "move to screen left", group = "client"}),
-- awful.key({ modkey, ctrlkey, shiftkey }, "j", function (c) c:move_to_screen(c.screen.index + 1) end,
-- { description = "move to screen right", group = "client"}),


awful.key({modkey, altkey}, "j", function() rotate_screens(1) end,
{description = "rotate screens left", group = "screen"}),

awful.key({modkey, altkey}, "k", function() rotate_screens(-1) end,
{ description = "rotate screens right", group = "screen" }),


awful.key({modkey}, "u", awful.client.urgent.jumpto,
{ description = "jump to urgent client", group = "client" }),


-- emulate alt-tab behaviour
-- awful.key({"Mod1"}, "Tab", function() switcher.switch(1, "Mod1", "Alt_L", "Shift", "Tab") end,
-- { description = "alt-tab between clients", group = "client" }),
--
-- awful.key({"Mod1", "Shift"}, "Tab", function() switcher.switch(-1, "Mod1", "Alt_L", "Shift", "Tab") end,
-- { description = "reverse alt-tab between clients", group = "client" }),


-- awful.key({ modkey,           }, "Tab",
--     function ( )
--         awful.client.focus.history.previous()
--         if client.focus then
--             client.focus:raise()
--         end
--     end,
--     {description = "go back", group = "client"}),


-- awful.key({ modkey, shiftkey }, "left", function (c) move_to_previous_tag() end, awful.tag.viewprev,
-- {description = "move client to previous tag", group = "tag"}),
--
-- awful.key({ modkey, shiftkey }, "right", function (c) move_to_next_tag() end, awful.tag.viewnext,
-- {description = "move client to next tag", group = "tag"}),


awful.key({modkey, ctrlkey}, "left", function(c) move_to_previous_tag() end,
{description = "move client to prev tag without follow", group = "tag"}),

awful.key({modkey, ctrlkey}, "right", function(c) move_to_next_tag() end,
{ description = "move cliet to next tag without follow", group = "tag" }),


-- Standard program

-- Launch terminal
awful.key({modkey}, "Return", function() awful.spawn(terminal) end,
{description = "open a terminal", group = "launcher"}),

-- Launch floating terminal
awful.key({modkey, shiftkey}, "Return", function() awful.spawn(terminal, {floating = true, placement = awful.placement.centered}) end,
{description = "open a floating terminal", group = "launcher"}),

-- Launch terminal in current working directory
awful.key({ modkey, ctrlkey }, "Return", function () awful.util.spawn("sh -c 'urxvt -cd \"$(lastcwd)\"'") end,
{description = "open a terminal in same directory", group = "launcher"}),

-- Launch Hue lighting sync to screen colours
awful.key({ modkey, ctrlkey }, "h", function () awful.util.spawn("huestacean") end,
{description = "open huestacean", group = "launcher"}),

-- Restart awesome
awful.key({modkey, ctrlkey}, "r", awesome.restart,
{description = "reload awesome", group = "awesome"}),

-- Quit awesome
awful.key({modkey, ctrlkey, shiftkey}, "q", function() confirmQuitmenu:show() end, {
description = "Confirm Awesome wm exit", group = "awesome" }),


-- awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
-- {description = "increase master width factor", group = "layout"}),
-- awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
-- {description = "decrease master width factor", group = "layout"}),


awful.key({modkey, "Shift"}, "h", function() awful.tag.incnmaster(1, nil, true) end,
{ description = "increase the number of master clients", group = "layout" }),
awful.key({modkey, shiftkey}, "l", function() awful.tag.incnmaster(-1, nil, true) end,
{ description = "decrease the number of master clients", group = "layout" }),
awful.key({modkey, ctrlkey}, "h", function() awful.tag.incncol(1, nil, true) end,
{ description = "increase the number of columns", group = "layout"}),
awful.key({modkey, ctrlkey}, "l", function() awful.tag.incncol(-1, nil, true) end,
{ description = "decrease the number of columns", group = "layout" }),

awful.key({modkey}, "r", function() awful.layout.inc(1) end,
{description = "select next layout", group = "layout"}),
awful.key({modkey, shiftkey}, "r", function() awful.layout.inc(-1) end,
{description = "select previous layout", group = "layout"}),


-- Toggle floating window to the corner, half works
awful.key({modkey, shiftkey}, "w", function()
	-- local c = awful.client.restore()
	local c = client.focus
	awful.client.floating.toggle()
	if c.floating then
		c.floating = false
		c.ontop = false
		c.sticky = false
	else
		c.floating = true
		c.ontop = true
		c.sticky = true
		c.width = 633
		c.height = 400
		awful.placement.top_right(client.focus)
	end
end, {description = "ontop floating right corner", group = "client"}),


-- https://www.reddit.com/r/awesomewm/comments/jc6j8d/video_floating_on_all_tags
-- awful.key({ modkey, shiftkey }, "w", function (c)
--   awful.client.floating.toggle()
--   if c.floating then
--     c.ontop=true
--     c.sticky=true
--     c.width=533
--     c.height=300
--     awful.placement.top_right(client.focus)
--   else
--     c.ontop=false
--     c.sticky=false
--   end
-- end,
-- {description = "ontop floating right corner", group = "client"}),


-- Apps
awful.key({modkey, shiftkey}, "e", function() awful.spawn.raise_or_spawn("urxvt -e sh -c '$EDITOR ~/.config/awesome/rc.lua'", nil, nil, "awesomeconf")
end, {description = "edit awesome config", group = "launcher"}),


awful.key({modkey}, "F1", function() awful.spawn.raise_or_spawn("urxvt -e sh -c 'ncmpcpp' -name 'ncmpcpp'", nil, create_matcher("ncmpcpp"), "ncmpcpp")
end, {description = "run ncmpcpp in a terminal", group = "launcher"}),

awful.key({modkey, shiftkey}, "F1", function() awful.spawn.raise_or_spawn("spotify", nil, create_matcher("spotify"), "spotify")
end, {description = "run spotify", group = "launcher"}),

-- awful.key({ modkey,},            "F1",      function () awful.spawn.raise_or_spawn("urxvt -e sh -c 'ncmpcpp' -name 'ncmpcpp'",nil,nil,"ncmpcpp") end, { description = "run ncmpcpp in a terminal", group = "launcher" }),
-- awful.key({ modkey,},            "F1",      function () awful.spawn.raise_or_spawn("nsm",nil,create_matcher("Agordejo"),"Agordejo") end, { description = "NSM manager and launcher", group = "launcher" }),

awful.key({modkey}, "F2", function() awful.spawn.raise_or_spawn("raysession", nil, create_matcher("raysession"))
end, {description = "run raysession", group = "launcher"}),

awful.key({modkey, shiftkey}, "F2", function() awful.spawn.raise_or_spawn("urxvt -e sh -c 'nsm'", nil, create_matcher("nsm"), "nsm")
end, {description = "run argodejo in a terminal", group = "launcher"}),
-- awful.key({ modkey, ctrlkey },    "F2",      function () awful.spawn.raise_or_spawn("",nil,nil,"studio-controls") end, { description = "run studio-controls", group = "launcher" }),

awful.key({modkey}, "F3", function() awful.spawn.raise_or_spawn("qbittorrent", nil, create_matcher("qBittorrent"), "qBittorrent")
end, {description = "run qbittorrent", group = "launcher"}),

awful.key({modkey, shiftkey}, "F3", function() awful.spawn.raise_or_spawn("nicotine", nil, create_matcher("Nicotine"))
end, {description = "run nicotine++", group = "launcher"}),

awful.key({modkey}, "F4", function() awful.spawn.raise_or_spawn("picard", nil, create_matcher("Picard"))
end, {description = "run picard", group = "launcher"}),

awful.key({modkey, shiftkey}, "F4", function() awful.spawn.raise_or_spawn("simplescreenrecorder", nil, create_matcher("simplescreenrecorder"))
end, {description = "run simplescreenrecorder", group = "launcher"}),

-- awful.key({modkey}, "F5", function() awful.spawn.raise_or_spawn("studio-controls", nil, create_matcher("studio-controls"))
--   end, {description = "run studio-controls", group = "launcher"}),

awful.key({modkey, shiftkey}, "F6", function() awful.spawn.raise_or_spawn("qseq66", nil, create_matcher("qseq66"))
end, {description = "run qseq66", group = "launcher"}),

awful.key({modkey, shiftkey}, "F7", function() awful.spawn.raise_or_spawn("signal-desktop", nil, create_matcher("signal-desktop"))
end, {description = "run signal-desktop", group = "launcher"}),

awful.key({modkey}, "F8", function() awful.spawn.raise_or_spawn("keepassxc ~/state/nextcloud/sync/keepassxc-mb.kdbx", nil, create_matcher("keepassxc"))
end, {description = "run keepassxc", group = "launcher"}),

awful.key({modkey}, "F9", function() awful.spawn.raise_or_spawn("doublecmd", nil, create_matcher("doublecmd"))
end, {description = "run doublecmd", group = "launcher"}),

-- awful.key({ modkey },            "F11",     function () awful.spawn.raise_or_spawn("quasselclient",nil,nil,"quasselclient") end, { description = "run quasselclient", group = "launcher" }),

-- awful.key({modkey}, "F11", function() awful.spawn.raise_or_spawn("quasselclient", nil, create_matcher("quassel"))
-- end, {description = "run quasselclient", group = "launcher"}),

awful.key({modkey}, "F12", function() awful.spawn.raise_or_spawn("firefox", nil, create_matcher("firefox"))
end, {description = "run firefox", group = "launcher"}),

awful.key({modkey, shiftkey}, "F12", function() awful.spawn.raise_or_spawn("chromium", nil, create_matcher("chromium"))
end, {description = "run chromium", group = "launcher"}),

awful.key({modkey}, "p", function() awful.spawn.raise_or_spawn("pavucontrol", nil, create_matcher("pavucontrol"))
end, {description = "run pavucontrol", group = "launcher"}),


-- awful.key({modkey}, "Print", function() awful.spawn.with_shell("scrot -e 'mv $f ~/media/images/screenshots/' $(hostname --short)_$(date +%Y-%m-%d-%T).png 2>/dev/null", false) end),
awful.key({modkey}, "Print", function() awful.spawn.with_shell("flameshot gui", false)
end, {description = "take a screenshot with flameshot", group = "launcher"}),
-- awful.key({ modkey,   }, "Print", function () awful.spawn.with_shell("import -window root '~/media/images/screenshots/$(hostname --short)_$(date +%Y-%m-%d-%T).png'",false) end),


-- awful.key({modkey, altkey}, "F10", function() awful.spawn.with_shell("ooo_06-screen-below-only.sh", false)
--   end, {description = "screen below only", group = "launcher"}),

-- awful.key({modkey, altkey}, "F11", function() awful.spawn.with_shell("ooo_04-laptop-only.sh", false)
--   end, {description = "laptop screen only", group = "launcher"}),

-- awful.key({modkey, altkey}, "F12", function() awful.spawn.with_shell("ooo_08-screen-above-only.sh", false)
--   end, {description = "laptop screen only", group = "launcher"}),

-- awful.key({modkey, altkey}, "F1", function() awful.spawn.with_shell("ooo_111-laptop-and-screen-above-primary.sh", false)
--   end, {description = "laptop screen only", group = "launcher"}),

-- awful.key({modkey, altkey}, "F4", function() awful.spawn.with_shell("ooo_112-laptop-and-screen-above-and-below-as-clones.sh", false)
--   end, {description = "laptop screen only", group = "launcher"}),

-- awful.key({modkey, altkey}, "F7", function() awful.spawn.with_shell("ooo_121-laptop-primary-and-screen-above-right.sh", false)
--   end, {description = "laptop screen only", group = "launcher"}),

-- awful.key({ modkey, altkey },            "F2",        function () awful.spawn.with_shell("", false) end, {description = "laptop screen only", group = "launcher"}),
-- awful.key({ modkey, altkey },            "F2",       function () awful.spawn.with_shell("11-laptop-and-screen-above.sh", false) end, {description = "laptop screen only", group = "launcher"}),


-- awful.key({ modkey, shiftkey   }, "F3", function () awful.spawn(terminal_cmd) end,
-- {description = "open various terminal apps", group = "launcher"}),

awful.key({modkey, altkey}, "q", function() awful.spawn.with_shell("xkill", false)
end, {description = "xkill to kill a hung gui app", group = "launcher"}),

awful.key({modkey, altkey}, "c", function() awful.spawn.with_shell("xcolor -s clipboard", false)
end, {description = "colour picker to clipboard", group = "launcher"}),


awful.key({ modkey, ctrlkey }, "a", function() awful.spawn.with_shell("arandr", false) end),


-- Volume Keys
-- awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("pactl -- set-sink-volume @DEFAULT_SINK@ -5%", false) end),
-- awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("pactl -- set-sink-volume @DEFAULT_SINK@ +5%", false) end),
-- awful.key({}, "XF86AudioLowerVolume", function() awful.util.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", false) end),
-- awful.key({}, "XF86AudioRaiseVolume", function() awful.util.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+", false) end),

awful.key({}, "XF86AudioLowerVolume", function() awful.spawn.with_shell("vol-dec-all-3.sh", false) end),
awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn.with_shell("vol-inc-all-3.sh", false) end),

awful.key({}, "XF86AudioMute", function() awful.util.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", false) end),


-- Control amplifier hardware
awful.key({ modkey, ctrlkey, altkey }, "b", function() awful.util.spawn("funiculi --host 192.168.1.24 up", false) end,
{ description = "Denon amp increase volume", group = "hotkeys" }),
awful.key({ modkey, ctrlkey, altkey }, "g", function() awful.util.spawn("funiculi --host 192.168.1.24 down", false) end,
{ description = "Denon amp decrease volume", group = "hotkeys" }),

awful.key({ modkey, ctrlkey, altkey }, "v", function() awful.util.spawn("denon_toggle_source.sh", false) end,
{ description = "Denon amp source set toggle", group = "hotkeys" }),
awful.key({ modkey, ctrlkey, altkey }, "r", function() awful.util.spawn("denon_toggle_power.sh", false) end,
{ description = "Denon amp power toggle", group = "hotkeys" }),


-- Media keys with Winamp style hotkeys qwerty: z / pre, x / play, c / (play-)pause, v / stop, b / next
-- Media keys with Winamp style hotkeys colemak: z / pre, x / play, c / (play-)pause, d / stop, v / next
awful.key({ modkey, ctrlkey }, "z", function() awful.util.spawn("playerctl previous", false) end,
{ description = "media backwards", group = "mediakeys" }),
awful.key({}, "XF86AudioPrev", function() awful.util.spawn("playerctl previous", false) end,
{ description = "media backwards", group = "mediakeys"}),

awful.key({ modkey, ctrlkey }, "x",function() awful.util.spawn("playerctl play", false) end,
{ description = "media play", group = "mediakeys"}),
awful.key({}, "XF86AudioPlay", function() awful.util.spawn("playerctl play", false) end,
{ description = "media play", group = "mediakeys"}),

awful.key({ modkey, ctrlkey }, "c", function() awful.util.spawn("playerctl play-pause", false) end,
{ description = "media pause", group = "mediakeys"}),
awful.key({}, "XF86AudioPause", function() awful.util.spawn("playerctl play-pause", false) end,
{ description = "media pause", group = "mediakeys"}),

awful.key({ modkey, ctrlkey }, "d", function() awful.util.spawn("playerctl stop", false) end,
{ description = "media stop", group = "mediakeys"}),
awful.key({}, "XF86AudioStop", function() awful.util.spawn("playerctl stop", false) end,
{ description = "media stop", group = "mediakeys"}),

awful.key({ modkey, ctrlkey }, "v", function() awful.util.spawn("playerctl next", false) end,
{ description = "media next", group = "mediakeys"}),
awful.key({}, "XF86AudioNext", function() awful.util.spawn("playerctl next", false) end,
{ description = "media next", group = "mediakeys"}),


-- Brightness
awful.key({}, "XF86MonBrightnessDown", function() os.execute("brillo -U 10") end,
{ description = "decrease brightness", group = "hotkeys" }),

awful.key({ modkey }, "XF86AudioLower Volume", function() os.execute("brillo -U 10") end,
{ description = "decrease brightness", group = "hotkeys" }),

awful.key({}, "XF86MonBrightnessUp", function() os.execute("brillo -A 10") end,
{description = "increase brightness", group = "hotkeys"}),

awful.key({ modkey }, "XF86AudioRaiseVolume", function() os.execute("brillo -A 10") end,
{description = "increase brightness", group = "hotkeys"}),


-- Application launcher
-- awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
awful.key({modkey}, "space", function() awful.util.spawn("/home/milk/bin/rofi_nice") end,
{description = "run rofi app launcher", group = "launcher"}),

-- Emoji picker
awful.key({modkey, altkey}, "e", function() awful.util.spawn("emote") end,
{description = "run emote emoji picker", group = "launcher"}),


awful.key({ modkey, altkey }, "v", treetile.vertical),
awful.key({ modkey, altkey }, "h", treetile.horizontal),

-- awful.key({ modkey }, "o", leaved.keys.shiftOrder),
-- awful.key({ modkey, "Shift" }, "h", leaved.keys.splitH), --split next horizontal
-- awful.key({ modkey, "Shift" }, "v", leaved.keys.splitV), --split next vertical
-- awful.key({ modkey, "Shift" }, "o", leaved.keys.splitOpp), --split in opposing direction
-- awful.key({ modkey, "Shift" }, "t", leaved.keys.shiftStyle),
-- awful.key({ modkey, "Shift" }, "]", leaved.keys.scaleV(-5)),
-- awful.key({ modkey, "Shift" }, "[", leaved.keys.scaleV(5)),
-- awful.key({ modkey }, "]", leaved.keys.scaleH(-5)),
-- awful.key({ modkey }, "[", leaved.keys.scaleH(5)),


-- doesnt work? error xrandr.lua:120 attempts to cal a nill value format (global 'unpack')
-- awful.key({ modkey, shiftkey }, "s",
--   function() xrandr.xrandr() end,
--   {description = "multimonitors"}),


-- Popup box to enter lua code to run
awful.key({modkey, shiftkey}, "x", function()
	awful.prompt.run {
		prompt = "Run Lua code: ",
		textbox = awful.screen.focused().mypromptbox.widget,
		exe_callback = awful.util.eval,
		history_path = awful.util.get_cache_dir() .. "/history_eval"
	}
end, {description = "lua execute prompt", group = "awesome"}),


-- Hide the statusbar, resizing the window space
awful.key({modkey}, "v", function()
	myscreen = awful.screen.focused()
	myscreen.mywibox.visible = not myscreen.mywibox.visible
end, {description = "toggle statusbar", group = "awesome"}),

-- Hide the status bar, not resizing the window space
awful.key({modkey, altkey}, "v", function()
	for s in screen do
		s.mywibox.visible = not s.mywibox.visible
		if s.myaltwibox then
			s.myaltwibox.visible = not s.myaltwibox.visible
		end
	end
end, {description = "toggle wibox", group = "awesome"}),


-- Menubar app launcher
awful.key({modkey, shiftkey}, "space", function() menubar.show() end,
{ description = "show the menubar", group = "launcher" }));

-- Toggle window fullscreen
clientkeys = gears.table.join(awful.key({modkey}, "f", function(c)
	c.fullscreen = not c.fullscreen
	c:raise()
end, {description = "toggle fullscreen", group = "client"}),


-- Quit current window app
awful.key({modkey}, "w", function(c) c:kill() end,
{	description = "close", group = "client" }),


-- Toggle window floating
awful.key({modkey}, "z", function(c) c.floating = not c.floating end,
{description = "toggle floating", group = "client"}),

awful.key({modkey, ctrlkey}, "Return", function(c) c:swap(awful.client.getmaster()) end,
{description = "move to master", group = "client"}),

-- Centre a floating window
awful.key({modkey, "Shift"}, "z",
awful.placement.centered), {
	description = "centre floating window",
	group = "client"
}, -- Make a window floating and centre is for zen reading experience

awful.key({modkey}, "a", function(c)
	c.floating = not c.floating
	c.width = c.screen.geometry.width * 3 / 5
	c.x = c.screen.geometry.x + (c.screen.geometry.width / 5)
	c.height = c.screen.geometry.height * 0.93
  c.y = c.screen.geometry.height * 0.04
end), {description = "large centre floating window", group = "client" },


-- Toggle window on-top
awful.key({modkey}, "t", function(c) c.ontop = not c.ontop end,
{ description = "toggle keep on top", group = "client" }),
-- Window z-index
-- Send window to the behind plane
awful.key({modkey}, "comma", function(c) c.below = not c.below end,
{description = "behind", group = "client"}),

-- Send window to the middle plane
-- awful.key({ modkey,           }, "period",      function (c) c.below = false     end,
--   {description = "behind", group = "client"}),

-- Send window to the above plane
awful.key({modkey}, "slash", function(c) c.above = not c.above end,
{ description = "behind", group = "client" }),
-- Sticky window, stays on all tags
awful.key({modkey}, "x", function(c) c.sticky = not c.sticky end),


-- Minimize current window
awful.key({modkey}, "n", function(c)
	-- The client currently has the input focus, so it cannot be
	-- minimized, since minimized clients cant have the focus.
	c.minimized = true
end, {description = "minimize", group = "client"}),
-- Unminimize next window
awful.key({modkey, ctrlkey}, "n", function()
	local c = awful.client.restore()
	-- Focus restored client
	if c then
		c:emit_signal("request::activate", "key.unminimize", {raise = true})
	end
end, {description = "restore minimized", group = "client"}),
-- Jump to window
awful.key({modkey, shiftkey}, "n",
function() awful.util.spawn("/home/milk/bin/rofi_jumpwindow") end,
{description = "jump to window", group = "client"}),

-- Maximise toggle for current window
awful.key({modkey}, "m", function(c)
	c.maximized = not c.maximized
	c:raise()
end, {description = "(un)maximize", group = "client"}),

-- Maximise vertivally toggle for current window
awful.key({modkey, ctrlkey}, "m", function(c)
	c.maximized_vertical = not c.maximized_vertical
	c:raise()
end, {description = "(un)maximize vertically", group = "client"}),

-- Maximise horizontally toggle for current window
awful.key({modkey, shiftkey}, "m", function(c)
	c.maximized_horizontal = not c.maximized_horizontal
	c:raise()
end, {description = "(un)maximize horizontally", group = "client"})
-- awful.key({ modkey, shiftkey }, "z",  awful.client.position. ,
--         {description = "toggle floating", group = "client"})
)


-- todo rework with dynamic tags and 0 to =
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 12 do
	globalkeys = gears.table.join(globalkeys,
	-- View tag only.
	awful.key({modkey}, "#" .. i + 9, function()
		local screen = awful.screen.focused()
		local tag = screen.tags[i]
		if tag then tag:view_only() end
	end, {description = "view tag #" .. i, group = "tag"}),

	-- Toggle tag display.
	awful.key({modkey, altkey}, "#" .. i + 9,
	function()
		local screen = awful.screen.focused()
		local tag = screen.tags[i]
		if tag then awful.tag.viewtoggle(tag) end
	end, {description = "toggle tag #" .. i, group = "tag"}),

	-- Move client to tag.
	awful.key({modkey, ctrlkey}, "#" .. i + 9,
	function()
		if client.focus then
			local tag = client.focus.screen.tags[i]
			-- local tag = screen.tags[i]
			if tag then client.focus:move_to_tag(tag) end
		end
	end, {description = "move focused client to tag #" .. i, group = "tag"}),

	-- Move client to tag and follow.
	awful.key({modkey, shiftkey}, "#" .. i + 9,
	function()
		if client.focus then
			local tag = client.focus.screen.tags[i]
			if tag then
				client.focus:move_to_tag(tag)
				-- awful.tag.viewtoggle(tag)
				tag:view_only()
			end
		end
	end, {description = "move focused client to tag #" .. i, group = "tag"}),

	-- Toggle tag on focused client.
	awful.key({modkey, ctrlkey, shiftkey},
	"#" .. i + 9, function()
		if client.focus then
			local tag = client.focus.screen.tags[i]
			if tag then client.focus:toggle_tag(tag) end
		end
	end, {description = "toggle focused client on tag #" .. i, group = "tag"}))
end


clientbuttons = gears.table.join(
awful.button({}, 1, function(c) c:emit_signal("request::activate", "mouse_click", {raise = true}) end),
awful.button({modkey}, 1, function(c) c:emit_signal("request::activate", "mouse_click", {raise = true}) awful.mouse.client.move(c) end),
awful.button({modkey}, 3, function(c) c:emit_signal("request::activate", "mouse_click", {raise = true}) awful.mouse.client.resize(c) end)

)
-- awful.button({modkey, shiftkey}, 4, function(c) move_to_previous_tag() end)
-- awful.button({modkey, shiftkey}, 5, function(c) move_to_next_tag() end),


-- awful.button({ modkey }, 1,
-- function (c)
--      c.maximized_horizontal = false
--      c.maximized_vertical   = false
--      c.maximized            = false
--      c.fullscreen           = false
--      awful.mouse.client.move(c)
-- end

-- awful.button({ modkey, ctrlkey, altkey }, "4", function() awful.util.spawn("funiculi --host 192.168.1.24 up", false) end),
-- awful.button({ modkey, ctrlkey, altkey }, "5", function() awful.util.spawn("funiculi --host 192.168.1.24 down", false) end)
-- )

-- root.buttons(awful.util.table.join(
-- awful.button({ modkey, ctrlkey, altkey }, "4", function() awful.util.spawn("funiculi --host 192.168.1.24 up", false) end),
-- awful.button({ modkey, ctrlkey, altkey }, "5", function() awful.util.spawn("funiculi --host 192.168.1.24 down", false) end)
-- ))


-- middle mouse
awful.button({}, 0, function(c)
	if c == client.focus then
		c.minimized = true
	else
		client.focus = c
		c:raise()
	end
end)
-- }}}


-- set keys
root.keys(globalkeys)
-- }}}



-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			-- focus = awful.client.focus.filter,
			-- raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap +
			awful.placement.no_offscreen,
			size_hints_honor = false,
			titlebars_enabled = false
		}
	},

	-- { rule_any = { type = { "dialog", "normal" } }, properties = { titlebars_enabled = true } },

	-- Floating clients. floatingg
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry", "ncmpcpp", "firefox"
			},
			class = {
				"Arandr", "Blueman-manager", "Cadence", "qjackctl",
				"Studio-controls", "Gpick", "Kruler", "Mixer", "MessageWin", -- kalarm.
				"QjackCtl", "kmix", "seq64", "qseq66",
				"patroneo", "copyq", "* Copying", "Agordejo",
				"radium_compessor", "Goodvibes", "Gsmartcontrol",
				"Syncthing GTK", "Choose an application", "File operations",
				"flameshot", "SimpleScreenRecorder", "Mattermost", "KeePassXC",
				"Onboard", "Image Menu", "emulsion", "Sxiv", "gammy",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui", "veromix", "Vlc", "Protonvpn-gui", "xtightvncviewer",
				"krunner", "netctl-gui", "Image Lounge", "hp-toolbox",
				"Lxappearance", "scrcpy", 'Solaar', 'Gnaural', "Font-manager",
				"qimgv", "kdeconnect.sms", "qt5ct", "qView", "Drumstick MIDI Monitor",
        "Flirc"
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
				"Choose an application", -- doublecmd dialog
				"File operations", -- doublecmd dialog
				"Blender Preferences",
				"Options"
			},
			role = {
				"AlarmWindow", -- Thunderbirds calendar.
				"ConfigManager", -- Thunderbirds about:config.
				"pop-up", -- e.g. Google Chromes (detached) Developer Tools.
				"page-info", -- Firefox page info dialog
        "TfrmFileOp" -- doublecmd file transfer
			}
		},
		properties = {
			floating = true,
			placement = awful.placement.centered + awful.placement.no_overlap +
			awful.placement.no_offscreen
		}
	}, {rule = {}, properties = {focus = awful.client.focus.filter}},
	-- or focus = true,

	{ rule = {class = "URxvt", instance = "ncmpcpp"}, callback = function(c) c.overwrite_class = "urxvt:dev" end },
	-- awful.spawn.with_shell("killall plasmashell")
	-- awful.key({ modkey, altkey       }, "r", function() os.execute("monitor_rofi.sh") end,
	-- was Commented out due to use of Tyrannical
	{rule = {instance = "ncmpcpp"}, properties = {tag = "1"}},
	{rule = {instance = "spotify"}, properties = {tag = "1"}},
	{rule = {instance = "Spotify"}, properties = {tag = "1"}},
	{rule = {instance = "Nicotine"}, properties = {tag = "3"}},
	{rule = {instance = "qbittorrent"}, properties = {tag = "3"}},
	{rule = {class = "Picard"}, properties = {tag = "4"}},
	{rule = {class = "Mixxx"}, properties = {tag = "4"}},
	-- { rule = { single_instance_id = "ncmpcpp" },  properties = { tag = "7", screen = 7 } },
	{rule = {instance = "Double Commander"}, properties = {tag = "9"}},
	{rule = {instance = "doublecmd"}, properties = {tag = "9"}},
	{rule = {instance = "quassel"}, properties = {tag = "-"}},
	{rule_any = {instance = "firefox"}, properties = {tag = "="}},
	{rule = {class = "firefox"}, properties = {tag = "="}},
	{rule = {class = "Firefox"}, properties = {tag = "="}},
	{rule = {class = "Chromium"}, properties = {tag = "="}},
	{rule = {class = "Navigator"}, properties = {tag = "="}},

	-- Audio
	{rule = {instance = "Agordejo"}, properties = {tag = "2"}},
	{rule = {instance = "raysession"}, properties = {tag = "2"}},
	{rule = {instance = "jack_mixer"}, properties = {tag = "3"}},
	{rule = {instance = "radium_compressor"}, properties = {tag = "2"}},
	{rule = {instance = "qseq64"}, properties = {tag = "3"}},
	{rule = {instance = "qseq66"}, properties = {tag = "3"}},

	-- Add titlebars to normal clients and dialogs
	-- { rule_any = {type = { "normal", "dialog" }
	--   }, properties = { titlebars_enabled = true }
	-- },

	-- Set Firefox to always map on the tag named "=" on screen 1.
	-- { rule = { class = "firefox" }, properties = { screen = 1, tag = "=" }},
	-- { rule = { class = "firefox" }, properties = { screen = 2, tag = "=" }},
}
-- }}}

-- if c.class == "firefox" then
--   awful.client.movetotag(tags[1][1], c)
--   c.screen = 1
-- end


-- make sure Firefox doesnt automaximize on start
client.connect_signal("property::maximized", function(c)
    if c.maximized and c.class == "Navigator" then
        c.maximized = false
    end
end)



-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and
		not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- client.connect_signal("request::manage", function(client, context)
--     -- https://www.reddit.com/r/awesomewm/comments/ic7vqt/center_floating_windows_on_screen
--     if client.floating and context == "new" then
--       client.placement = awful.placement.centered + awful.placement.no_overlap
--     end
-- end)

client.connect_signal("manage", function(client)
	if client.floating then client.ontop = true end
end)

-- Avoid FF PiP popping FF window up/down when PiP meets the bottom/top edge
client.connect_signal("property::struts", function(c)
	local struts = c:struts()
	if struts.left ~= 0 or struts.right ~= 0 or struts.top ~= 0 or struts.bottom ~=
		0 then c:struts({left = 0, right = 0, top = 0, bottom = 0}) end
	end)


	-- Add a titlebar if titlebars_enabled is set to true in the rules.
	client.connect_signal("request::titlebars", function(c)
		-- buttons for the titlebar
		local buttons = gears.table.join(awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", {raise = true})
			awful.mouse.client.move(c)
		end), awful.button({}, 3, function()
		c:emit_signal("request::activate", "titlebar", {raise = true})
		awful.mouse.client.resize(c)
	end))

	awful.titlebar(c):setup{
		{
			-- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal
		},
		{
			-- Middle
			{
				-- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c)
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal
		},
		{
			-- Right
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal()
		},
		layout = wibox.layout.align.horizontal
	}

end)


-- screen.connect_signal("arrange", function (s)
--   if s.selected_tag then local max = s.selected_tag.layout.name == "max" end
--   local only_one = #s.tiled_clients == 1 -- use tiled_clients so that other floating windows don't affect the count
--   -- but iterate over clients instead of tiled_clients as tiled_clients doesn't include maximized windows
--   for _, c in pairs(s.clients) do
--     if (max or only_one) and not c.floating or c.maximized then
--       c.border_width = 0
--     else
--       c.border_width = beautiful.border_width
--     end
--   end
-- end)
--
-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

-- client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
-- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- window gaps
beautiful.useless_gap = 0


--
--     local titlebar = fenetre {
--     title_edit = function()
--         -- Remove " - Mozilla Firefox" from the ends of firefoxs titles
--         local firefox = " - Mozilla Firefox"
--         local pri_brow = firefox .. " (Private Browsing)"
--         if title:sub(-firefox:len()) == firefox or title:sub(-pri_brow:len()) == pri_brow then
--             title = title:gsub(" %- Mozilla Firefox", "")
--         end
--     end,
--     max_vert_button = "Shift",
--     max_horiz_button = "Control",
--
--     order = { "max", "ontop", "sticky", "floating", "title" }

-- require("smart_borders") {
--     show_button_tooltips = true,
--     positions = {"top"},
--     -- button_positions = {"top"},
--     -- buttons = {"floating", "minimize", "maximize", "close"},
--     --
--     -- layout = "fixed",
--     -- align_horizontal = "center",
--     -- button_size = 40,
--     -- button_floating_size = 60,
--     -- button_close_size = 60,
--     -- border_width = 6,
--     --
--     -- color_close_normal = {
--     --     type = "linear",
--     --     from = {0, 0},
--     --     to = {60, 0},
--     --     stops = {{0, "#fd8489"}, {1, "#56666f"}}
--     -- },
--     -- color_close_focus = {
--     --     type = "linear",
--     --     from = {0, 0},
--     --     to = {60, 0},
--     --     stops = {{0, "#fd8489"}, {1, "#a1bfcf"}}
--     -- },
--     -- color_close_hover = {
--     --     type = "linear",
--     --     from = {0, 0},
--     --     to = {60, 0},
--     --     stops = {{0, "#FF9EA3"}, {1, "#a1bfcf"}}
--     -- },
--     -- color_floating_normal = {
--     --     type = "linear",
--     --     from = {0, 0},
--     --     to = {40, 0},
--     --     stops = {{0, "#56666f"}, {1, "#ddace7"}}
--     -- },
--     -- color_floating_focus = {
--     --     type = "linear",
--     --     from = {0, 0},
--     --     to = {40, 0},
--     --     stops = {{0, "#a1bfcf"}, {1, "#ddace7"}}
--     -- },
--     -- color_floating_hover = {
--     --     type = "linear",
--     --     from = {0, 0},
--     --     to = {40, 0},
--     --     stops = {{0, "#a1bfcf"}, {1, "#F7C6FF"}}
--     -- },
--     --
--     -- snapping = false,
--     -- snapping_center_mouse = true,
--     --
--     -- -- custom control example:
--     -- button_back = function(c)
--     --     -- set client as master
--     --     c:swap(awful.client.getmaster())
--     -- end
-- }

-- clientbuttons = awful.util.table.join(
--     awful.button({ modkey }, 2, function (c) c:kill() end))
--
-- awful.rules.rules = {
--     { rule = { },
--       properties = { buttons = clientbuttons } }
-- }

-- awful.spawn.with_shell {"~/.screenlayout/new/31-laptop-tv-side.sh"}



client.connect_signal("request::activate", function(c, context, hints)
	if not awesome.startup then
		if c.minimized then c.minimized = false end
		awful.ewmh.activate(c, context, hints)
	end
end)

-- Milkiis rc.lua

--[[ Configuration testing invocation:
Xephyr :1 -ac -br -noreset -screen 1152x720 &
DISPLAY=:1.0 awesome -c ~/.config/awesome/rc.lua.new
]]

-- If LuaRocks is installed, make sure that packages installed through it are
-- found, else do nothing
pcall(require, "luarocks.loader")


-- Standard awesomewm library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

local wibox = require("wibox")                 -- Widget and layout library
local beautiful = require("beautiful")         -- Theme handling library
local naughty = require("naughty")             -- Notification library
local menubar = require("menubar")

local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


-- Extra awesomewm scripts
local lain = require("lain")                   -- Layouts, widgets, something
local revelation = require("revelation")       -- App/desktop switching script
revelation.init()
local cyclefocus = require("cyclefocus")       -- Cycle between apps
local tyrannical = require("tyrannical")       -- Dynamic desktop tagging
--require("tyrannical.shortcut") --optional

local gmath = require("gears.math")

-- Create a menu from .desktop files
local freedesktop = require("freedesktop")


-- Window titlebar as widget
-- local fenetre = require("fenetre")
-- local titlebar = fenetre { }


-- Layout scripts
local dovetail = require("awesome-dovetail")
-- local thrizen = require("thrizen")

-- local leaved = require "awesome-leaved"
local treetile = require("treetile")



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
local media_player = require("plugins.media-player")




-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless erroR LOO
    -- p
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
      text = tostring(err) })
    in_error = false
  end)
end
-- }}}



-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "milktheme/theme.lua")

beautiful.wallpaper = awful.util.get_configuration_dir() .. "milktheme/background.png"

-- Attempt to constrain the size of large icons in their apps notifications
beautiful.notification_icon_size = "32"


for s = 1, screen.count() do
  gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end

-- local function set_wallpaper(s)
--   -- Wallpaper
--   if beautiful.wallpaper then
--     local wallpaper = beautiful.wallpaper
--     -- If wallpaper is a function, call it with the screen
--     if type(wallpaper) == "function" then
--       wallpaper = wallpaper(s)
--     end
--     gears.wallpaper.maximized(wallpaper, s, true)
--   d
-- end




-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor


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
  lain.layout.termfair.center,
  treetile,
  lain.layout.cascade.tile,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral,
  awful.layout.suit.spiral.dwindle,

  -- awful.layout.suit.tile,
  -- awful.layout.suit.tile.left,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.corner.se,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.floating,
  -- lain.layout.termfair,
  -- lain.layout.cascade,
  -- lain.layout.centerwork,
  -- lain.layout.centerwork.horizontal,
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



-- {{{ Menu

-- Create the awesome submenu contents
awesomesubmenu = {
  { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "manual", terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart", awesome.restart },
  { "quit", function() awesome.quit() end },
}

-- Build the main menu with the submenu, app launcher, and terminal entry
mymainmenu = freedesktop.menu.build({
    before = {
      { "Awesome", myawesomemenu, beautiful.awesome_icon },
      -- other triads can be put here
    },
    after = {
      { "Open terminal", terminal },
      -- other triads can be put here
    }
  })







-- Gradient generator, adapted from https://krazydad.com/tutorials/makecolors.php
border_animate_colours = {} 
function makeColorGradient(frequency1, frequency2, frequency3, phase1, phase2, phase3, center, width, len)
  if center == nil   then center = 128 end
  if width == nil    then width = 127 end
  if len == nil      then len = 120 end
  genLoop = 0
  while genLoop < len do
    red = string.format("%02x", (math.floor(math.sin(frequency1*genLoop + phase1) * width + center)))
    grn = string.format("%02x", (math.floor(math.sin(frequency2*genLoop + phase2) * width + center)))
    blu = string.format("%02x", (math.floor(math.sin(frequency3*genLoop + phase3) * width + center)))
    border_animate_colours[genLoop] = "#"..red..grn..blu
    genLoop = genLoop + 1
  end
end



-- redFrequency = .1
-- grnFrequency = .1
-- bluFrequency = .1
redFrequency = .15
grnFrequency = .15
bluFrequency = .15
-- redFrequency = .1
-- grnFrequency = .2
-- bluFrequency = .3

-- phase1 = 0
-- phase2 = 2
-- phase3 = 4
phase1 = 0
phase2 = 20
phase3 = 40

-- center = 128
-- width = 127
-- center = 210
-- width = 45
center = 180
width = 55

makeColorGradient(redFrequency,grnFrequency,bluFrequency,phase1,phase2,phase3,center,width)

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
  timeout   = 0.1,
  call_now  = true,
  autostart = true,
  callback  = function()
    -- naughty.notify({ preset = naughty.config.presets.critical, title = " ", bg = border_animate_colours[borderLoop], notification_border_width = 0 })
    -- client.border_color = border_animate_colours[borderLoop]
local c = client.focus
if c then
    c.border_color = border_animate_colours[borderLoop]
    client.border_color = border_animate_colours[borderLoop]
    borderLoop = borderLoop + 1
    if borderLoop > 60 then borderLoop = 1 end
    end
  end
}


-- window borders
-- client.connect_signal("focus", function(c) c.border_color = "#ecbc34" end)
-- client.connect_signal("focus", function(c)
    -- c.border_color = border_animate_colours[borderLoop]
-- end)

-- client.connect_signal("border_animation_timer:timeout", function(c)
--   c.border_color = border_animate_colours[borderLoop]
-- end)


-- Make border black on unfocus
client.connect_signal("unfocus", function(c) c.border_color = "#00000000" end)





for s in screen do
  freedesktop.desktop.add_icons({screen = s})
end


-- setup launcher wih icon and menu
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- menubar configuration
-- menubar.utils.terminal = terminal -- set the terminal for applications that require it
-- }}}



-- keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- create a textclock widget
mytextclock = wibox.widget.textclock()



-- Create a wibox for each tag  and add it
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

-- Create wibox for all applications
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
  awful.button({ }, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
  end),
  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
  end))


  -- https://www.reddit.com/r/awesomewm/comments/gu4uek/how_to_move_client_to_nextprevious_tag
  local function move_to_previous_tag()
    local c = client.focus
    if not c then return end
    local t = c.screen.selected_tag
    local tags = c.screen.tags
    local idx = t.index
    local newtag = tags[gmath.cycle(#tags, idx - 1)]
    c:move_to_tag(newtag)
    --awful.tag.viewprev()
  end

  local function move_to_next_tag()
    local c = client.focus
    if not c then return end
    local t = c.screen.selected_tag
    local tags = c.screen.tags
    local idx = t.index
    local newtag = tags[gmath.cycle(#tags, idx + 1)]
    c:move_to_tag(newtag)
    --awful.tag.viewnext()
  end


  -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
  -- screen.connect_signal("property::geometry", set_wallpaper)

  local quake = lain.util.quake()

  awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    -- set_wallpaper(s)
    -- s.quake = quake({ app = "urxvt",argname = "-name %s",extra = "-title QuakeDD -e tmux new-session -A -s quake", visible = true, height = 0.9 })

    -- Quake application
    -- s.quake = lain.util.quake()
    s.quake = lain.util.quake({ app = terminal }, { settings = function(c) c.followtag = true end })

    -- {{{ Tags
    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=" }, s, awful.layout.layouts[1])
    -- https://stackoverrun.com/de/q/11351467
    -- tags = {} -- Generates tags with custom names
    -- for s = 1, screen.count() do tags[s] = awful.tag({ "I", "II", "III", "IV", "V", "VI", "VII", "IX" }), end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
      awful.button({ }, 5, function () awful.layout.inc(-1) end)))

      -- Create a taglist widget
      s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.noempty,
        buttons = taglist_buttons
      }

      -- Create a tasklist widget
      s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
      }

      -- Create the wibox
      s.mywibox = awful.wibar({ position = "top", screen = s })

      -- Add widgets to the wibox
      s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
          layout = wibox.layout.fixed.horizontal,
          s.mytaglist,
          s.mypromptbox,
          mykeyboardlayout,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
          layout = wibox.layout.fixed.horizontal,
          -- titlebar,
          mytextclock,
          mylauncher,
          wibox.widget.systray(),
          s.mylayoutbox,
        },
      }

      milkdefault = lain.layout.termfair.center

      tyrannical.tags = {
        {
          name        = "Term",                 -- Call the tag "Term"
          init        = true,                   -- Load the tag on startu
          exclusive   = true,                   -- Refuse any other type of clients (by classes)
          screen      = {1,2},                  -- Create this tag on screen 1 and screen 2
          layout      = milkdefault,
          instance    = {"dev", "ops"},         -- Accept the following instances. This takes precedence over 'class'
          class       = { --Accept the following classes, refuse everything else (because of "exclusive=true")
            "xterm" , "urxvt" , "aterm","URxvt","XTerm","konsole","terminator","gnome-terminal"
          }
        } ,
        {
          name        = "Files",
          init        = true,
          exclusive   = true,
          screen      = 1,
          layout      = awful.layout.suit.tile,
          exec_once   = {"dolphin"}, --When the tag is accessed for the first time, execute this command
          class  = {
            "Thunar", "Konqueror", "Dolphin", "ark", "Nautilus","emelfm", "Double Commander"
          }
        } ,
        {
          name        = "Keepass",
          init        = true,
          exclusive   = true,
          screen      = 1,
          layout      = awful.layout.suit.max                          ,
          class ={
          "keepassxc"}
        } ,
        {
          name        = "Chat",
          init        = true,
          exclusive   = true,
          screen      = 1,
          layout      = awful.layout.suit.max                          ,
          class ={
          "quassel"}
        } ,
        {
          name        = "Develop",
          init        = true,
          exclusive   = true,
          screen      = 1,
          layout      = awful.layout.suit.max                          ,
          class ={
          "Kate", "KDevelop", "Codeblocks", "Code::Blocks" , "DDD", "kate4"}
        } ,
        {
          name        = "Doc",
          init        = false, -- This tag wont be created at startup, but will be when one of the
          -- client in the "class" section will start. It will be created on
          -- the client startup screen
          exclusive   = true,
          layout      = awful.layout.suit.max,
          class       = {
            "Assistant"     , "Okular"         , "Evince"    , "EPDFviewer"   , "xpdf",
          "Xpdf"          ,                                        }
        } ,
        {
          name        = "Web",
          init        = true,
          exclusive   = true,
          -- icon        = "~net.png",                 -- Use this icon for the tag (uncomment with a real path)
          screen      = screen.count()>1 and 2 or 1,-- Setup on screen 2 if there is more than 1 screen, else on screen 1
          layout      = awful.layout.suit.max,      -- Use the max layout
          class = {
            "Opera"         , "Firefox"        , "Rekonq"    , "Dillo"        , "Arora",
          "Chromium"      , "nightly"        , "minefield" , "Firefox-esr"     }
        } ,
      }

      -- Ignore the tag "exclusive" property for the following clients (matched by classes)
      tyrannical.properties.intrusive = {
        "ksnapshot"     , "pinentry"       , "gtksu"     , "kcalc"        , "xcalc"               ,
        "feh"           , "Gradient editor", "About KDE" , "Paste Special", "Background color"    ,
        "kcolorchooser" , "plasmoidviewer" , "Xephyr"    , "kruler"       , "plasmaengineexplorer",
      }

      -- Ignore the tiled layout for the matching clients
      tyrannical.properties.floating = {
        "MPlayer"      , "pinentry"        , "ksnapshot"  , "pinentry"     , "gtksu"          ,
        "xine"         , "feh"             , "kmix"       , "kcalc"        , "xcalc"          ,
        "yakuake"      , "Select Color$"   , "kruler"     , "kcolorchooser", "Paste Special"  ,
        "New Form"     , "Insert Picture"  , "kcharselect", "mythfrontend" , "plasmoidviewer"
      }

      -- Make the matching clients (by classes) on top of the default layout
      tyrannical.properties.ontop = {
        "Xephyr"       , "ksnapshot"       , "kruler"
      }

      -- Force the matching clients (by classes) to be centered on the screen on init
      tyrannical.properties.placement = {
        kcalc = awful.placement.centered
      }

      tyrannical.settings.block_children_focus_stealing = true --Block popups ()
      tyrannical.settings.group_children = true --Force popups/dialogs to have the same tags as the parent client


      -- Setup the media player widget for the alternative wibar
      local media_player2 = media_player({
          -- icons  = {
          --     play   = theme.play,
          --     pause  = theme.pause
          -- },
          -- font         = theme.font,
          name         = "mpd", -- target media player
          refresh_rate = 1 -- interval between widget update calls
        }).widget

      -- the alt wibox
      s.myaltwibox = awful.wibar({ position = "top", screen = s, height = 23, visible = false})

      -- Add widgets to the wibox
      s.myaltwibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
          -- Left widgets
          layout = wibox.layout.fixed.horizontal,
        },
        -- Middle widget
        media_player2,
        {
          -- Right widgets
          layout = wibox.layout.fixed.horizontal,
        },
      }

    end)



    -- {{{ Mouse bindings
    root.buttons(gears.table.join(
        awful.button({ }, 3, function () mymainmenu:toggle() end)
        -- awful.button({ }, 4, awful.tag.viewnext),
        -- awful.button({ }, 5, awful.tag.viewprev)
      ))

    -- }}}


    -- matcher generator for rules
    local create_matcher = function(class_name)
      return function(c)
        return awful.rules.match(c, { class = class_name })
      end
    end



    -- https://www.reddit.com/r/awesomewm/comments/izn34y/awesomewmlua_noob_confirmation_on_quit_using
    confirmQuitmenu = awful.menu({ items = { { "Cancel", function() do end end },
        { "Quit", function() awesome.quit() end } }
      })


    -- {{{ Key bindings
    globalkeys = gears.table.join(
      -- Show hotkey help popup dialog window
      awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
        {description="show help", group="awesome"}),

      awful.key({ modkey, }, "g", function () awful.screen.focused().quake:toggle() end, {description = "dropdown application", group = "launcher"}),




      -- -- Cycle between all desktop tags
      -- -- Cycle to previous tag
      -- awful.key({ modkey, shiftkey   }, "Left",   awful.tag.viewprev,
      --   {description = "view previous", group = "tag"}),
      -- -- Cycle to next tag
      -- awful.key({ modkey, shiftkey   }, "Right",  awful.tag.viewnext,
      --   {description = "view next", group = "tag"}),


      -- Cycle only through desktop tags that have a visible window
      -- https://www.reddit.com/r/awesomewm/comments/g2lzs3/how_to_cycle_through_tasklist_or_through_tags
      awful.key({ modkey, }, "Left",
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

      awful.key({ modkey, }, "Right",
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


      -- Focus on next window on current tag
      awful.key({ modkey,           }, "j",
        function ()
          awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
        ),

      -- Focus on previous window on current tag
      awful.key({ modkey,           }, "k",
        function ()
          awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
        ),

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



      -- Jump between current and previous window on whatever tag
      awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
        {description = "go back", group = "tag"}),

      -- Trigger relevation script to display and number all windows for quick switch
      awful.key({ modkey,    ctrlkey          }, "space",      revelation),


      -- Show awesome menu
      awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
        {description = "show main menu", group = "awesome"}),


      -- Layout manipulation
      awful.key({ modkey, shiftkey   }, "j", function () awful.client.swap.byidx(  1)    end,
        {description = "swap with next client by index", group = "client"}),

      awful.key({ modkey, shiftkey   }, "k", function () awful.client.swap.byidx( -1)    end,
        {description = "swap with previous client by index", group = "client"}),

      awful.key({ modkey, ctrlkey }, "j", function () awful.screen.focus_relative( 1) end,
        {description = "focus the next screen", group = "screen"}),

      awful.key({ modkey, ctrlkey }, "k", function () awful.screen.focus_relative(-1) end,
        {description = "focus the previous screen", group = "screen"}),

      awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
        {description = "jump to urgent client", group = "client"}),


      -- awful.key({ modkey,           }, "Tab",
      --     function ( )
      --         awful.client.focus.history.previous()
      --         if client.focus then
      --             client.focus:raise()
      --         end
      --     end,
      --     {description = "go back", group = "client"}),
      -- modkey+Tab: cycle through all clients.

      awful.key({ modkey }, "Tab", function(c)
        cyclefocus.cycle({modifier="Super_L"})
      end),
      -- modkey+Shift+Tab: backwards
      awful.key({ modkey, shiftkey }, "Tab", function(c)
        cyclefocus.cycle({modifier="Super_L"})
      end),


      -- awful.key({ modkey, shiftkey }, "left", function (c) move_to_previous_tag() end, awful.tag.viewprev,
      -- {description = "move client to previous tag", group = "tag"}),
      --
      -- awful.key({ modkey, shiftkey }, "right", function (c) move_to_next_tag() end, awful.tag.viewnext,
      -- {description = "move cliet to next tag", group = "tag"}),


      awful.key({ modkey, ctrkey }, "left", function (c) move_to_previous_tag() end,
        {description = "move client to previous tag", group = "tag"}),

      awful.key({ modkey, ctrkey }, "right", function (c) move_to_next_tag() end,
        {description = "move cliet to next tag", group = "tag"}),


      -- Standard program
      awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
        {description = "open a terminal", group = "launcher"}),
      awful.key({ modkey, shiftkey   }, "Return", function () awful.spawn(terminal, { floating = true, placement = awful.placement.centered}) end,
        {description = "open a floating terminal", group = "launcher"}),

      awful.key({ modkey, ctrlkey }, "Escape", awesome.restart,
        {description = "reload awesome", group = "awesome"}),

      awful.key({ modkey, shiftkey   }, "q", function () confirmQuitmenu:show() end,
        {description = "Confirm Awesome wm exit", group = "awesome"}),


      -- awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
      -- {description = "increase master width factor", group = "layout"}),
      -- awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
      -- {description = "decrease master width factor", group = "layout"}),

      awful.key({ modkey, shiftkey   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
        {description = "increase the number of master clients", group = "layout"}),
      awful.key({ modkey, shiftkey   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
        {description = "decrease the number of master clients", group = "layout"}),

      awful.key({ modkey, ctrlkey }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
        {description= "increase the number of columns", group = "layout"}),
      awful.key({ modkey, ctrlkey }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
        {description = "decrease the number of columns", group = "layout"}),

      awful.key({ modkey,           }, "r", function () awful.layout.inc( 1)                end,
        {description = "select next", group = "layout"}),
      awful.key({ modkey, shiftkey   }, "r", function () awful.layout.inc(-1)                end,
        {description = "select previous", group = "layout"}),


      -- Toggle floating window to the corner
      awful.key({ modkey, shiftkey }, "w", function (c)
        local c = awful.client.restore()
        awful.client.floating.toggle()
        if c.floating then
          c.ontop=true
          c.sticky=true
          c.width=433
          c.height=200
          awful.placement.top_right(client.focus)
        else
          c.ontop=false
          c.sticky=false
        end
      end,
      {description = "ontop floating right corner", group = "client"}),
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
    awful.key({ modkey, shiftkey },   "e",       function () awful.spawn.raise_or_spawn("urxvt -e sh -c 'vim ~/.config/awesome/rc.lua'",nil,nil,"awesomeconf") end, { description = "edit awesome config", group = "launcher" }),

    awful.key({ modkey,},            "F1",      function () awful.spawn.raise_or_spawn("urxvt -e sh -c 'ncmpcpp' -name 'ncmpcpp'",nil,nil,"ncmpcpp") end, { description = "run ncmpcpp in a terminal", group = "launcher" }),
    -- awful.key({ modkey,},            "F1",      function () awful.spawn.raise_or_spawn("nsm",nil,create_matcher("Agordejo"),"Agordejo") end, { description = "NSM manager and launcher", group = "launcher" }),
    awful.key({ modkey },            "F2",      function () awful.spawn.raise_or_spawn("nicotine",nil,create_matcher("Nicotine")) end, { description = "run nicotine++", group = "launcher" }),
    awful.key({ modkey },            "F3",      function () awful.spawn.raise_or_spawn("qbittorrent",nil,create_matcher("qBittorrent"),"qBittorrent") end, { description = "run qbittorrent", group = "launcher" }),
    awful.key({ modkey },            "F4",      function () awful.spawn.raise_or_spawn("picard",nil,create_matcher("Picard")) end, { description = "run picard", group = "launcher" }),
    awful.key({ modkey, shiftkey },   "F4",      function () awful.spawn.raise_or_spawn("simplescreenrecorder",nil,create_matcher("simplescreenrecorder")) end, { description = "run simplescreenrecorder", group = "launcher" }),
    awful.key({ modkey },            "F5",      function () awful.spawn.raise_or_spawn("studio-controls",nil,create_matcher("studio-controls")) end, { description = "run studio-controls", group = "launcher" }),
    awful.key({ modkey, shiftkey },   "F5",      function () awful.spawn.raise_or_spawn("urxvt -e sh -c 'nsm'",nil,create_matcher("nsm"),"nsm") end, { description = "run argodejo in a terminal", group = "launcher" }),
    -- awful.key({ modkey, ctrlkey },    "F5",      function () awful.spawn.raise_or_spawn("",nil,nil,"studio-controls") end, { description = "run studio-controls", group = "launcher" }),
    awful.key({ modkey },            "F6",      function () awful.spawn.raise_or_spawn("carla",nil,create_matcher("carla")) end, { description = "run carla", group = "launcher" }),
    awful.key({ modkey, shiftkey },   "F6",      function () awful.spawn.raise_or_spawn("qseq66",nil,create_matcher("qseq66")) end, { description = "run qseq66", group = "launcher" }),
    awful.key({ modkey },            "F8",      function () awful.spawn.raise_or_spawn("keepassxc ~/state/nextcloud/sync/keepassxc-mb.kdbx",nil,create_matcher("keepassxc")) end, { description = "run keepassxc", group = "launcher" }),
    awful.key({ modkey,},            "F9",      function () awful.spawn.raise_or_spawn("doublecmd",nil,create_matcher("doublecmd")) end, { description = "run doublecmd", group = "launcher" }),
    --awful.key({ modkey },            "F11",     function () awful.spawn.raise_or_spawn("quasselclient",nil,nil,"quasselclient") end, { description = "run quasselclient", group = "launcher" }),
    awful.key({ modkey },            "F11",     function () awful.spawn.raise_or_spawn("quasselclient",nil,create_matcher("quassel"))end, { description = "run quasselclient", group = "launcher" }),
    awful.key({ modkey },            "F12",     function () awful.spawn.raise_or_spawn("firefox",nil,create_matcher("firefox")) end, { description = "run firefox", group = "launcher" }),

    awful.key({ modkey },            "p",       function () awful.spawn.raise_or_spawn("pavucontrol",nil,create_matcher("pavucontrol")) end, {description = "run pavucontrol", group = "launcher"}),

    awful.key({ modkey },            "Print",   function () awful.spawn.with_shell("scrot -e 'mv $f ~/media/images/screenshots/' $(hostname --short)_$(date +%Y-%m-%d-%T).png 2>/dev/null", false) end),
    -- awful.key({ modkey,   }, "Print", function () awful.spawn.with_shell("import -window root '~/media/images/screenshots/$(hostname --short)_$(date +%Y-%m-%d-%T).png'",false) end),


    -- Volume Keys
    awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -q -D pulse sset Master 5%-", false) end),
    awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -q -D pulse sset Master 5%+", false) end),
    awful.key({}, "XF86AudioMute", function () awful.util.spawn("amixer -D pulse set Master 1+ toggle", false) end),
    -- Media Keys
    awful.key({}, "XF86AudioPlay", function() awful.util.spawn("playerctl play-pause", false) end),
    awful.key({}, "XF86AudioNext", function() awful.util.spawn("playerctl next", false) end),
    awful.key({}, "XF86AudioPrev", function() awful.util.spawn("playerctl previous", false) end),


    -- Prompt
    -- awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
    awful.key({ modkey },            "space",     function () awful.util.spawn("/home/milk/bin/rofi_nice") end,
      {description = "run rofi", group = "launcher"}),



    -- awful.key({ modkey }, "v", treetile.vertical),
    -- awful.key({ modkey }, "h", treetile.horizontal),


    -- awful.key({ modkey }, "o", leaved.keys.shiftOrder),
    -- awful.key({ modkey, "Shift" }, "h", leaved.keys.splitH), --split next horizontal
    -- awful.key({ modkey, "Shift" }, "v", leaved.keys.splitV), --split next vertical
    -- awful.key({ modkey, "Shift" }, "o", leaved.keys.splitOpp), --split in opposing direction
    -- awful.key({ modkey, "Shift" }, "t", leaved.keys.shiftStyle),
    -- awful.key({ modkey, "Shift" }, "]", leaved.keys.scaleV(-5)),
    -- awful.key({ modkey, "Shift" }, "[", leaved.keys.scaleV(5)),
    -- awful.key({ modkey }, "]", leaved.keys.scaleH(-5)),
    -- awful.key({ modkey }, "[", leaved.keys.scaleH(5)),




    awful.key({ modkey, shiftkey }, "x",
      function ()
        awful.prompt.run {
          prompt       = "Run Lua code: ",
          textbox      = awful.screen.focused().mypromptbox.widget,
          exe_callback = awful.util.eval,
          history_path = awful.util.get_cache_dir() .. "/history_eval"
        }
      end,
      {description = "lua execute prompt", group = "awesome"}),

    --   awful.key({ modkey }, "v",
    -- function ()
    --     myscreen = awful.screen.focused()
    --     myscreen.mywibox.visible = not myscreen.mywibox.visible
    -- end,
    -- {description = "toggle statusbar"}),


    -- Show/Hide Wibox
    awful.key({ modkey, altkey }, "v", function ()
      for s in screen do
        s.mywibox.visible = not s.mywibox.visible
        if s.myaltwibox then
          s.myaltwibox.visible = not s.myaltwibox.visible
        end
      end
    end,
    {description = "toggle wibox", group = "awesome"}),


  -- Menubar
  awful.key({ modkey, shiftkey }, "space", function() menubar.show() end, {description = "show the menubar", group = "launcher"}));

clientkeys = gears.table.join(
  awful.key({ modkey,           }, "f",
    function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = "toggle fullscreen", group = "client"}),
  awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
    {description = "close", group = "client"}),
  awful.key({ modkey,           }, "z",  awful.client.floating.toggle                     ,
    {description = "toggle floating", group = "client"}),
  awful.key({ modkey, ctrlkey }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    {description = "move to master", group = "client"}),
  awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
    {description = "move to screen", group = "client"}),
  awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
    {description = "toggle keep on top", group = "client"}),


  -- Window z-index
  -- Send window to the behind plane
  awful.key({ modkey,           }, "comma",      function (c) c.below = not c.below            end,
    {description = "behind", group = "client"}),

  -- -- Send window to the middle plane
  -- awful.key({ modkey,           }, "period",      function (c) c.below = false     end,
  --   {description = "behind", group = "client"}),

  -- Send window to the above plane
  awful.key({ modkey,           }, "slash",      function (c) c.above = not c.above            end,
    {description = "behind", group = "client"}),


  -- Switcky window, stays on all tags
  awful.key({ modkey,           }, "x",      function (c) c.sticky = not c.sticky  end),


  -- Minimize current window
  awful.key({ modkey,           }, "n",
    function (c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end ,
    {description = "minimize", group = "client"}),


  -- Unminimize current window
  awful.key({ modkey, ctrlkey }, "n",
    function ()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal(
          "request::activate", "key.unminimize", {raise = true}
          )
      end
    end,
    {description = "restore minimized", group = "client"}),


  -- Maximise toggle for current window
  awful.key({ modkey,           }, "m",
    function (c)
      c.maximized = not c.maximized
      c:raise()
    end ,
    {description = "(un)maximize", group = "client"}),


  -- Maximise vertivally toggle for current window
  awful.key({ modkey, ctrlkey }, "m",
    function (c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end ,
    {description = "(un)maximize vertically", group = "client"}),


  -- Maximise horizontally toggle for current window
  awful.key({ modkey, shiftkey   }, "m",
    function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end ,
    {description = "(un)maximize horizontally", group = "client"})


  -- awful.key({ modkey, shiftkey }, "z",  awful.client.position. ,
  --         {description = "toggle floating", group = "client"})
  )


-- todo rework with dynamic tags and 0 to =
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,

    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      {description = "view tag #"..i, group = "tag"}),

    -- Toggle tag display.
    awful.key({ modkey, ctrlkey }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      {description = "toggle tag #" .. i, group = "tag"}),

    -- Move client to tag.
    awful.key({ modkey, shiftkey }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      {description = "move focused client to tag #"..i, group = "tag"}),

    -- Toggle tag on focused client.
    awful.key({ modkey, ctrlkey, shiftkey }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end



clientbuttons = gears.table.join(
  awful.button({ }, 1, function (c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
  end),
  awful.button({ modkey }, 1, function (c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function (c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
    awful.mouse.client.resize(c)
  end),
  awful.button({ modkey, shiftkey }, 4, function (c) move_to_previous_tag() end),
  awful.button({ modkey, shiftkey }, 5, function (c) move_to_next_tag() end)

  -- awful.button({ modkey }, 1,
  -- function (c)
  --      c.maximized_horizontal = false
  --      c.maximized_vertical   = false
  --      c.maximized            = false
  --      c.fullscreen           = false
  --      awful.mouse.client.move(c)
  -- end)
  )


-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = { border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
      size_hints_honor = false,
      titlebars_enabled = false
    }
  },

  -- { rule_any = { type = { "dialog", "normal" } }, properties = { titlebars_enabled = true } },

  -- Floating clients.
  { rule_any = {
      instance = {
        "DTA",  -- Firefox addon DownThemAll.
        "copyq",  -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Cadence",
        "qjackctl",
        "Studio-controls",
        "Gpick",
        "Kruler",
        "Mixer",
        "MessageWin",  -- kalarm.
        "mpv",
        "QjackCtl",
        "Pavucontrol",
        "seq64",
        "qseq66",
        "patroneo",
        "copyq",
        "* Copying",
        "Agordejo",
        "radium_compessor",
        "Goodvibes",
        "Gsmartcontrol",
        "Syncthing GTK",
        "Choose an application",
        "File operations",
        "flameshot",
        "SimpleScreenRecorder",
        "Mattermost",
        "KeePassXC",
        "Onboard",
        "Image Menu",
        "emulsion",
        "Sxiv",
        "gammy",
        "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "Wpa_gui",
        "veromix",
        "Vlc",
        "Protonvpn-gui",
      "xtightvncviewer"},

      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester",  -- xev.
        "Choose an application", --doublecmd dialog
      },
      role = {
        "AlarmWindow",   -- Thunderbird's calendar.
        "ConfigManager", -- Thunderbird's about:config.
        "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
        "page-info",     -- Firefox page info dialog
      }
    },
    properties = {
      floating = true,
      placement = awful.placement.centered + awful.placement.no_overlap+awful.placement.no_offscreen
    }
  },


  { rule = { },                                 properties = { focus = awful.client.focus.filter } },
  -- or focus = true,


  { rule = { instance = "Nicotine" },           properties = { tag = "2" } },
  { rule = { instance = "Agordejo" },           properties = { tag = "2" } },
  { rule = { instance = "qbittorrent" },        properties = { tag = "3" } },
  { rule = { instance = "carla" },              properties = { tag = "4" } },
  { rule = { instance = "MusicBrainz Picard" }, properties = { tag = "4" } },
  { rule = { instance = "qseq64" },             properties = { tag = "4" } },
  { rule = { instance = "qseq66" },             properties = { tag = "4" } },
  { rule = { instance = "jack_mixer" },         properties = { tag = "6" } },
  { rule = { instance = "radium_compressor" },  properties = { tag = "6" } },
  { rule = { instance = "doublecmd" },          properties = { tag = "6" } },
  { rule = { instance = "Double Commander" },   properties = { tag = "6" } },
  -- { rule = { single_instance_id = "ncmpcpp" },  properties = { tag = "7", screen = 7 } },
  { rule = { single_instance_id = "ncmpcpp" },  properties = { tag = "7" } },
  { rule = { instance = "quassel" },            properties = { tag = "8" } },
  { rule = { instance = "firefox" },            properties = { tag = "9" } }


  -- Add titlebars to normal clients and dialogs
  -- { rule_any = {type = { "normal", "dialog" }
  --   }, properties = { titlebars_enabled = true }
  -- },

  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- { rule = { class = "Firefox" },
  --   properties = { screen = 1, tag = "2" } },
}
-- }}}


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
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
  if struts.left ~= 0 or struts.right ~= 0 or struts.top ~= 0 or struts.bottom ~= 0 then
    c:struts({ left = 0, right = 0, top = 0, bottom = 0 })
  end
end)

-- run_once({ "xrandr --output LVDS1 --off --output DP1 --off --output HDMI1 --off --output VGA1 --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off" }) -- entries must be separated by commas


-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({ }, 1, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.resize(c)
    end)
    )

  awful.titlebar(c) : setup {
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout  = wibox.layout.fixed.horizontal
    },
    { -- Middle
      { -- Title
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal
    },
    { -- Right
      awful.titlebar.widget.floatingbutton (c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton   (c),
      awful.titlebar.widget.ontopbutton    (c),
      awful.titlebar.widget.closebutton    (c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

-- client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
-- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}



-- window gaps
-- beautiful.useless_gap = 4

--
--     local titlebar = fenetre {
--     title_edit = function()
--         -- Remove " - Mozilla Firefox" from the ends of firefox's titles
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

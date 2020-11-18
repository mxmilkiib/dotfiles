-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")


local revelation=require("revelation")

local cyclefocus = require("cyclefocus")

local gmath = require("gears.math")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


-- addons requires

revelation.init()

-- require("collision")()
--


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
        -- Make sure we don't go into an endless error loop
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

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.corner.se,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
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
screen.connect_signal("property::geometry", set_wallpaper)

local quake = require("quake")

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    -- set_wallpaper(s)
    s.quake = quake({ app = "urxvt",argname = "-name %s",extra = "-title QuakeDD -e tmux new-session -A -s quake", visible = true, height = 0.9 })

    -- {{{ Tags
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=" }, s, awful.layout.layouts[1])
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
            -- mylauncher,
            s.mypromptbox,
            mykeyboardlayout,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mytextclock,
            wibox.widget.systray(),
            s.mylayoutbox,
        },
    }
end)
-- }}}





-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
    -- awful.button({ }, 4, awful.tag.viewnext),
    -- awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}



-- {{{ Key bindings
globalkeys = gears.table.join(
    -- Show hotkey help popup dialog window
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    awful.key({ modkey, }, "g", function () awful.screen.focused().quake:toggle() end, {description = "dropdown application", group = "launcher"}),

    -- Cycle to previous tag
    awful.key({ modkey, "Shift"   }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    -- Cycle to next tag
    awful.key({ modkey, "Shift"   }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),

    -- Cycle only through non-empty tags
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


    -- Jump between current and previous window
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- Trigger relevation script to display and number all windows for quick switch
    awful.key({ modkey,           }, "e",      revelation),

    -- Focus on prev/next window on current tag
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
  
    -- Show awesome menu
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
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
   awful.key({ modkey, "Shift" }, "Tab", function(c)
     cyclefocus.cycle({modifier="Super_L"})
   end), 


    awful.key({ modkey, "Shift" }, "bracketleft", function (c) move_to_previous_tag() end,
             {description = "move client to previous tag", group = "tag"}),

    awful.key({ modkey, "Shift" }, "bracketright", function (c) move_to_next_tag() end,
             {description = "move cliet to next tag", group = "tag"}),


    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn(terminal, { floating = true, placement = awful.placement.centered}) end,
              {description = "open a floating terminal", group = "launcher"}),

    awful.key({ modkey, "Control" }, "Escape", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
            {description = "quit awesome", group = "awesome"}),
            
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "r", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "r", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
            

    awful.key({ modkey, "Control" }, "n",
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


    -- https://www.reddit.com/r/awesomewm/comments/jc6j8d/video_floating_on_all_tags
    -- Toggle floating window to the corner
    awful.key({ modkey, "Shift" }, "w", function (c)
      awful.client.floating.toggle()
      if c.floating then
        c.ontop=true
        c.sticky=true
        c.width=533
        c.height=300
        awful.placement.top_right(client.focus)
      else
        c.ontop=false
        c.sticky=false
      end
    end,
    {description = "ontop floating right corner", group = "client"}),


    -- Apps
    awful.key({ modkey, "Shift" },   "e",       function () awful.spawn.raise_or_spawn("urxvt -e sh -c 'vim ~/.config/awesome/rc.lua'",nil,nil,"awesomeconf") end, { description = "edit awesome config", group = "launcher" }),

    awful.key({ modkey,},            "F1",      function () awful.spawn.raise_or_spawn("urxvt -e sh -c 'ncmpcpp' -name 'ncmpcpp'",nil,nil,"ncmpcpp") end, { description = "run ncmpcpp in a terminal", group = "launcher" }),
    awful.key({ modkey },            "F2",      function () awful.spawn.raise_or_spawn("soulseekqt",nil,nil,"soulseekqt") end, { description = "run soulseekqt", group = "launcher" }),
    awful.key({ modkey },            "F3",      function () awful.spawn.raise_or_spawn("qbittorrent",nil,nil,"qbittorrent") end, { description = "run qbittorrent", group = "launcher" }),
    awful.key({ modkey },            "F4",      function () awful.spawn.raise_or_spawn("picard",nil,nil,"picard") end, { description = "run picard", group = "launcher" }),
    awful.key({ modkey, "Shift" },   "F4",      function () awful.spawn.raise_or_spawn("simplescreenrecorder",nil,nil,"simplescreenrecorder") end, { description = "run simplescreenrecorder", group = "launcher" }),
    awful.key({ modkey },            "F5",      function () awful.spawn.raise_or_spawn("studio-controls",nil,nil,"studio-controls") end, { description = "run studio-controls", group = "launcher" }),
    awful.key({ modkey, "Shift" },   "F5",      function () awful.spawn.raise_or_spawn("urxvt -e sh -c 'nsm'",nil,nil,"nsm") end, { description = "run argodejo in a terminal", group = "launcher" }),
    awful.key({ modkey },            "F6",      function () awful.spawn.raise_or_spawn("carla",nil,nil,"carla") end, { description = "run carla", group = "launcher" }),
    awful.key({ modkey, "Shift" },   "F6",      function () awful.spawn.raise_or_spawn("qseq66",nil,nil,"qseq66") end, { description = "run qseq66", group = "launcher" }),
    awful.key({ modkey },            "F8",      function () awful.spawn.raise_or_spawn("keepassxc ~/state/nextcloud/sync/keepassxc-mb.kdbx",nil,nil,"keepassxc") end, { description = "run keepassxc", group = "launcher" }),
    awful.key({ modkey,},            "F9",      function () awful.spawn.raise_or_spawn("doublecmd",nil,nil,"doublecmd") end, { description = "run doublecmd", group = "launcher" }),
    awful.key({ modkey },            "F11",     function () awful.spawn.raise_or_spawn("quasselclient",nil,nil,"quasselclient") end, { description = "run quasselclient", group = "launcher" }),
    awful.key({ modkey },            "F12",     function () awful.spawn.raise_or_spawn("firefox",nil,nil,"Firefox") end, { description = "run firefox", group = "launcher" }),

    awful.key({ modkey },            "p",       function () awful.spawn("pavucontrol") end, {description = "run pavucontrol", group = "launcher"}),

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
    awful.key({ modkey },            "space",     function () awful.util.spawn("rofi_nice") end,
              {description = "run rofi", group = "launcher"}),

    awful.key({ modkey, "Shift" }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
           
            awful.key({ modkey }, "v",
          function ()
              myscreen = awful.screen.focused()
              myscreen.mywibox.visible = not myscreen.mywibox.visible
          end,
          {description = "toggle statusbar"}),


    -- Menubar
    awful.key({ modkey, "Shift" }, "space", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
);

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
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),

    awful.key({ modkey,           }, "x",      function (c) c.sticky = not c.sticky  end),

    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})

      -- awful.key({ modkey, "Shift" }, "z",  awful.client.position. ,
      --         {description = "toggle floating", group = "client"})
)

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
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
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
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
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
    awful.button({ modkey, "Shift" }, 4, function (c) move_to_previous_tag() end),
    awful.button({ modkey, "Shift" }, 5, function (c) move_to_next_tag() end)

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
                     size_hints_honor = false
     }
    },

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
          "Pavucontrol",
          "seq64",
          "qseq66",
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
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "Vlc",
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
      

      { rule = { single_instance_id = "ncmpcpp" },            properties = { tag = "1", screen = 1 } },
      { rule = { instance = "SoulseekQt" },         properties = { tag = "2" } },
      { rule = { instance = "Agordejo" },           properties = { tag = "2" } },
      { rule = { instance = "qbittorrent" },        properties = { tag = "3" } },
      { rule = { instance = "Agordejo" },           properties = { tag = "3" } },
      { rule = { instance = "MusicBrainz Picard" }, properties = { tag = "4" } },
      { rule = { instance = "qseq64" },             properties = { tag = "4" } },
      { rule = { instance = "qseq66" },             properties = { tag = "4" } },
      { rule = { instance = "carla" },              properties = { tag = "5" } },
      { rule = { instance = "jack_mixer" },         properties = { tag = "6" } },
      { rule = { instance = "radium_compressor" },  properties = { tag = "6" } },
      { rule = { instance = "doublecmd" },          properties = { tag = "6" } },
      { rule = { instance = "Double Commander" },   properties = { tag = "6" } },
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


client.connect_signal("request::manage", function(client, context)
    -- https://www.reddit.com/r/awesomewm/comments/ic7vqt/center_floating_windows_on_screen
    if client.floating and context == "new" then
      client.placement = awful.placement.centered + awful.placement.no_overlap
    end
end)

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
-- client.connect_signal("request::titlebars", function(c)
--     -- buttons for the titlebar
--     local buttons = gears.table.join(
--         awful.button({ }, 1, function()
--             c:emit_signal("request::activate", "titlebar", {raise = true})
--             awful.mouse.client.move(c)
--         end),
--         awful.button({ }, 3, function()
--             c:emit_signal("request::activate", "titlebar", {raise = true})
--             awful.mouse.client.resize(c)
--         end)
--     )
--
--     awful.titlebar(c) : setup {
--         { -- Left
--             awful.titlebar.widget.iconwidget(c),
--             buttons = buttons,
--             layout  = wibox.layout.fixed.horizontal
--         },
--         { -- Middle
--             { -- Title
--                 align  = "center",
--                 widget = awful.titlebar.widget.titlewidget(c)
--             },
--             buttons = buttons,
--             layout  = wibox.layout.flex.horizontal
--         },
--         { -- Right
--             awful.titlebar.widget.floatingbutton (c),
--             awful.titlebar.widget.maximizedbutton(c),
--             awful.titlebar.widget.stickybutton   (c),
--             awful.titlebar.widget.ontopbutton    (c),
--             awful.titlebar.widget.closebutton    (c),
--             layout = wibox.layout.fixed.horizontal()
--         },
--         layout = wibox.layout.align.horizontal
--     }
-- end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

-- client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
-- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- window borders
client.connect_signal("focus", function(c) c.border_color = "#ecbc34" end)
client.connect_signal("unfocus", function(c) c.border_color = "#000000" end)


-- window gaps
beautiful.useless_gap = 1

---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()


local theme = {}


theme.font          = "Hack Nerd Font Mono 9"
-- theme.font          = "Hack regular 9"
-- theme.font          = "Hack regular 12"


---- active window
-- theme.bg_focus      = "#623997"

theme.bg_focus       = "#623997"
theme.fg_focus       = "#ffffff"

---- general window
-- theme.bg_normal     = "#000000"
theme.bg_normal      = "#020202"
theme.fg_normal      = "#fff"


-- theme.bg_minimize   = "#000000"
theme.bg_minimize    = "#000000"
-- theme.fg_minimize   = "#9543b8"
theme.fg_minimize    = "#999"


-- theme.bg_urgent     = "#ecbc34"
theme.fg_urgent      = "#ff0000"


theme.bg_systray     = theme.bg_normal
-- theme.bg_systray    = "#000000"


theme.titlebar_bg_normal = "#000000"
theme.taglist_bg_normal = "#000000"


-- beautiful.hotkeys_modifiers_fg = "#ffffff"

-- theme.useless_gap   = dpi(3)
-- theme.useless_gap   = 4

-- theme.border_width  = dpi(2)
theme.border_width  = 4
-- theme.border_width  = 2
-- theme.border_width  = 1


theme.border_normal = "#535d6c"
-- theme.border_normal = "#ffffff"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

--theme.collision_focus_bg = "#ffff00"
theme.collision_focus_bg_center = "#00ff00"


-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Ensure readable title/task text colors
theme.tasklist_fg_focus = theme.tasklist_fg_focus or "#FFD700"
theme.tasklist_fg_normal = theme.tasklist_fg_normal or "#FFFFFF"
theme.titlebar_fg_focus = theme.titlebar_fg_focus or "#FFD700"
theme.titlebar_fg_normal = theme.titlebar_fg_normal or "#FFFFFF"



-- Generate taglist squares:
local taglist_square_size = dpi(6.5)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)



-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(20)
theme.menu_width  = dpi(300)
-- theme.menu_font   = "JetBrains Mono 12" 
theme.menu_font   = "Hack regular 9" 

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

theme.wallpaper = themes_path.."milktheme/background.png"
-- theme.wallpaper = "/home/milk/.config/awesome/milktheme/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- theme.layout_dovetail = themes_path.."default/layouts/cornersew.png"
theme.layout_thrizen = themes_path.."thrizen/themes/default/thrizen.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil



theme.lain_icons         = os.getenv("HOME") ..
                           "/.config/awesome/lain/icons/layout/default/"
theme.layout_termfair    = theme.lain_icons .. "termfair.png"
theme.layout_centerfair  = theme.lain_icons .. "centerfair.png"  -- termfair.center
theme.layout_cascade     = theme.lain_icons .. "cascade.png"
theme.layout_cascadetile = theme.lain_icons .. "cascadetile.png" -- cascade.tile
theme.layout_centerwork  = theme.lain_icons .. "centerwork.png"
theme.layout_centerworkh = theme.lain_icons .. "centerworkh.png" -- centerwork.horizontal

theme.layout_leavedright = "~/.config/awesome/awesome-leaved/icons/leavedright.png"
theme.layout_leavedleft = "~/.config/awesome/awesome-leaved/icons/leavedleft.png"
theme.layout_leavedbottom = "~/.config/awesome/awesome-leaved/icons/leavedbottom.png"
theme.layout_leavedtop = "~/.config/awesome/awesome-leaved/icons/leavedtop.png"

theme.layout_treetile = "~/.config/awesome/treetile/layout_icon.png"


return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80

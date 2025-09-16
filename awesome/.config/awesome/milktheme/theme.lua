--------------------------------------------------
-- Default awesome theme, Milkii's custom theme --
--------------------------------------------------



-- // MARK: REQUIRES
-- core Beautiful and DPI helpers

-- ██████╗ ███████╗ ██████╗ ██╗   ██╗██╗██████╗ ███████╗███████╗
-- ██╔══██╗██╔════╝██╔═══██╗██║   ██║██║██╔══██╗██╔════╝██╔════╝
-- ██████╔╝█████╗  ██║   ██║██║   ██║██║██████╔╝█████╗  ███████╗
-- ██╔══██╗██╔══╝  ██║▄▄ ██║██║   ██║██║██╔══██╗██╔══╝  ╚════██║
-- ██║  ██║███████╗╚██████╔╝╚██████╔╝██║██║  ██║███████╗███████║
-- ╚═╝  ╚═╝╚══════╝ ╚══▀▀═╝  ╚═════╝ ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝


local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()


-- // MARK: TABLE & PATHS
local theme = {}

-- Base icon directories used by layout icon sections
theme.lain_icons         = "~/.config/awesome/lain/icons/layout/default/"
theme.bling_icons        = "~/.config/awesome/bling/icons/layouts/"
theme.extras_icons       = "~/.config/awesome/lib_extras_milkii/icons/layouts/"




-- // MARK: WALLPAPER

-- ██╗    ██╗ █████╗ ██╗     ██╗     ██████╗  █████╗ ██████╗ ███████╗██████╗ 
-- ██║    ██║██╔══██╗██║     ██║     ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
-- ██║ █╗ ██║███████║██║     ██║     ██████╔╝███████║██████╔╝█████╗  ██████╔╝
-- ██║███╗██║██╔══██║██║     ██║     ██╔═══╝ ██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗
-- ╚███╔███╔╝██║  ██║███████╗███████╗██║     ██║  ██║██║     ███████╗██║  ██║
--  ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝


-- old path pointed to the system themes dir; use local config theme if available
-- theme.wallpaper = themes_path.."milktheme/background.png"
local cfg_wall = gfs.get_configuration_dir() .. "milktheme/background.png"
if gfs.file_readable(cfg_wall) then
    theme.wallpaper = cfg_wall
else
    -- fallback to default theme background to avoid errors
    theme.wallpaper = themes_path .. "default/background.png"
end




-- // MARK: FONTS
-- font config goes here

-- ███████╗ ██████╗ ███╗   ██╗████████╗███████╗
-- ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔════╝
-- █████╗  ██║   ██║██╔██╗ ██║   ██║   ███████╗
-- ██╔══╝  ██║   ██║██║╚██╗██║   ██║   ╚════██║
-- ██║     ╚██████╔╝██║ ╚████║   ██║   ███████║
-- ╚═╝      ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚══════╝


theme.font          = "Hack Nerd Font Mono 9"
-- theme.font          = "Hack regular 9"
-- theme.font          = "Hack regular 12"

-- Menu font (kept with typography for consistency)
theme.menu_font   = theme.font

-- Hotkeys popup styling
-- theme.hotkeys_font = "Hack Nerd Font 12"
theme.hotkeys_font = theme.font
theme.hotkeys_modifiers_fg = "#dddddd"


--------------------------------------------------------

-- // MARK: HOTKEYS POPUP
-- compact, readable styling closer to default awesome look
-- old:
-- theme.hotkeys_font = theme.font
-- theme.hotkeys_modifiers_fg = "#dddddd"
-- new:
--  - keep font but add a proportional description font for better readability
--  - add subtle border and spacing between groups
--  - use focused bg for key label chips with contrasting text
theme.hotkeys_description_font = "Sans 9"
theme.hotkeys_bg = theme.bg_normal
theme.hotkeys_fg = theme.fg_normal
theme.hotkeys_border_width = dpi(1)
theme.hotkeys_border_color = "#6c6c6c"
theme.hotkeys_group_margin = dpi(8)
theme.hotkeys_label_bg = theme.bg_focus
theme.hotkeys_label_fg = "#ffffff"


---- active window
-- theme.bg_focus      = "#623997"

-- theme.menu_font   = "JetBrains Mono 12" 



-- // MARK: PALETTE
-- General-purpose root color for the theme (used across tags, tasks, icons, etc.)

-- ██████╗  █████╗ ██╗     ███████╗████████╗████████╗███████╗
-- ██╔══██╗██╔══██╗██║     ██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝
-- ██████╔╝███████║██║     █████╗     ██║      ██║   █████╗  
-- ██╔═══╝ ██╔══██║██║     ██╔══╝     ██║      ██║   ██╔══╝  
-- ██║     ██║  ██║███████╗███████╗   ██║      ██║   ███████╗
-- ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝


theme.main_purple   = "#623997"

-- Keep bg_focus as an alias for compatibility with Awesome/Beautiful expectations
theme.bg_focus       = theme.main_purple
theme.fg_focus       = "#fff"


---- general window
theme.bg_normal     = "#000000"
-- theme.bg_normal      = "#020202"
theme.fg_normal      = "#fff"


-- theme.bg_minimize   = "#000"
theme.bg_minimize    = "#000"
-- theme.fg_minimize   = "#9543b8"
theme.fg_minimize    = "#999"


-- theme.bg_urgent     = "#ecbc34"
theme.fg_urgent      = "#f00"


-- unified icon sizing (px)
theme.icon_size = 16


-- compact titlebar height (roughly 1/4 of typical defaults): icon size + minimal padding
theme.titlebar_height = theme.icon_size + 2

theme.titlebar_bg_normal = theme.main_purple


theme.taglist_bg_normal = "#000"
theme.taglist_fg_normal = "#ffffff"
theme.taglist_fg_focus = "#ffd700"
theme.taglist_fg_occupied = "#cccccc"
theme.taglist_hover_bg = "#b8860b"
theme.taglist_hover_fg = "#000000"

-- systray icon size (override or inherit)
theme.systray_icon_size = theme.icon_size
theme.bg_systray     = theme.bg_normal



-- Collision focus colors
theme.collision_focus_bg_center = "#00ff00"
-- theme.collision_focus_bg = "#ffff00"


-- beautiful.hotkeys_modifiers_fg = "#ffffff"




-- // MARK: EDGES
-- spacing & borders

-- ███████╗██████╗  ██████╗ ███████╗███████╗
-- ██╔════╝██╔══██╗██╔════╝ ██╔════╝██╔════╝
-- █████╗  ██║  ██║██║  ███╗█████╗  ███████╗
-- ██╔══╝  ██║  ██║██║   ██║██╔══╝  ╚════██║
-- ███████╗██████╔╝╚██████╔╝███████╗███████║
-- ╚══════╝╚═════╝  ╚═════╝ ╚══════╝╚══════╝


theme.border_normal = "#535d6c"
-- theme.border_normal = "#ffffff"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"
theme.border_width  = dpi(2)

-- theme.border_width  = 2
-- theme.border_width  = 1
theme.border_radius = 2


-- theme.useless_gap   = dpi(3)
-- theme.useless_gap   = 4
theme.useless_gap = 0




-- // MARK: COLORS
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

-- IMPORTANT: Set these to nil to let shimmer handle text coloring
-- This ensures the shimmer effect isn't overridden by theme settings




-- // MARK: TASKLIST
-- Align with official theme variables for focus colors
-- Previous overrides (moved from rc.lua for clarity):
-- theme.tasklist_bg_focus = "#663399" -- example if a distinct tasklist purple was desired
-- theme.tasklist_bg_focus = theme.main_purple
theme.tasklist_fg_focus = nil
theme.tasklist_fg_normal = nil

-- icon sizes
theme.tasklist_icon_size = theme.icon_size

-- disable status symbols and underscores for minimized clients in tasklist
theme.tasklist_plain_task_name = true


-- // MARK: TAGLIST
-- Exported size for custom tag occupancy squares used in rc.lua
theme.tag_square_size = dpi(7)


-- Generate taglist squares:
local taglist_square_size = dpi(6.5)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- theme.taglist_bg_focus = "#663399" -- prior hardcoded purple in rc.lua
-- theme.taglist_bg_focus = theme.main_purple






-- // MARK: TITLEBAR
-- theme.titlebar_fg_focus = "#ffd700"
-- theme.titlebar_fg_normal = "#fff"




-- // MARK: NOTIFICATIONS

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- System tray and notification colors
theme.notification_bg = "#FFD700"    -- gold background
theme.notification_fg = "#000000"    -- black text
theme.notification_icon_size = 64





-- // MARK: MENU
-- Variables set for theming the menu:

-- ███╗   ███╗███████╗███╗   ██╗██╗   ██╗
-- ████╗ ████║██╔════╝████╗  ██║██║   ██║
-- ██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
-- ██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
-- ██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
-- ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝ 


-- Font overrides


-- Menu dimensions

-- Keep theme as the single source of truth
-- theme.menu_height = 24
theme.menu_height = dpi(20)
-- theme.menu_width = 300
theme.menu_width  = dpi(300)


-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"




-- // MARK: ICONS
-- Define the image to load for bar layout widget

-- ██╗ ██████╗ ██████╗ ███╗   ██╗███████╗
-- ██║██╔════╝██╔═══██╗████╗  ██║██╔════╝
-- ██║██║     ██║   ██║██╔██╗ ██║███████╗
-- ██║██║     ██║   ██║██║╚██╗██║╚════██║
-- ██║╚██████╗╚██████╔╝██║ ╚████║███████║
-- ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝


theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)


-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil



-- layout icon system, svg vs png
-- // MARK: png
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



theme.layout_icon_config = {
    -- Colors
    purple_margin_bg = theme.main_purple,    -- Purple margin/background
    window_fill = "#CCCCCC",         -- Light grey fills
    window_border = "#AAAAAA",       -- Light grey borders and separators
    background = "#000000",          -- Black background
    
    -- Dimensions
    icon_size = 64,                  -- Icon dimensions
    border_width = 2,                -- Purple margin width
    corner_radius = 1,               -- Rounded corner radius
    separator_width = 1,             -- Separator width between windows
    min_purple_margin = 2,           -- Minimum purple space around representations
    
    -- File naming
    current_suffix = "_alt",         -- Current active icon suffix
    archive_suffix = "_alt_v2",      -- Archive suffix for previous versions
}



-- // MARK: svg

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



theme.layout_centerwork_adaptiveh = theme.extras_icons .. "centerwork_adaptiveh" .. theme.layout_icon_config.current_suffix .. ".svg" -- centerwork_adaptive.horizontal
theme.layout_centerwork_twothirdsh = theme.extras_icons .. "centerwork_twothirdsh" .. theme.layout_icon_config.current_suffix .. ".svg" -- centerwork_twothirds.horizontal
theme.layout_centered = theme.extras_icons .. "centered" .. theme.layout_icon_config.current_suffix .. ".svg" -- bling.layout.centered
theme.layout_deck = theme.extras_icons .. "deck" .. theme.layout_icon_config.current_suffix .. ".svg" -- bling.layout.deck
theme.layout_equalarea = theme.extras_icons .. "equalarea" .. theme.layout_icon_config.current_suffix .. ".svg" -- bling.layout.equalarea
theme.layout_mstab = theme.extras_icons .. "mstab" .. theme.layout_icon_config.current_suffix .. ".svg" -- bling.layout.mstab
theme.layout_tile = theme.extras_icons .. "tile" .. theme.layout_icon_config.current_suffix .. ".svg" -- awful.layout.suit.tile
theme.layout_tiletop = theme.extras_icons .. "tiletop" .. theme.layout_icon_config.current_suffix .. ".svg" -- awful.layout.suit.tile.top
theme.layout_tilebottom = theme.extras_icons .. "tilebottom" .. theme.layout_icon_config.current_suffix .. ".svg" -- awful.layout.suit.tile.bottom
theme.layout_tileleft = theme.extras_icons .. "tileleft" .. theme.layout_icon_config.current_suffix .. ".svg" -- awful.layout.suit.tile.left
theme.layout_magnifier = theme.extras_icons .. "magnifier" .. theme.layout_icon_config.current_suffix .. ".svg" -- awful.layout.suit.magnifier
theme.layout_max = theme.extras_icons .. "max" .. theme.layout_icon_config.current_suffix .. ".svg" -- awful.layout.suit.max
theme.layout_floating = theme.extras_icons .. "floating" .. theme.layout_icon_config.current_suffix .. ".svg" -- awful.layout.suit.floating
theme.layout_cascade = theme.extras_icons .. "cascade" .. theme.layout_icon_config.current_suffix .. ".svg" -- lain.layout.cascade
theme.layout_treetile = theme.extras_icons .. "treetile" .. theme.layout_icon_config.current_suffix .. ".svg" -- treetile layout
theme.layout_trizen = theme.extras_icons .. "trizen" .. theme.layout_icon_config.current_suffix .. ".svg" -- trizen layout

theme.layout_leavedright  = "~/.config/awesome/awesome-leaved/icons/leavedright.png"
theme.layout_leavedleft   = "~/.config/awesome/awesome-leaved/icons/leavedleft.png"
theme.layout_leavedbottom = "~/.config/awesome/awesome-leaved/icons/leavedbottom.png"
theme.layout_leavedtop    = "~/.config/awesome/awesome-leaved/icons/leavedtop.png"

-- // MARK: PLUGIN LAYOUT ICONS
theme.layout_thrizen = themes_path.."thrizen/themes/default/thrizen.png"

theme.layout_termfair    = theme.lain_icons  .. "termfair.png"
theme.layout_centerfair  = theme.lain_icons  .. "centerfair.png"  -- termfair.center
theme.layout_cascade     = theme.lain_icons  .. "cascade.png"
theme.layout_cascadetile = theme.lain_icons  .. "cascadetile.png" -- cascade.tile
theme.layout_centerwork  = theme.lain_icons  .. "centerwork.png"
theme.layout_centerworkh = theme.lain_icons  .. "centerworkh.png" -- centerwork.horizontal


-- NOTE: PNG fallback intentionally disabled to avoid overriding unified SVG icon above
-- theme.layout_treetile     = "~/.config/awesome/treetile/layout_icon.png"


return theme
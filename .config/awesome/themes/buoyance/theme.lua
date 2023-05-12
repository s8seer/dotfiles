---------------------------------------------
-- Two Dimendioned Fanatical Awesome Theme --
---------------------------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- Paths
local THEME_FOLDER = os.getenv("HOME").."/.config/awesome/themes/buoyance/"
local icon_path = THEME_FOLDER.."/icons/"
local layout_path = THEME_FOLDER.."/layouts/"
-- --


-- Transparency
-- 100% — FF 95% — F2 90% — E6 85% — D9 80% — CC 75% — BF 70% — B3 65% — A6 60% — 99 55% — 8C 
--  50% — 80 45% — 73 40% — 66 35% — 59 30% — 4D 25% — 40 20% — 33 15% — 26 10% — 1A 5% — 0D 0% — 00

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        --gears.wallpaper.maximized(wallpaper, s, false) end
        gears.wallpaper.tiled(wallpaper, s) end
end

local sexy = {}
--sexy.font          = "ProFontWindows 14"
sexy.font           = "monofur Bold 14"


sexy.wallpaper = THEME_FOLDER.."/wallpapers/107878052_day.jpg"
--sexy.wallpaper = "/home/salt/hub/awesomewm/themes/buoyance/wallpapers/107878052_night.jpg"

sexy.bg_normal     = "#0d1b2a"
sexy.bg_focus      = "#00c4b0"
sexy.bg_minimize   = "#444444"
sexy.bg_urgent     = "#ffaebc"

sexy.fg_normal     = "#FCF1E3"
sexy.fg_focus      = "#FCF1E3"
sexy.fg_urgent     = "#1A2024"
sexy.fg_minimize   = "#1A2024"

sexy.useless_gap   = dpi(3)
sexy.border_width  = dpi(3)
sexy.border_normal = "#444444"
sexy.border_focus  = "#32EA60"
sexy.border_marked = "#ffaebc"

sexy.titlebar_size = 12
sexy.titlebar_bg_focus = sexy.border_focus 
sexy.titlebar_fg_focus = "#1A2024"
sexy.titlebar_bg_normal = "#444444"

sexy.tasklist_bg_focus = "#fad02c"
sexy.tasklist_bg_normal = "#001219"
sexy.tasklist_fg_focus = "#1A2024"

sexy.systray_icon_spacing = 4

sexy.taglist_fg_focus = "#1A2024"
sexy.taglist_bg_focus = "#00c4b0"
sexy.taglist_bg_occupied = "#001219"
sexy.taglist_bg_empty = "#001219"
sexy.taglist_fg_empty = "#FCF1E3"
sexy.taglist_fg_occupied = sexy.taglist_bg_focus
sexy.taglist_fg_urgent = sexy.taglist_fg_focus
sexy.taglist_bg_urgent = "#ffaebc"


sexy.tooltip_border_width = dpi(2)

sexy.prompt_fg = "#1A2024"
sexy.prompt_bg = "#ffaebc"
sexy.prompt_bg_cursor = "#1A2024"

sexy.hotkeys_border_width = dpi(2)
sexy.hotkeys_border_color = "#FCF1E3"
sexy.hotkeys_modifiers_fg = "#aaaaaa"
sexy.hotkeys_bg = "#1A2024"
sexy.hotkeys_fg = "#aaaaaa"
sexy.hotkeys_label_fg = sexy.hotkeys_bg

sexy.notification_opacity = 0.90
sexy.notification_max_height = dpi(95)
sexy.notification_max_width = dpi(550)

sexy.menu_height = dpi(26)
sexy.menu_width  = dpi(220)
sexy.menu_border_width = dpi(2)
sexy.menu_border_color = "#fad02c"
sexy.menu_bg_normal = "#1A2024"
sexy.menu_bg_focus = "#fad02c"
sexy.menu_fg_normal = "#FCF1E3"
sexy.menu_fg_focus = sexy.menu_bg_normal

sexy.wibar_height = 28
sexy.wibar_position = "top"

-- You can use your own layout icons like this:

sexy.layout_fairh = layout_path.."fairh.png"
sexy.layout_fairv = layout_path.."fairv.png"
sexy.layout_floating  = layout_path.."floating.png"
sexy.layout_magnifier = layout_path.."magnifierw.png"
sexy.layout_max = layout_path.."maxw.png"
sexy.layout_fullscreen = layout_path.."fullscreenw.png"
sexy.layout_tilebottom = layout_path.."tilebottomw.png"
sexy.layout_tileleft   = layout_path.."tileleftw.png"
sexy.layout_tile = layout_path.."tile.png"
sexy.layout_tiletop = layout_path.."tiletopw.png"
sexy.layout_spiral  = layout_path.."spiralw.png"
sexy.layout_dwindle = layout_path.."dwindlew.png"

-- Drawer Icons:
sexy.awesome_icon = icon_path.."draw_arch.png"
sexy.menu_submenu_icon = icon_path.."draw_expand.png"

-- Entries
sexy.computer_icon = icon_path.."com_computer.png"
sexy.question_icon = icon_path.."com_info.png"
sexy.reload_icon = icon_path.."com_reload.png"
sexy.logout_icon = icon_path.."com_logout.png"
sexy.shutdown_icon = icon_path.."com_shutdown.png"

-- If null, will use icons from /usr/share/icons and /usr/share/icons/hicolor 
sexy.icon_theme = nil

return sexy
 
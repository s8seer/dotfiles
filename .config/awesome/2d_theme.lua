---------------------------------------------
-- Two Dimendioned Fanatical Awesome Theme --
---------------------------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- Paths
local THEME_FOLDER = os.getenv("HOME").."/.config/awesome/2d_theme/"
local icon_path = THEME_FOLDER.."/icons/"
local layout_path = THEME_FOLDER.."/layouts/"
-- --

local sexy = {}
sexy.font          = "ProFontWindows 13"

sexy.wallpaper = THEME_FOLDER.."/wallpaper"
--sexy.wallpaper = "override_here"

sexy.bg_normal     = "#1A2024"
sexy.bg_focus      = "#00c4b0"
sexy.bg_minimize   = "#345351"
sexy.bg_urgent     = "#ffaebc"

sexy.fg_normal     = "#FCF1E3"
sexy.fg_focus      = "#FCF1E3"
sexy.fg_urgent     = "#1A2024"
sexy.fg_minimize   = "#FCF1E3"

sexy.useless_gap   = dpi(8)
sexy.border_width  = dpi(3)
sexy.border_normal = "#1A2024"
sexy.border_focus  = "#32EA60"
sexy.border_marked = "#ffaebc"

sexy.titlebar_bg_focus = sexy.border_focus 
sexy.titlebar_fg_focus = "#1A2024"
sexy.titlebar_bg_normal = "#444444"
sexy.titlebar_size = 10

sexy.tasklist_bg_focus = "#00c4b0"
sexy.tasklist_fg_focus = "#1A2024"

sexy.systray_icon_spacing = 4

sexy.taglist_fg_focus = "#1A2024"
sexy.taglist_bg_focus = "#00c4b0"
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


sexy.menu_height = dpi(34)
sexy.menu_width  = dpi(257)
sexy.menu_border_width = dpi(2)
sexy.menu_border_color = "#fad02c"
sexy.menu_bg_normal = "#1A2024"
sexy.menu_bg_focus = "#fad02c"
sexy.menu_fg_normal = "#FCF1E3"
sexy.menu_fg_focus = "#1A2024"

sexy.wibar_height=28



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

-- Games
sexy.games_icon = icon_path.."games.png"
sexy.steam_icon = icon_path.."steam.png"
sexy.osu_icon = icon_path.."game_osu.png"
sexy.minecraft_icon = icon_path.."game_minecraft.png"

-- Apps
sexy.apps_icon = icon_path.."app_firefox.png"
sexy.firefox_icon = icon_path.."app_firefox.png"

-- Social
sexy.social_icon = icon_path.."soc_social.png"
sexy.telegram_icon = icon_path.."telegram.png"
sexy.discord_icon = icon_path.."soc_discord.png"

-- Programs
sexy.programs_icon = icon_path.."prog_program.png"
sexy.files_icon = icon_path.."prog_file.png" 
sexy.code_icon = icon_path.."prog_code.png"

-- Computer
sexy.computer_icon = icon_path.."com_computer.png"
sexy.question_icon = icon_path.."com_info.png"
sexy.reload_icon = icon_path.."com_reload.png"
sexy.logout_icon = icon_path.."com_logout.png"
sexy.shutdown_icon = icon_path.."com_shutdown.png"

-- If null, will use icons from /usr/share/icons and /usr/share/icons/hicolor 
sexy.icon_theme = nil

return sexy

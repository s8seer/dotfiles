local awful = require("awful")
local sexy = require("beautiful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
sexy.init(gears.filesystem.get_configuration_dir() .. "2d_theme.lua")

HOUSE = os.getenv("HOME")

local system_menu = {
    { "Help", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end, sexy.question_icon},
    { "Reload", awesome.restart, sexy.reload_icon},
    { "Log off", function() awesome.quit() end, sexy.logout_icon},
    { "Shutdown", "systemctl poweroff", sexy.shutdown_icon}}
local apps_menu = {
    { "Firefox", "firefox", sexy.firefox_icon},
}
local social_menu = {
    { "Telegram", "telegram-desktop", sexy.telegram_icon},
    { "Discord", "discord", sexy.discord_icon},
}
local programs_menu = {
    { "Dolphin", "dolphin", sexy.files_icon},
    { "VS Code", "code", sexy.code_icon},
}
local games_menu = {
    { "Steam", "steam", sexy.steam_icon},
    { "Osu!Lazer", "/mnt/table/SteamGib/otherGib/seperate/osu/osu.AppImage", sexy.osu_icon},
    { "Minecraft", "minecraft-launcher", sexy.minecraft_icon},
}

-- Returns the finalized menu
local mymainmenu = { items = { 
                         { "Files", "dolphin", sexy.files_icon},
                         { "Firefox", "firefox", sexy.firefox_icon},
                         { "Minecraft", "minecraft-launcher", sexy.minecraft_icon},
                         { "Games", games_menu, sexy.games_icon},
                         { "Apps", apps_menu, sexy.apps_icon},
                         { "Social", social_menu, sexy.social_icon},
                         { "Programs", programs_menu, sexy.programs_icon},
                         { "Computer", system_menu, sexy.computer_icon},
                         }}
return mymainmenu
-- --

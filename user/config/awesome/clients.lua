local awful = require('awful')
local gears = require('gears')
local beautiful = require("beautiful")
require('awful.autofocus')
require("keys")
tag_names = { "Main", "II", "III", "IV", "V", "VI", "VII", "VIII", "Code" }

awful.rules.rules = { -->> Rules
-- Use 'xprop' to see client info.
    { rule = { }, -- All clients.
      properties = { border_width = beautiful.border_width,
                    border_color = beautiful.border_normal,
                    focus = awful.client.focus.filter,
                    raise = true,
                    keys = clientkeys,
                    buttons = clientbuttons,
                    screen = awful.screen.preferred,
                    placement = awful.placement.centered}},
    { rule_any = { -- Floating clients.
        instance = {
          "DTA",  
          "copyq",  
          "pinentry",
          "systemmonitor"
        },
        class = {
         "Pavucontrol", "QjackCtl", "Arandr", "Blueman-manager",
         "Gpick", "Kruler", "MessageWin", "Sxiv", "Wpa_gui",
         "veromix", "xtightvncviewer", "plasma.emojier"
        },
        name = { "Event Tester" },
        role = {
          "AlarmWindow",  
          "ConfigManager",
        }},
        properties = { 
              floating = true,
              placement = awful.placement.centered}},

    { rule_any = { -- Titlebar enabled.
      type = {  "normal", "dialog" } },
      properties = { titlebars_enabled = true }},
      
    { rule_any = { -- Borders disabled
      role = {  "Popup" } },
      properties = { border_width = 0 }},

    { rule_any = { -- krunner
      class = {  "krunner" } },
      properties = { titlebars_enabled = false,
                    border_width = 0,
                    floating=true,
                    placement = awful.placement.no_offscreen }},

    -- # Tag 1 -- Main
    { rule = { class = "firefox" },
      properties = { tag = tag_names[1] }},
    -- # Tag 2 -- games
    { rule_any = { class = {    
                        "Lutris",
                        "Steam",
                        "steam_app_291550",
                        "steam_app_1818750",
                        "minecraft-launcher",
                        "Minecraft Launcher",
                        "Minecraft*",
                        },
                    name = {
                        "Minecraft Launcher"
                        },},
      properties = { 
            tag = tag_names[2],
            placement = awful.placement.centered,
            floating=true }},
    -- # Tag 5 -- DC
    { rule = { class = "discord" },
      properties = { tag = tag_names[5] }},
    -- # Tag 8 -- Monitoring / OBS
    { rule_any = { class = {"obs"} },
        properties = { tag = tag_names[8] }},
    -- # Tag 9 -- Code
    { rule_any = { class = {"code-oss", "Lapce"} },
      properties = { tag = tag_names[9], maximized=true }},

    { rule = { maximized = true },     
      properties = { border_width = 1,
                    titlebars_enabled = false }}
}
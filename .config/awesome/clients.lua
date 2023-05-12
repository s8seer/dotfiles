local awful = require('awful')
local gears = require('gears')
local beautiful = require("beautiful")
require('awful.autofocus')
require("keys")
--tag_names = { "Main", "II", "III", "IV", "V", "VI", "VII", "VIII", "Code" }

awful.rules.rules = { -->> Rules
-- Use 'xprop' to see client info.
    { rule = { },     -- All clients.
      properties = { 
                      border_width = beautiful.border_width,
                      border_color = beautiful.border_normal,
                      focus = awful.client.focus.filter,
                      raise = true,
                      keys = clientkeys,
                      buttons = clientbuttons,
                      screen = awful.screen.preferred,
                      placement = awful.placement.centered
                    }
    },

    { rule_any =    { -- Floating clients.
                      instance = {
                                    "DTA",  
                                    "copyq",  
                                    "pinentry",
                                    "systemmonitor"
                                  },
                      class =     {
                                    "Pavucontrol", "QjackCtl", "Arandr", "Blueman-manager",
                                    "Gpick", "Kruler", "MessageWin", "Sxiv", "Wpa_gui",
                                    "veromix", "xtightvncviewer", "plasma.emojier"
                                  },
                      name =      { "Event Tester" },
                      role =      {
                                    "AlarmWindow",  
                                    "ConfigManager",
                                  }
                    },
      properties =  { 
                        floating = true,
                        placement = awful.placement.centered
                    }
    },

    { rule_any =    { -- Titlebar enabled.
                      type = {  "normal", "dialog" } 
                    },
      properties =  { titlebars_enabled = true }
    },
      
    { rule_any =    { -- Borders disabled
                      class =     {   
                                    "bottles",
                                    "battle.net-setup.exe",
                                    "battle.net setup.exe",
                                    "battle.net.exe",
                                    "steam.exe",
                                  },       
                      role =      {  "Popup" } },
      properties =  { 
                      border_width = 0,
                      titlebars_enabled = false 
                    }
    },

    { rule_any =    { -- krunner
                      class = {  "krunner" } 
                    },
      properties =  {
                      titlebars_enabled = false,
                      border_width = 0,
                      floating=true,
                      placement = awful.placement.no_offscreen 
                    }
    },

    { rule =        { -- Nemo Desktop
                      name = "Desktop",
                      class = "Nemo-desktop"
                    },
      properties =  {  
                      border_width = 0,
                      titlebars_enabled = false,
                      sticky = true,
                      tag = tag_names[1]
                      --tags = tag_names
                    }
    },

    { rule_any =    { -- # Tag 1 -- Main
                      class = { 
                                "firefox",
                                "Brave-browser",
                                "Opera"
                              }
                    },
      properties =  { 
                      tag = tag_names[1] 
                    }
    },
    
    { rule_any =    { -- # Tag 2 -- games
                      class = 
                              {    
                                "Lutris",
                                "Steam",
                                "steam",
                                "steam_app_291550",
                                "steam_app_1818750",
                                "minecraft-launcher",
                                "Minecraft Launcher",
                                "Minecraft*",
                                "battle.net.exe",
                                "bottles",
                                "steam.exe",
                                "overwatch.exe",
                              },
                      name =  {
                                "Minecraft Launcher"
                              },
                    },
      properties =  { 
                      tag = tag_names[2],
                      placement = awful.placement.centered,
                      --floating=true 
                    }
    },
    
    { rule_any =        { -- # Tag 5 -- DC
                      class = {
                                "discord",
                              },
                    },
      properties =  { 
                      tag = tag_names[5] 
                    }
    },
    
    { rule_any =    { -- # Tag 8 -- Monitoring / OBS
                      class =   {
                                  "obs",
                                } 
                    },
      properties =  { 
                      tag = tag_names[8] 
                    }
    },
    
    { rule_any =    { -- # Tag 9 -- Code
                      class =   {
                                  "code-oss",
                                  "Lapce",
                                } 
                    },
      properties =  {
                      tag = tag_names[9],
                      maximized=true,
                    }
    },

    { rule =        { -- Fallback fix for maximized borders
                      maximized = true 
                    },     
      properties =  { 
                      border_width = 1,
                      titlebars_enabled = false 
                    }
    }
}
-- If LuaRocks is installed, make sure that packages it are found. Else do nothing.
pcall(require, "luarocks.loader")
require("awful.autofocus")

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox") 
local naughty = require("naughty")
local xresources = require("beautiful.xresources")
local hotkeys_popup = require("awful.hotkeys_popup")
local dpi = xresources.apply_dpi
-- rofi -modi drun -show drun -show-icons -width 22 -no-click-to-exit`

tag_names = { "Main", "II", "III", "IV", "V", "VI", "VII", "VIII", "Code" }

local chosen_theme = "buoyance"
--local chosen_theme = "2d_theme"

local chosen_theme_dir = gears.filesystem.get_configuration_dir().."themes/"..chosen_theme.."/"
local beautiful = require("beautiful")
beautiful.init(chosen_theme_dir.."theme.lua")

require("keys")
require("clients")
require("widgets.awesome-remember-geometry")
local fs_widget = require("widgets.fs-widget")
local calendar_widget = require("widgets.calendar")
local volume_widget = require('widgets.pactl-widget.volume')
local pacman_widget = require('widgets.pacman-widget.pacman')
local kbdcfg = require('widgets.kbdcfg')
local kbdcfg = kbdcfg({tui_wrap_left = "[", tui_wrap_right = "]" })
local net_speed_widget = require("widgets.net-speed-widget.net-speed")

local fancy_taglist = require("themes/"..chosen_theme.."/widgets/fancy_taglist")
local theme_tasklist = require ("themes/"..chosen_theme.."/widgets/theme_tasklist")


if awesome.startup_errors then -- Execute fallback config if needed
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Err: Config",
                     text = awesome.startup_errors })
end
do  -- Handle runtime errors after startup
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end in_error = true
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Err:",
                         text = tostring(err) })
        in_error = false
        end)
end

awful.screen.set_auto_dpi_enabled(true)
awesome.set_preferred_icon_size(32)

HOUSE = os.getenv("HOME")

terminal = "kitty"
volume_controller = "pavucontrol"
selection_screenshot = HOUSE.."/.config/awesome/scripts/scropy2.sh"
full_screenshot = HOUSE.."/.config/awesome/scripts/scrofull.sh"
script_sysman = 'kitty -o window_padding_width=0 --name="systemmonitor" --title="System Monitor" btop'

awful.layout.layouts = { -->> Layouts, layout widget is hidden regardless
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}

naughty.config.spacing = dpi(10)
naughty.config.defaults.margin = dpi(8)
naughty.config.defaults.border_width = 3
naughty.config.defaults.hover_timeout = 100
naughty.config.presets.critical.fg = beautiful.bg_urgent
naughty.config.presets.critical.bg = beautiful.fg_urgent
naughty.config.presets.critical.border_color = beautiful.bg_urgent

-- Widgets

local spacer = wibox.widget.textbox(" ")
local configdir = HOUSE.."/.config"
local config_awesome = "code "..configdir.."/awesome/ "
local config_awestart = "kate "..configdir.."/awesome/scripts/autorun.sh"
local config_picom = "kate "..configdir.."/picom/picom.conf"
local config_kitty = "kate " ..configdir.."/kitty/kitty.conf"
powermenu = awful.menu({ items = { 
    { " Log off", function() awesome.quit() end, beautiful.logout_icon},
    { " Reboot", "systemctl reboot", beautiful.reload_icon},
    { " Shutdown", "systemctl poweroff", beautiful.shutdown_icon},
    }})
mymainmenu_items =  { 
    { "Config",         {
                            {   "awesome Conf",         config_awesome                                  },
                            {   "awesome Autostart",    config_awestart                                 },
                            {   "Picom Conf.",          config_picom                                    },
                            {   "Kittyrc.",             config_kitty                                    },
                            
                        },                                                              beautiful.computer_icon},
    { " Help",          function() hotkeys_popup.show_help() end,                       beautiful.question_icon},
    { " Reload",        awesome.restart,                                                beautiful.reload_icon},
    { " Poweroptions*", function() powermenu:toggle{coords = {x = 0,y = 0}} end,        beautiful.shutdown_icon},
    }

mymainmenu = awful.menu({ items = mymainmenu_items})
kbdcfg.add_primary_layout("English", "en", "us")
kbdcfg.add_primary_layout("Turkish", "tr", "tr")
kbdcfg.bind()
kbdcfg.widget:buttons(
 	awful.util.table.join(awful.button({ }, 1, function () kbdcfg.switch_next() end))
)
systray = wibox.widget.systray()
systray:set_base_size(24)
local tray = wibox.widget {
	systray,
	margins = 2,
	widget = wibox.container.margin
}
mytextclock = wibox.widget.textclock(' %F %a %b, %H:%M ')
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

local cw = calendar_widget({
    placement = 'top_right',
    start_sunday = false,})

mytextclock:connect_signal("button::press", function(_, _, _, button)
                            if button == 1 then cw.toggle() end end)
mylauncher:buttons(gears.table.join(
    awful.button({  }, 1, function () mymainmenu:toggle{coords = {x = 0,y = 0}} powermenu:hide() end)
    )) 
--  --

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        gears.wallpaper.maximized(wallpaper, s, false) end
        --gears.wallpaper.fit(wallpaper, s) end
        --gears.wallpaper.tiled(wallpaper, s) end
end

screen.connect_signal("property::geometry", set_wallpaper)
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
    
    local l = awful.layout.suit
    local main_layout = l.tile.right
    local layouts = { main_layout, l.floating, main_layout, main_layout, main_layout,
                            main_layout, main_layout, main_layout, main_layout }
    awful.tag(tag_names, s, layouts)
    s.mypromptbox = awful.widget.prompt({ prompt = " Run: "})
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end)))
    s.mytaglist = fancy_taglist.new({ screen = s, taglist_buttons = taglist_buttons })
    s.mytasklist = theme_tasklist.new({ screen = s, tasklist_buttons = tasklist_buttons })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = beautiful.wibar_position, screen = s, height = beautiful.wibar_height })
    s.mywibox:setup { -- Widgets
        layout = wibox.layout.align.horizontal,
        {             -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            wibox.widget{
                s.mypromptbox,
                margins = 2,
                widget = wibox.container.margin
            }
            
        },
        
        s.mytasklist, -- Middle widget
        
        {             -- Right widgets
            spacer,  
            pacman_widget(),
            kbdcfg.widget,
            tray,
            --net_speed_widget(),
            --spacer, volume_widget{ widget_type = 'icon', tooltip = true },
            volume_widget{ widget_type = 'horizontal_bar' },
            --fs_widget({ mounts = { '/', '/mnt/table' } }),
            mytextclock,
            s.mylayoutbox,
            layout = wibox.layout.fixed.horizontal,
        },
	}
end)

root.keys(globalkeys)

-->> Signals
client.connect_signal("manage", function (c)
    if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c) end
end)



client.connect_signal("request::titlebars", function(c)

    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c) end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c) end))

    awful.titlebar(c, {size = beautiful.titlebar_size}) : setup {
        { -- Left
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal},
        { -- Middle
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal},
        { -- Right            
            layout = wibox.layout.fixed.horizontal()},
        layout = wibox.layout.align.horizontal}
end)

-- Autorun
awful.util.spawn_with_shell( HOUSE.."/.config/awesome/scripts/autorun.sh" )

-- No border for maximized clients 
-- src: https://github.com/micro-hawk/awesomeWM/blob/master/rc.lua & modified slightly
function border_adjust(c)
    if c.maximized then
        awful.titlebar(c, {size = 0})
        c.border_width = 1
    else
        awful.titlebar(c, {size = beautiful.titlebar_size})
        c.border_width = beautiful.border_width
    end
end

awful.mouse.snap.edge_enabled = false

client.connect_signal("property::maximized", border_adjust)
client.connect_signal("focus", function(c) 
    c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) 
    c.border_color = beautiful.border_normal end)
-- }}}
-- Goodbye.

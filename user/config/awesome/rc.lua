-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
require("awful.autofocus")
tag_names = { "Main", "II", "III", "IV", "V", "VI", "VII", "VIII", "Code" }
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox") 
local naughty = require("naughty")

local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "2d_theme/2d_theme.lua")

local hotkeys_popup = require("awful.hotkeys_popup")

require("clients")
require("keys")
local kbdcfg = require('widgets.kbdcfg')
local kbdcfg = kbdcfg({tui_wrap_left = " < ", tui_wrap_right = " > " })
local fancy_taglist = require("widgets.fancy_taglist")
local calendar_widget = require("widgets.calendar-widget.calendar")

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

-- Widgets
powermenu = awful.menu({ items = { 
    { " Log off", function() awesome.quit() end, beautiful.logout_icon},
    { " Reboot", "systemctl reboot", beautiful.reload_icon},
    { " Shutdown", "systemctl poweroff", beautiful.shutdown_icon},
    }})
mymainmenu = awful.menu({ items = { 
    { " Files", "dolphin", beautiful.computer_icon},
    { " Firefox", "firefox", beautiful.firefox_icon},
    { " Help", function() hotkeys_popup.show_help() end, beautiful.question_icon},
    { " Reload", awesome.restart, beautiful.reload_icon},
    { " Poweroptions", function() powermenu:toggle{coords = {x = 0,y = 0}} end, beautiful.shutdown_icon},
    }})
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
        gears.wallpaper.maximized(wallpaper, s, true) end
end

screen.connect_signal("property::geometry", set_wallpaper)
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
    
    local l = awful.layout.suit
    local main_layout = l.tile.right
    local layouts = { main_layout, l.floating, main_layout, main_layout, main_layout,
                    main_layout, main_layout, main_layout, main_layout }
    awful.tag(tag_names, s, layouts)
    s.mypromptbox = awful.widget.prompt()
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end)))
    s.mytaglist = fancy_taglist.new({ screen = s, taglist_buttons = taglist_buttons })
--  s.mytaglist = awful.widget.taglist{ screen  = s, filter  = awful.widget.taglist.filter.all, buttons = taglist_buttons }
    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        layout   = {
            spacing = 4,
            layout  = wibox.layout.fixed.horizontal },
        widget_template = { 
            {
                {     
					{
						{id = 'icon_role',   widget = wibox.widget.imagebox, },
						margins = 2,  widget  = wibox.container.margin, 
					},
					{ right = 6,        widget = wibox.container.margin },  -- Comment out these 2 lines for
					{ id = 'text_role', widget = wibox.widget.textbox, },   -- Icons only task list
					layout = wibox.layout.fixed.horizontal, 
                },
                left  = 8, right = 10, widget = wibox.container.margin 
            },
                id     = 'background_role',
                widget = wibox.container.background, }, }
    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = beautiful.wibar_height })
    s.mywibox:setup { -- Widgets
        layout = wibox.layout.align.horizontal,
        {             -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.textbox,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        {             -- Right widgets
            layout = wibox.layout.fixed.horizontal,
			kbdcfg.widget,
            tray,
            mytextclock,
            --s.mylayoutbox,
        },
		}
end)

root.buttons(gears.table.join( -->> Desktop mouse bindings
    awful.button({ }, 1, function () mymainmenu:hide() end),
    awful.button({ }, 3, function () mymainmenu:toggle() end)
))

-->> You can get key names via running:
-- xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'

local function switch(direction)
    local s = awful.screen.focused()
    local tags = s.tags

    for i = s.selected_tag.index, direction > 0 and #tags or 1, direction do
        local t = tags[i]
        if #t:clients() > 0 then
            t:view_only()
            return
        end
    end
end

for i = 1, #tag_names do -->> Tag key bindings.
    globalkeys = gears.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9, -- View tag
                  function ()
                  local screen = awful.screen.focused()
                  local tag = screen.tags[i]
                  if tag then tag:view_only()
                  end end,
                  {description = "View tag", group = "tag"}),
        
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, -- Toggle tag
                  function ()
                  local screen = awful.screen.focused()
                  local tag = screen.tags[i]
                  if tag then awful.tag.viewtoggle(tag)
                  end end,
                  {description = "Toggle tag", group = "tag"}),

        awful.key({ modkey, "Shift" }, "#" .. i + 9, -- Move to tag
                  function () if client.focus then
                  local tag = client.focus.screen.tags[i]
                  if tag then client.focus:move_to_tag(tag)
                  end end end,
                  {description = "Move client to tag", group = "tag"}),
                  
        awful.key({ modkey, "Control" }, "#" .. i + 9, -- Duplicate to tag
                  function () if client.focus then
                  local tag = client.focus.screen.tags[i]
                  if tag then client.focus:toggle_tag(tag)
                  end end end,
                  {description = "Add client to tag", group = "tag"}))
end


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

-- Focus follows mouse.
--client.connect_signal("mouse::enter", function(c) c:emit_signal("request::activate", "mouse_enter", {raise = false}) end)

-- No border for maximized clients -- src: https://github.com/micro-hawk/awesomeWM/blob/master/rc.lua & modified slightly
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

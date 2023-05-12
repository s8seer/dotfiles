-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
require("awful.autofocus")

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox") 
local naughty = require("naughty")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")

local calendar_widget = require("widgets.calendar-widget.calendar")
local logout_menu_widget = require("widgets.logout-menu-widget.logout-menu")

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
beautiful.init(gears.filesystem.get_configuration_dir() .. "2d_theme.lua")

HOUSE = os.getenv("HOME")

modkey = "Mod4"
altkey = "Mod1"
terminal = "kitty"
volume_controller = "pavucontrol"
selection_screenshot = HOUSE.."/.config/awesome/scripts/scropy2.sh"
full_screenshot = HOUSE.."/.config/awesome/scripts/scrofull.sh"
script_sysman = 'kitty btop'

awful.layout.layouts = { -->> Layouts, layout widget is hidden regardless
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}

-- Widgets
local logout_menu = logout_menu_widget()
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
    --{ " Log off", function() awesome.quit() end, beautiful.logout_icon},
    --{ "Shutdown", "systemctl poweroff", beautiful.shutdown_icon},
    }})
mykeyboardlayout = awful.widget.keyboardlayout()
mytextclock = wibox.widget.textclock(' %F %a %b, %H:%M ')
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

local cw = calendar_widget({
    placement = 'top_right',
    start_sunday = false,
})

mytextclock:connect_signal("button::press", function(_, _, _, button)
                            if button == 1 then cw.toggle() end end)
mylauncher:buttons(gears.table.join(
    awful.button({ }, 1, function () mymainmenu:toggle{coords = {x = 0,y = 0}} powermenu:hide() end)
    --awful.button({ }, 3, function () mymainmenu:toggle{coords = {x = 0,y = 0}} end) --logout_menu.toggle()
    )) 
--  --


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end))
local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                            if c == client.focus then
                                c.minimized = true
                            else
                                c:emit_signal(
                                "request::activate",
                                "tasklist",
                                {raise = true}) end end))
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s) end
        gears.wallpaper.maximized(wallpaper, s, true) end
end
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
    tag_names = { "Main", "II", "III", "IV", "V", "VI", "VII", "VIII", "Code" }
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
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }
    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        layout   = {
            spacing = 1,
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = { { {
                { { id = 'icon_role', widget = wibox.widget.imagebox, },
                    margins = 2, widget  = wibox.container.margin, },
                { right = 6, widget = wibox.container.margin },         -- Comment out these 2 lines for
                { id = 'text_role', widget = wibox.widget.textbox, },   -- Icons only task list
                layout = wibox.layout.fixed.horizontal, },
                left  = 8,
                right = 10,
                widget = wibox.container.margin 
                },
                id     = 'background_role',
                widget = wibox.container.background, },
    }
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
            mykeyboardlayout,
            logout_menu_widget(),
            wibox.widget.systray(),
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



globalkeys = gears.table.join( -->> Key bindings

    awful.key({ modkey, "Shift"   }, "Prior",   awful.tag.viewprev,
              {description = "Go previous tag", group = "tag"}),

    awful.key({ modkey, "Shift"   }, "Next",  awful.tag.viewnext,
              {description = "Go next tag", group = "tag"}),

    awful.key({ modkey,           },  "Prior", function ()
              local focused =  awful.screen.focused() 
              for i = 1, #focused.tags do awful.tag.viewidx(-1, focused)
              if #focused.clients > 0 then return end end end,
              {description = "Go previous occupied tag", group = "tag"}),

    awful.key({ modkey,           }, "Next", function ()
              local focused =  awful.screen.focused() 
              for i = 1, #focused.tags do awful.tag.viewidx(1, focused)
              if #focused.clients > 0 then return end end end,
              {description = "Go next occupied tag", group = "tag"}),

    awful.key({ modkey,           }, "Tab", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- By direction client focus
    awful.key({ modkey }, "j", function()
              awful.client.focus.global_bydirection("down")
              if client.focus then client.focus:raise() end end,
              {description = "focus down", group = "client"}),

    awful.key({ modkey }, "k", function()
              awful.client.focus.global_bydirection("up")
              if client.focus then client.focus:raise() end end,
              {description = "focus up", group = "client"}),
        
    awful.key({ modkey }, "h", function()
              awful.client.focus.global_bydirection("left")
              if client.focus then client.focus:raise() end end,
              {description = "focus left", group = "client"}),

    awful.key({ modkey }, "l", function()
              awful.client.focus.global_bydirection("right")
              if client.focus then client.focus:raise() end end,
              {description = "focus right", group = "client"}),
    -- --

    awful.key({ modkey,           }, "End", awful.client.urgent.jumpto,
              {description = "Focus urgent client", group = "client"}),

    -- Window Moving
    awful.key({ modkey, "Shift"   }, "h", function (c)
              awful.client.swap.global_bydirection("left") end,
              {description = "swap with left client", group = "Windows > Relative"}),

    awful.key({ modkey, "Shift"   }, "l", function (c)
              awful.client.swap.global_bydirection("right") end,
              {description = "swap with right client", group = "Windows > Relative"}),

    awful.key({ modkey, "Shift"   }, "j", function (c)
              awful.client.swap.global_bydirection("down") end,
              {description = "swap with down client", group = "Windows > Relative"}),

    awful.key({ modkey, "Shift"   }, "k", function (c)
              awful.client.swap.global_bydirection("up") end,
              {description = "swap with up client", group = "Windows > Relative"}),
    -- --
    -- Relative Windows
    awful.key({ altkey,   }, "`", function ()
              awful.client.focus.byidx(1) end,
              {description = "Focus next by index", group = "Windows > Relative"}), 

    awful.key({ altkey, "Shift"   }, "`", function ()
              awful.client.focus.byidx(-1) end,
              {description = "Focus prev by index", group = "Windows > Relative"}), 

    awful.key({ altkey,           }, "Tab", function ()
              awful.client.focus.history.previous()
              if client.focus then client.focus:raise() end end,
              {description = "go back", group = "Windows > Relative"}),
    -- --
    -- Window Manager
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
        {description="show help", group="AwesomeWM"}),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "AwesomeWM"}),
    -- --

    -- System > Launcher
    awful.key({ modkey,           }, "Return", function () 
              awful.util.spawn_with_shell(terminal) end,
              {description = "Start terminal", group = "System > Launcher"}),
    awful.key({ modkey,           }, "r",     function () 
              awful.screen.focused().mypromptbox:run() end,
              {description = "Run prompt", group = "System > Launcher"}),
    awful.key({ "Control",       }, "Escape", function ()
              awful.util.spawn_with_shell(script_sysman) end,
              {description = "System manager", group = "System > Launcher"}),
    awful.key({ modkey,           }, "q", function ()
              awful.util.spawn_with_shell(volume_controller) end,
              {description = "Volume controller", group = "System > Launcher"}),              
    awful.key({ modkey,           }, "space", function ()
                mymainmenu:toggle{coords = {x = 0,y = 0}} end,
                {description = "Show menu", group = "System > Launcher"}),
    awful.key({ altkey            }, "space", function () 
                awful.util.spawn_with_shell("krunner") end,
                {description = "Start krunner.", group = "System > Launcher"}),  
    -- --

    awful.key({                   }, "Print", function () 
                awful.util.spawn_with_shell(selection_screenshot) end,
                {description = "Selection area screenshot.", group = "Screen > Screenshot"}),
    awful.key({ "Control"         }, "Print", function () 
                awful.util.spawn_with_shell(full_screenshot) end,
                {description = "Take a fullscreenshot.", group = "Screen > Screenshot"}),                

    -- App Shortcuts
    awful.key({ modkey            }, "e", function () 
                awful.util.spawn_with_shell("dolphin") end,
                {description = "Start file manager.", group = "System > Apps Shortcuts"}),  
    --

    -- Layout

    awful.key({ modkey, altkey    }, "Right", function () awful.layout.inc( 1) end,
              {description = "select next", group = "layout"}),

    awful.key({ modkey, altkey    }, "Left", function () awful.layout.inc(-1) end,
              {description = "select previous", group = "layout"}),
    -- -- 

    awful.key({ modkey, "Shift" }, "d", function () -- Focus restored client
              local c = awful.client.restore()
              if c then
                c:emit_signal( "request::activate", "key.unminimize",
              {raise = true}) end end,
              {description = "restore minimized", group = "client"})
)

clientkeys = gears.table.join(
    awful.key({ altkey,           }, "Return", function (c)
              c.fullscreen = not c.fullscreen 
              c:raise() end,
              {description = "toggle fullscreen", group = "client"}),

    awful.key({ modkey,           }, "w",      function (c)
              c:kill() end,
              {description = "close", group = "client"}),

    awful.key({ modkey,           }, "f",      function(c) 
              c.maximized = false 
              awful.placement.no_offscreen()
              awful.client.floating.toggle()
              end,
              {description = "Toggle floating", group = "Windows > Floats"}),

    awful.key({modkey}, "Down", function ()
              awful.placement.centered(client.focus, 
              {honor_workarea = true}) end, 
              {description = 'Center a floating window', group = 'Windows > Floats' }),

    -- Moving Floating Windows
    awful.key({ modkey, "Shift"   }, "Down", function (c)
              c:relative_move(  0,  100,   0,   0) end,
              {description = "Floating Move Down", group = "Windows > Floats"}),
    awful.key({ modkey, "Shift"   }, "Up", function (c)
              c:relative_move(  0, -100,   0,   0) end,
              {description = "Floating Move Up", group = "Windows > Floats"}),
    awful.key({ modkey, "Shift"   }, "Left", function (c)
              c:relative_move(-100,   0,   0,   0) end,
              {description = "Floating Move Left", group = "Windows > Floats"}),
    awful.key({ modkey, "Shift"   }, "Right", function (c)
              c:relative_move( 100,   0,   0,   0) end,
              {description = "Floating Move Right", group = "Windows > Floats"}),
    -- --
    -- Resize Windows
    awful.key({ modkey, "Control" }, "Up", function (c)
              c:relative_move( 0, 0, 0, -100) end,
              {description = "Floating - size vertical", group = "Windows > Floats"}),

    awful.key({ modkey, "Control" }, "Down", function (c)
              c:relative_move( 0, 0, 0,  100) end,
              {description = "Floating + size vertical", group = "Windows > Floats"}),

    awful.key({ modkey, "Control" }, "Left", function (c)
              c:relative_move( 0, 0, -100, 0) end,
              {description = "Floating - size horizontal ", group = "Windows > Floats"}),

    awful.key({ modkey, "Control" }, "Right", function (c)
              c:relative_move( 0, 0,  100, 0) end,
              {description = "Floating + size horizontal", group = "Windows > Floats"}),

    awful.key({ modkey, "Control" }, "k", function (c)
              awful.client.incwfact(0.025) end,
              {description = "Resize Vertical -", group = "Windows > Relative"}),

    awful.key({ modkey, "Control" }, "j", function (c)
              awful.client.incwfact(-0.025) end,
              {description = "Resize Vertical +", group = "Windows > Relative"}),

    awful.key({ modkey, "Control" }, "h", function (c)
              awful.tag.incmwfact(-0.025) end,
              {description = "Resize Horizontal -", group = "Windows > Relative"}),

    awful.key({ modkey, "Control" }, "l", function (c)
              awful.tag.incmwfact(0.025) end,
              {description = "Resize Horizontal +", group = "Windows > Relative"}),
    -- -- 

    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop end,
              {description = "toggle keep on top", group = "client"}),

    awful.key({ modkey, "control"        }, "d", function (c)
              c.minimized = true end,
              {description = "minimize", group = "client"}),

    awful.key({ modkey,           }, "m", function (c)
              c.maximized = not c.maximized
              c:raise() end,
              {description = "(un)maximize", group = "client"}),

    awful.key({ modkey, "Control" }, "m", function (c)
              c.maximized_vertical = not c.maximized_vertical
              c:raise() end,
              {description = "(un)maximize vertically", group = "client"}),

    awful.key({ modkey, "Shift"   }, "m", function (c)
              c.maximized_horizontal = not c.maximized_horizontal
              c:raise() end,
              {description = "(un)maximize horizontally", group = "client"}),
    awful.key({ modkey,           }, "a", function (c)
              c.sticky = not c.sticky
              if c.sticky then c.floating = true
              else c.floating = false end end,
              {description = "Toggle sticky to tags and float.", group = "Windows Manage Global"})
)

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

clientbuttons = gears.table.join( -->> Mouse bindings.
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
    end)
)
root.keys(globalkeys)

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
                 placement = awful.placement.no_offscreen
}},
{ rule_any = { -- Floating clients.
    instance = {
      "DTA",  
      "copyq",  
      "pinentry",
    },
    class = {
      "Pavucontrol",
      "QjackCtl",
      "Arandr",
      "Blueman-manager",
      "Gpick",
      "Kruler",
      "MessageWin",  
      "Sxiv",
      "Tor Browser", 
      "Wpa_gui",
      "veromix",
      "xtightvncviewer",
      "vlc"      
    },
    name = {
      "Event Tester", 
    },
    role = {
      "AlarmWindow",  
      "ConfigManager",  
      "pop-up",      
    }},
  properties = { 
        floating = true,
        placement = awful.placement.centered}},

{ rule_any = { -- Titlebar enabled.
  type = {  "normal", "dialog" } },
  properties = { titlebars_enabled = true }},

{ rule_any = { -- krunner
  class = {  "krunner" } },
  properties = { titlebars_enabled = false,
                 border_width = 0,
                 floating=true,
                 placement = awful.placement.no_offscreen }},

{ rule = { class = "firefox" }, -- Tag 1
  properties = { tag = tag_names[1] }},

{ rule = { class = "discord" }, -- Tag 5 DC
  properties = { tag = tag_names[5] }},

{ rule_any = { class = {        -- Tag 2
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

{ rule = { class = "code-oss" }, -- Tag 9
  properties = { tag = tag_names[9] }},

{ rule = { maximized = true },     
  properties = { border_width = 1,
                 titlebars_enabled = false }}
}

-->> Signals
client.connect_signal("manage", function (c)
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
client.connect_signal("mouse::enter", function(c) c:emit_signal("request::activate", "mouse_enter", {raise = false}) end)

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
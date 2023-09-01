local awful = require('awful')
local gears = require("gears")
local wibox = require("wibox")
require('awful.autofocus')

local switcher = require("widgets.awesome-switcher")
local hotkeys_popup = require('awful.hotkeys_popup').widget
-->> You can get key names via running:
-- xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'

modkey = "Mod4"
altkey = "Mod1"

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
              switcher.switch( 1, "Mod1", "Alt_L", "Shift", "Tab") end,
              {description = "Tab forwards windows", group = "Windows > Relative"}),

    awful.key({ altkey, "Shift"   }, "Tab", function ()
              switcher.switch(-1, "Mod1", "Alt_L", "Shift", "Tab") end,
              {description = "Tab backwards windows", group = "Windows > Relative"}),
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
           
    awful.key({ modkey,           }, "space", function ()
                mymainmenu:toggle{coords = {x = 0,y = 0}} end,
                {description = "Show menu", group = "System > Launcher"}),
    awful.key({ altkey            }, "space", function () 
                awful.util.spawn_with_shell("krunner") end,
                {description = "Start krunner.", group = "System > Launcher"}),  
    -- --

    awful.key({                   }, "Print", function () 
                awful.util.spawn_with_shell(selection_screenshot) end,
                {description = "Selection area screenshot.", group = "Peripherals > Screen"}),
    awful.key({ "Control"         }, "Print", function () 
                awful.util.spawn_with_shell(full_screenshot) end,
                {description = "Take a fullscreenshot.", group = "Peripherals > Screen"}),                

    awful.key({                   }, "XF86AudioMute", function()
                os.execute("amixer -q set Capture toggle") end,
                {description = "Mute microphone.", group = "Peripherals > Volume"}),   
    awful.key({ modkey,           }, "q", function ()
              awful.util.spawn_with_shell(volume_controller) end,
              {description = "Launch Pavucontrol.", group = "Peripherals > Volume"}),   
    
    -- App Shortcuts
    awful.key({ modkey            }, "e", function () 
                awful.util.spawn_with_shell("dolphin") end,
                {description = "Start file manager.", group = "System > Apps Shortcuts"}),  
    awful.key({ modkey            }, "period", function () 
                awful.util.spawn_with_shell("plasma-emojier") end,
                {description = "Pick and use emojis.", group = "System > Apps Shortcuts"}),
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

root.buttons(gears.table.join( -->> Desktop mouse bindings
    awful.button({ }, 1, function () mymainmenu:hide() end),
    awful.button({ }, 3, function () mymainmenu:toggle() end)
))

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
    awful.key({ modkey,           }, "a", function (c)
              c.sticky = not c.sticky
              if c.sticky then c.floating = true
              else c.floating = false end end,
              {description = "Toggle sticky to tags and float.", group = "Windows Manage Global"})
)

clientbuttons = gears.table.join( -->> Mouse bindings.
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        --c:emit_signal("request::activate", "mouse_click", {raise = false})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        --c:emit_signal("request::activate", "mouse_click", {raise = false})
        awful.mouse.client.resize(c)
    end)
)

taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end))

tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                            if c == client.focus then c.minimized = true
                            else c:emit_signal( "request::activate", "tasklist",
                        {raise = true}) end end),
                        awful.button({ }, 2, function (c) c:kill() end))

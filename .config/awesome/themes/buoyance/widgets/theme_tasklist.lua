local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local module = {}

function module.new(config)
	local cfg = config or {}

	local s = cfg.screen or awful.screen.focused()
	local tasklist_buttons = cfg.tasklist_buttons

	return awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        style    = { shape  = gears.shape.rounded_bar },
        widget_template = {{ 
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
                left  = 10, right = 10, widget = wibox.container.margin 
            },
            id     = 'background_role',
            widget = wibox.container.background, 
        },
            margins = 3,
            widget = wibox.container.margin,
        }, 
    }
end

return module 

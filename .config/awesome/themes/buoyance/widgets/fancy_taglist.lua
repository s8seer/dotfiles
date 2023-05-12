-- awesomewm fancy_taglist: a taglist that contains a tasklist for each tag.
-- https://gist.github.com/intrntbrn/08af1058d887f4d10a464c6f272ceafa & modified.
-- Usage:
-- 1. Save as "fancy_taglist.lua" in ~/.config/awesome
-- 2. Add a fancy_taglist for every screen:
--          awful.screen.connect_for_each_screen(function(s)
--              ...
--              local fancy_taglist = require("fancy_taglist")
--              s.mytaglist = fancy_taglist.new({
--                  screen = s,
--                  taglist_buttons = mytagbuttons,
--                  tasklist_buttons = mytasklistbuttons
--              })
--              ...
--          end)
-- 3. Add s.mytaglist to your wibar.

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local module = {}

local generate_filter = function(t)
	return function(c, scr)
		local ctags = c:tags()
		for _, v in ipairs(ctags) do
			if v == t then
				return true
			end
		end
		return false
	end
end

local fancytasklist = function(cfg, t)
	return awful.widget.tasklist({
		screen = cfg.screen or awful.screen.focused(),
		filter = generate_filter(t),
		buttons = cfg.tasklist_buttons,
		widget_template = {
			{
				{id = 'icon_role',   widget = wibox.widget.imagebox, },
				left = 4, right = 0,  widget  = wibox.container.margin, 
			},
			layout = wibox.layout.stack,
		},
	})
end

function module.new(config)
	local cfg = config or {}

	local s = cfg.screen or awful.screen.focused()
	local taglist_buttons = cfg.taglist_buttons

	return awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		style   = { shape = gears.shape.rounded_bar },
		widget_template = {{
			{
				{	-- taglist
					{ 
					
						{
							id = "text_role",
							widget = wibox.widget.textbox,
							align = "center",
						},
						
						{ 	-- icons
							id = "tasklist_placeholder",
							layout = wibox.layout.fixed.horizontal,
						},
						layout = wibox.layout.fixed.horizontal,
					},
					margins = 3,
					widget = wibox.container.margin 
				},
				left  = 6,
				right = 6,
				widget = wibox.container.margin
			},
			id     = 'background_role',
        	widget = wibox.container.background,
			},
			margins = 3,
			widget = wibox.container.margin,
			create_callback = function(self, c3, index, objects)
				local t = s.tags[index]
				self:get_children_by_id("tasklist_placeholder")[1]:add(fancytasklist(cfg, t))
			end,
		},
		buttons = taglist_buttons,
	})
end

return module
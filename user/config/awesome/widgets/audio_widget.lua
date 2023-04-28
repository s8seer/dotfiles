
-- I'm not planning to use this right now,
-- so this'll be left here as of now.
-- Source is from https://github.com/ronit1996/AwesomeWM-arch/blob/main/rc.lua
-- and is altered slightly.

local cornerRadius = 10

local leftRoundedRectangle = function (cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, true, false, false, true, cornerRadius)

end

local leftRoundedRectangle = function (cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, true, false, false, true, cornerRadius)

end

local rightRoundedRectangle = function (cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, false, true, true, false, cornerRadius)
end

local text_volume= wibox.widget{
    widget=wibox.widget.textbox
}

local update_volume = function (vol)
    text_volume.text = "Vol: " .. vol
end

local container_volume_widget = {
    {
        {       text_volume,
                left = 10,
		right = 10,
		--top = 6,
		--bottom = 6,
		widget = wibox.container.margin,
		},
		shape = leftRoundedRectangle,
		--fg = "#fab387",
		bg = "#181825",
		widget = wibox.container.background,
	},
        top = 2,
        bottom = 2,
        widget = wibox.container.margin,
}

local volume_bar = wibox.widget{
    max_value = 200,
    shape = gears.shape.rounded_bar,
    forced_height = 2,
    forced_width = 100,
    border_width = 0,
    background_color = "#1e1e2e",
    color = "#fab387",
    widget = wibox.widget.progressbar,
}

gears.timer {
    timeout = 0.5,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async("pamixer --get-volume", function (stdout)
    local vol = stdout
    update_volume(vol)
    volume_bar.value=tonumber(vol)

end) end }

local container_volume_bar = {
    {
        {       volume_bar,
                left = 0,
		right = 10,
		top = 7,
		bottom = 7,
		widget = wibox.container.margin,
		},
		shape = rightRoundedRectangle,
		fg = "#fab387",
		bg = "#181825",
		widget = wibox.container.background,
	},
        top = 2,
        bottom = 2,
        widget = wibox.container.margin,
}

volume_widget = { -- You should call this widget
    container_volume_widget,
    container_volume_bar,
    layout=wibox.layout.fixed.horizontal
}



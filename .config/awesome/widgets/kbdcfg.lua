--[[
     Licensed under MIT
     * (c) 2017, Egor Churaev egor.churaev@gmail.com
        https://github.com/echuraev/keyboard_layout
--]]

local awful = require("awful")
local wibox = require("wibox")
local kbdcfg = {}

-- Function to change current layout to the next available layout
function kbdcfg.switch_next()
    kbdcfg.current = kbdcfg.current % #(kbdcfg.layouts) + 1
    kbdcfg.switch(kbdcfg.layouts[kbdcfg.current])
end

-- Function to find layout in list and set current index
local function find_current_layout(name)
    for index, layout in ipairs(kbdcfg.layouts) do
        if layout.name == name then
            return index, layout
        end
    end
    return nil, nil
end

-- Function to change layout
function kbdcfg.switch(layout)
    local index = find_current_layout(layout.name)
    kbdcfg.current = index
    kbdcfg.widget:set_text(kbdcfg.tui_wrap_left .. layout.label .. kbdcfg.tui_wrap_right)

    os.execute(kbdcfg.cmd .. " \"" .. layout.subcmd .. "\"")
end

-- Function to add primary layouts
function kbdcfg.add_primary_layout(name, label, subcmd)
    local layout = { name   = name,
                     label  = label,
                     subcmd = subcmd };

    table.insert(kbdcfg.layouts, layout)
end

-- Bind function. Applies all settings to the widget
function kbdcfg.bind()
    kbdcfg.widget = wibox.widget.textbox()

    if kbdcfg.default_layout_index > #kbdcfg.layouts then
        kbdcfg.default_layout_index = 1;
        kbdcfg.current = kbdcfg.default_layout_index;
    end

    local current_layout = kbdcfg.layouts[kbdcfg.current]
    if current_layout then
        kbdcfg.switch(current_layout)
    end
end

-- Factory function. Creates the widget.
local function factory(args)
    local args                   = args or {}
    kbdcfg.cmd                   = args.cmd or "setxkbmap"
    kbdcfg.layouts               = args.layouts or {}
    kbdcfg.default_layout_index  = args.default_layout_index or 1
    kbdcfg.current               = args.current or kbdcfg.default_layout_index
    kbdcfg.tui_wrap_left         = args.tui_wrap_left  or " "
    kbdcfg.tui_wrap_right        = args.tui_wrap_right or " "
    kbdcfg.remember_layout       = args.remember_layout or false

    for i = 1, #kbdcfg.layouts do
        table.insert({}, kbdcfg.layouts[i])
    end

    return kbdcfg
end

setmetatable(kbdcfg, { __call = function(_, ...) return factory(...) end })

return kbdcfg

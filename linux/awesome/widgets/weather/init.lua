--[[ Docstring

    Widget to check the weather periodically

    (c) Copyright 2023, Abiel Mendes (<https://github.com/paodelonga>)
    https://github.com/paodelonga/awesome-widgets/tree/main/widgets/weather

--]]

-- widgets.weather

local async = require("lain.helpers").async
local newtimer = require("lain.helpers").newtimer
local wibox = require("wibox")
local fontfg = require("lain").util.markup.fontfg

local function Widget(arguments)
    local Weather = {
        widget = wibox.widget({
            layout = wibox.layout.align.horizontal,
            {
                id = "wtextbox",
                widget = wibox.widget.textbox,
            },
        }),
    }

    local args = arguments or {}
    local timeout = args.timeout or 900
    local font = args.font or { name = "Noto Mono 9", color = "#FAFAFA" }
    local command = "curl -s https://wttr.in/?format=%t"

    local function checkWeather()
        async(command, function(stdout)
            if string.match(stdout, "[-+]%d+°[CF]") then
                Weather.widget
                    :get_children_by_id("wtextbox")[1]
                    :set_markup(fontfg(font.name, font.color, stdout))
            else
                Weather.widget
                    :get_children_by_id("wtextbox")[1]
                    :set_markup(fontfg(font.name, font.color, "WEATHER OFFLINE"))
            end
        end)
    end

    Weather.widget:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then
            checkWeather()
        end
    end)

    newtimer("awesome-widgets.weather", timeout, checkWeather)
    return Weather.widget
end

return Widget

--[>D]

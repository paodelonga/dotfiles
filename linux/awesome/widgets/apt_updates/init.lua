
--[[ Docstring

    A simple spotify bar controller

    (c) Copyright 2023, Abiel Mendes (<https://github.com/paodelonga>)
    https://github.com/paodelonga/awesome-widgets/tree/main/widgets/apt_updates

--]]

-- widgets.apt_updates

local async = require("lain.helpers").async
local newtimer = require("lain.helpers").newtimer
local wibox = require("wibox")
local fontfg = require("lain").util.markup.fontfg

local function Widget(arguments)
    local APTUpdates = {
        widget = wibox.widget({
            layout = wibox.layout.align.horizontal,
            {
                id = "wtextbox",
                widget = wibox.widget.textbox,
            },
        }),
    }

    local args = arguments or {}
    local timeout = args.timeout or 3600
    local font = args.font or { name = "Noto Mono 9", color = "#FFFFFF" }

    local function Update()
        async("bash -c 'apt list --upgradable --quiet | wc -l'", function(stdout)
            local update_count = tonumber(stdout) - 1
            if update_count > 0 then
                APTUpdates.widget:get_children_by_id("wtextbox")[1]:set_markup(
                    fontfg(
                        font.name,
                        font.color,
                        "UP " .. update_count .. ""
                    )
                )
            else
                APTUpdates.widget:get_children_by_id("wtextbox")[1]:set_markup(fontfg(font.name, font.color, ""))
            end
        end)
    end

    APTUpdates.widget:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then -- Left Click
            Update()
        end
    end)

    newtimer("widgets.apt_updates", timeout, Update)
    return APTUpdates.widget
end

return Widget

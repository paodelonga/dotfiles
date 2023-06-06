--[[ Docstring

    A simple spotify bar controller

    (c) Copyright 2023, Abiel Mendes (<https://github.com/paodelonga>)
    https://github.com/paodelonga/awesome-widgets/tree/main/widgets/spotify_bar

--]]

-- widgets.spotify_bar

local async = require("lain.helpers").async
local newtimer = require("lain.helpers").newtimer
local wibox = require("wibox")
local fontfg = require("lain").util.markup.fontfg
local awful = require("awful")

local function Widget(arguments)
    local SpotifyBar = {
        widget = wibox.widget({
            layout = wibox.layout.align.horizontal,
            {
                id = "wtextbox",
                widget = wibox.widget.textbox,
            },
        }),
    }

    local args = arguments or {}
    local timeout = args.timeout or 2
    local font = args.font or { name = "Noto Mono 9", color = "#FFFFFF" }
    local separator = args.separator or " - "
    local sp_bin = args.sp_bin or "sp"

    local GET_SPOTIFY = sp_bin .. " status & " .. sp_bin .. " current"

    local function WidgetUpdate(artist, sep, title, status)
        if string.find(status, "PLAYING") then
            if artist ~= nil and title ~= nil then
                SpotifyBar.widget
                    :get_children_by_id("wtextbox")[1]
                    :set_markup(fontfg(font.name, font.color, artist .. sep .. title))
            else
                SpotifyBar.widget:get_children_by_id("wtextbox")[1]:set_markup(fontfg(font.name, font.color, title))
            end
        else
            SpotifyBar.widget:get_children_by_id("wtextbox")[1]:set_markup(fontfg(font.name, font.color, status))
        end
    end

    local function Update()
        async(GET_SPOTIFY, function(stdout)
            if stdout ~= nil then
                local sp_stdout = stdout .. "\n"
                local status = string.match(sp_stdout, "%s*(.-)\n")
                local album, albumArtist, artist, title = string.match(
                    sp_stdout,
                    "Album%s*(.-)\n" ..
                    "AlbumArtist%s*(.-)\n" ..
                    "Artist%s*(.-)\n" ..
                    "Title%s*(.-)\n"
                )

                if string.find(status, "Spotify is not running") ~= nil then
                    WidgetUpdate(artist, separator, title, "SPOTIFY IS NOT RUNNING")
                elseif string.find(status, "Paused") ~= nil then
                    WidgetUpdate(artist, separator, title, "PAUSED")
                elseif string.find(status, "Stopped") ~= nil then
                    WidgetUpdate(artist, separator, title, "DISCONNECTED")
                elseif string.find(status, "Playing") ~= nil then
                    WidgetUpdate(artist, separator, title, "PLAYING")
                elseif string.find(status, "Error") ~= nil then
                    WidgetUpdate(artist, separator, title, string.format("ERROR: %s", status))
                end
            end
        end)
    end

    SpotifyBar.widget:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then -- Left Click
            awful.spawn.with_shell(sp_bin .. " play")
        elseif button == 3 then -- Right Click
            async(GET_SPOTIFY, function(stdout)
                if string.find(stdout, "Spotify is not running") then
                    awful.spawn.with_shell("spotify ")
                else
                    awful.spawn.with_shell("killall -s 9 spotify")
                end
            end)
        elseif button == 4 then -- Scroll Up
            awful.spawn.with_shell(sp_bin .. " prev")
            Update()
        elseif button == 5 then -- Scroll Down
            awful.spawn.with_shell(sp_bin .. " next")
            Update()
        elseif button == 8 then -- Side Up Button
            awful.spawn.with_shell(sp_bin .. " next")
            Update()
        elseif button == 9 then -- Side Down Button
            awful.spawn.with_shell(sp_bin .. " prev")
            Update()
        end
    end)

    newtimer("widgets.spotify_bar", timeout, Update)
    return SpotifyBar.widget
end

return Widget

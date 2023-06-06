--[[ Docstring

    My widgets created for Awesome WM

    (c) Copyright 2023, Abiel Mendes (<https://github.com/paodelonga>)
    https://github.com/paodelonga/awesome-widgets

--]]

-- To activate a Widget move the line out of the comment block.
return {
    --[[
    --]]
    logout_menu = require("widgets.logout_menu"),
    spotify_bar = require("widgets.spotify_bar"),
    todo_widget = require("widgets.todo_widget.todo"),
    apt_updates = require("widgets.apt_updates"),
    wallpaper_changer = require("widgets.wallpaper_changer"),
    weather = require("widgets.weather"),
    battery = require("widgets.battery.battery"),
    calendar = require("widgets.calendar.calendar"),
}

--[>D]

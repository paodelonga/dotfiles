--[[ Docstring

    library to work with enviroment variables

    (c) Copyright 2023, Abiel Mendes (<https://github.com/paodelonga>)

--]]

local awful = require("awful")

local env = { _NAME = "env" }

function env.export(name, value)
    awful.spawn.with_shell(
        string.format(
            "set --universal --export %s %s",
            name,
            value
        )
    )
end

function env.import()
    return false
end

return env

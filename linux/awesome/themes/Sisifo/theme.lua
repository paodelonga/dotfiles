local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local markup = require("lain").util.markup
local widgets = require("widgets")
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility
local config_dir = require("gears").filesystem.get_configuration_dir()

-- Initializing variables
local theme = {}
local separator = {}
theme.widgets = {}

-- Theme definitions
theme.name = "Sisifo"
theme.dir = config_dir .. "themes/" .. theme.name
theme.icon_theme = "Papirus-Dark"

-- Fonts
theme.font = "Hack Nerd Font Regular 9"
theme.font_color = "#CAD1FF"

-- Wibar
theme.wibar_bg = "#303446" -- 1D1F21A0 222931
theme.wibar_border_color = "#00000000"
theme.wibar_border_width = dpi(0)

-- Taglist
theme.taglist_fg_focus = "#FAFAFA"
theme.taglist_fg_occupied = "#F5CDD5"
theme.taglist_fg_empty = "#88E6FF"
theme.taglist_fg_urgent = "#A8D88D"
theme.taglist_font = "Hack Nerd Font Regular 8"

-- Tasklist
theme.tasklist_bg_normal = "#00000000"
theme.tasklist_bg_focus = "#00000000"
theme.tasklist_disable_icon = false
theme.tasklist_disable_task_name = true

-- Client
theme.border_normal = "#00000000"
theme.border_focus = "#36366BAF"
theme.border_width = dpi(2)
theme.useless_gap = dpi(4)

-- Notification
theme.notification_bg = "#222931"
theme.notification_border_color = "#36366BAF"
theme.notification_icon_size = dpi(60)
theme.notification_shape = function(cr, width, height)
	gears.shape.rounded_rect(cr, width, height, dpi(2))
end

-- Hotkeys popup
theme.hotkeys_bg = "#222931"
theme.hotkeys_border_color = "#36366BAF"
theme.hotkeys_shape = function(cr, width, height)
	gears.shape.rounded_rect(cr, width, height, dpi(2))
end

-- Layout icons
theme.layout_max = theme.dir .. "/icons/layout/max.png"
theme.layout_tile = theme.dir .. "/icons/layout/tile.png"
theme.layout_tiletop = theme.dir .. "/icons/layout/tiletop.png"
theme.layout_floating = theme.dir .. "/icons/layout/floating.png"
theme.layout_termfair = theme.dir .. "/icons/layout/termfair.png"
theme.layout_tilebottom = theme.dir .. "/icons/layout/tilebottom.png"
theme.layout_magnifier = theme.dir .. "/icons/layout/magnifier.png"
theme.layout_centerwork = theme.dir .. "/icons/layout/centerwork.png"

-- Separators
separator.blank = wibox.widget.textbox(markup(theme.font_color, " "))
separator.line = wibox.widget.textbox(markup(theme.font_color, " | "))

-- Widgets definitions
os.setlocale("pt_BR.UTF-8") -- to localize the textclock clock

-- Widgets
-- theme.widgets.battery = widgets.battery({
	-- font = theme.font,
	-- show_current_level = true,
	-- notification_position = "top_right",
	-- show_notification_mode = "on_click",
	-- warning_msg_position = "top_right",
	-- enable_battery_warning = true,
	-- warning_msg_text = "vish, Pao... we have a problem!",
	-- warning_msg_title = "Battery is dying!",
	-- main_color = theme.font_color,
	-- timeout = 60,
-- })
theme.widgets.apt_updates = widgets.apt_updates({
	timeout = 3600,
	font = {
		name = theme.font,
		color = theme.font_color,
	},
})
theme.widgets.todo_widget = widgets.todo_widget
theme.widgets.weather = widgets.weather({
	timeout = 1800,
	font = {
		name = theme.font,
		color = theme.font_color,
	},
})
theme.widgets.spotify_bar = widgets.spotify_bar({
	timeout = 2,
	font = {
		name = theme.font,
		color = theme.font_color,
	},
})
theme.widgets.logout_menu = widgets.logout_menu({
	onlock = function()
		awful.spawn.with_shell("i3lock-fancy -g")
	end,
})
theme.widgets.cputemp = lain.widget.temp({
	timeout = 5,
	tempfile = "/sys/class/thermal/thermal_zone2/temp",
	settings = function()
		widget:set_markup(markup(theme.font_color, markup.font(theme.font, "CPU " .. coretemp_now .. "°C")))
	end,
})

theme.widgets.netinfo = lain.widget.net({
	wifi_state = 0,
	timeout = 1,
	units = 1024,
	settings = function()
		widget:set_markup(
			markup.fontfg(theme.font, theme.font_color, "UP " .. net_now.sent .. " DOWN " .. net_now.received)
		)
	end,
})

theme.widgets.volume = lain.widget.alsa({
	timeout = 10,
	settings = function()
		widget:buttons(awful.util.table.join(
			awful.button({}, 4, function()
				os.execute(string.format("amixer -q set %s 1%%+", theme.widgets.volume.channel))
				theme.widgets.volume.update()
			end),

			awful.button({}, 5, function()
				os.execute(string.format("amixer -q set %s 1%%-", theme.widgets.volume.channel))
				theme.widgets.volume.update()
			end),

			awful.button({}, 1, function()
				if
					tonumber(volume_now.level) == 0
					or tonumber(volume_now.level) > 50 and tonumber(volume_now.level) < 100
				then
					os.execute(string.format("amixer -q set %s 100", theme.widgets.volume.channel))
					theme.widgets.volume.update()
				elseif
					tonumber(volume_now.level) == 100
					or tonumber(volume_now.level) < 50 and tonumber(volume_now.level) > 0
				then
					os.execute(string.format("amixer -q set %s 0", theme.widgets.volume.channel))
					theme.widgets.volume.update()
				end
			end)
		))
		widget:set_markup(markup(theme.font_color, markup.font(theme.font, "VOL " .. volume_now.level .. "%")))
	end,
})
theme.widgets.cpu = lain.widget.cpu({
	timeout = 2,
	settings = function()
		widget:set_markup(markup(theme.font_color, markup.font(theme.font, "CPU " .. cpu_now.usage .. "%")))
	end,
})
theme.widgets.mem = lain.widget.mem({
	settings = function()
		widget:set_markup(markup(theme.font_color, markup.font(theme.font, "MEM " .. mem_now.used)))
	end,
})
theme.widgets.calendar = widgets.calendar({
	theme = 'nord',
	placement = 'top_center',
	start_sunday = false,
	radius = 4,
})
theme.widgets.clock = wibox.widget({
	format = markup(theme.font_color, "%I:%M %p"),
	widget = wibox.widget.textclock,
	font = theme.font,
})
theme.widgets.clock:connect_signal("button::press", function(_, _, _, button)
		if button == 1 then
			theme.widgets.calendar.toggle()
		end
end)
theme.widgets.clock:connect_signal("mouse::enter", function()
	theme.widgets.clock.format = markup(theme.font_color, "%a %d %b")
end)
theme.widgets.clock:connect_signal("mouse::leave", function()
	theme.widgets.clock.format = markup(theme.font_color, "%I:%M %p")
end)

function theme.at_screen_connect(s)
	-- For all tags opening with primary layout
	awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

	-- Create layoutbox widget
	s.layoutbox = awful.widget.layoutbox(s)
	s.layoutbox:buttons(my_table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))

	-- Create a taglist widget
	s.taglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = awful.util.taglist_buttons,
	})

	-- Create a tasklist widget
	s.tasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = awful.util.tasklist_buttons,
	})

	-- Create the wibar
	s.wibar = awful.wibox({
		screen = s,
		position = "top",
		height = dpi(22),
		width = dpi(s.geometry.width - 24),
		stretch = false,
		align = "centered",
		visible = true,
		ontop = true,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, dpi(4))
		end,
	})

	awful.placement.top(s.wibar, {
		margins = {
			top = dpi(6),
			bottom = dpi(0),
		},
	})

	-- Adding widgets to the wibox
	s.wibar:setup({
		expand = "none",
		layout = wibox.layout.align.horizontal,
		{
			layout = wibox.layout.fixed.horizontal,
			s.taglist,
			separator.blank,
			theme.widgets.spotify_bar,
		},
		{
			layout = wibox.layout.fixed.horizontal,
			theme.widgets.clock,
		},
		{
			layout = wibox.layout.fixed.horizontal,
			s.tasklist,
			separator.blank,
			theme.widgets.netinfo,
			separator.blank,
			theme.widgets.todo_widget(),
			theme.widgets.weather,
			separator.blank,
			separator.blank,
			separator.blank,
			theme.widgets.volume.widget,
			separator.blank,
			separator.blank,
			separator.blank,
			theme.widgets.cputemp,
			separator.blank,
			separator.blank,
			separator.blank,
			theme.widgets.cpu.widget,
			separator.blank,
			separator.blank,
			separator.blank,
			theme.widgets.mem.widget,
			separator.blank,
			separator.blank,
			-- theme.widgets.battery,
			-- separator.blank,
			theme.widgets.apt_updates,
			separator.blank,
			theme.widgets.logout_menu,
			separator.blank,
			-- s.layoutbox,
			-- separator.blank,
			separator.blank,
		},
	})
end

return theme

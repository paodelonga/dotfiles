-- [[ Libraries
local gears = require("gears") --Utilities such as color parsing and objects
local awful = require("awful") --Everything related to window managment
local config_dir = require("gears").filesystem.get_configuration_dir()
local dpi = require("beautiful").xresources.apply_dpi

local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility
local hotkeys_popup = require("awful.hotkeys_popup").widget
local beautiful = require("beautiful") --Everything related to theming
local naughty = require("naughty") --Notifcation manager
local lain = require("lain")
local widgets = require("widgets")

local awesome, client, root, screen = awesome, client, root, screen

require("awful.hotkeys_popup.keys")
require("awful.autofocus")
local env = require("libs.env")

--]]

-- [[ Error Handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Deu merda peixotoooooooooooooo!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = string.format("FUDEU! %s, deu merda no teu WM", os.getenv("USERNAME")),
			text = tostring(err),
		})
		in_error = false
	end)
end
-- ]]

-- [[ Autostart Windowless Processes
local function run_once(cmd_arr)
	for _, cmd in ipairs(cmd_arr) do
		awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
	end
end
run_once({ "unclutter -root" }) -- entries must be comma-separated
-- ]]

-- [[ Variables
-- Paths
local wallpapers_path = os.getenv("HOME") .. "/Pictures/Wallpapers/"

-- Custom scripts
local scripts = {}
scripts.dir = config_dir .. "scripts/"
scripts.picom = scripts.dir .. "picom-starter"
scripts.setxinit = os.getenv("HOME") .. "/.xinitrc"
scripts.kdeconnect = scripts.dir .. "kdeconnect-starter"
scripts.arduino_update = scripts.dir .. "arduino-update-checker"
scripts.udiskie = scripts.dir .. "udiskie-starter"
scripts.acon = scripts.dir .. "adb-autoconnect"

-- Themes
local theme = {}
theme.current = {}
theme.path = config_dir .. "themes"

-- Modkeys
local cmdmod = "Mod4" -- Win/Command
local altmod = "Mod1" -- Left Alt
local ctrlmod = "Control" -- Left Ctrl
local shiftmod = "Shift" -- Left Shift
local escmod = "Escape" -- Escape

-- Keybindings
local rootButtons
local rootKeys
local clientButtons
local clientKeys

-- Execute startup script at start
local startup = {
	apps = false,
	scripts = true,
	wallpaper_changer = false,
	apps_list = {},
	scripts_list = {},
}

--- App rules
local terminal = {
	tag = 2,
	cmd = "alacritty ",
	class = "Alacritty",
}

local browsers = {
	gui = {
		tag = 1,
		firefox = {
			cmd = "firefox ",
			class = "firefox",
		},
		firefox_nightly = {
			cmd = "firefox-nightly ",
			class = "firefox-nightly",
		},
		firefox_dev = {
			cmd = "firefox-dev ",
			class = "firefox-dev",
		},
		chrome = {
			cmd = "google-chrome ",
			class = "Google-chrome",
		},
		edge = {
			class = "microsoft-edge",
			cmd = "flatpak run com.microsoft.Edge ",
		},
		default = "firefox-nightly ",
	},
}

local editors = {
	gui = {
		tag = 3,
		sublime = {
			cmd = "sublime-text.subl ",
			class = "Sublime_text",
		},
		marker = {
			cmd = "flatpak run com.github.fabiocolacio.marker ",
			class = "Marker",
		},
		vscodium = {
			class = "VSCodium",
			cmd = "codium",
		},
		default = "sublime-text.subl ",
	},
	terminal = {
		tag = 2,
		micro = {
			cmd = "alacritty --class 'Terminal Editor' -e micro ",
			class = "Terminal Editor",
		},
		default = "alacritty --class 'Terminal Editor' -e micro ",
	}
}

local filemanagers = {
	gui = {
		tag = 4,
		nautilus = {
			cmd = "nautilus ",
			class = "Org.gnome.Nautilus",
		},
		default = "nautilus ",
	},
	terminal = {
		tag = 2,
		ranger = {
			cmd = "alacritty --class 'Terminal Filemanager' -e ranger ",
			class = "TeEminal Filemanager",
		},
		default = "alacritty --class 'Terminal Filemanager' -e ranger ",
	},
}

local musicplayers = {
	gui = {
		tag = 5,
		spotify = {
			cmd = "spotify ",
			class = "Spotify",
		},
		rhythmbox = {
			cmd = "rhythmbox",
			class = "Rhythmbox ",
		},
		default = "spotify "
	},
}

local screenrecorder = {
	tag = 5,
	obs_studio = {
		cmd = "flatpak run com.obsproject.Studio ",
		class = "obs ",
	},
	streamlabs = {
		cmd = "",
		class = ""
	}
}

local discord = {
	tag = 5,
	cmd = "discord ",
	class = "discord",
}

local propertydisplayer = {
	cmd = "alacritty --hold --class 'Property Displayer' -e xprop",
	class = "Property Displayer",
}

local screenlocker = {
	cmd = "i3lock-flancy -g",
}

local resourcesmonitor = {
	cmd = "alacritty --hold --class 'Resources monitor' -e btop",
	class = "Resources monitor",
}

startup.apps_list = {
	terminal.cmd,
	browsers.gui.default,
	musicplayers.gui.spotify.cmd,
	discord.cmd,
}
startup.scripts_list = {
	scripts.setxinit,
	scripts.kdeconnect,
	scripts.picom,
	scripts.arduino_update,
	scripts.udiskie,
	-- scripts.acon,
}

-- [[ Layout
-- awful.util.tagnames = { "  ", "  ", "  ", "  ", "  " }
awful.util.tagnames = { " ◉", "◉", "◉", "◉", "◉" }
-- awful.util.tagnames = { "F1", "F2", "F3", "F4", "F5" }
-- awful.util.tagnames = { "🅆🅆🅆 ", "🅂🄷🄴🄻🄻 ", "🄿🅁🄾🄹🄴🄲🅃 ", "🄵🄸🄻🄴 ", "🄼🄴🄳🄸🄰" }
-- awful.util.tagnames = { "🆆🆆🆆", "🆂🅷🅴🅻🅻", "🅿🆁🅾🅹🅴🅲🆃", "🅵🅸🅻🅴", "🅼🅴🅳🅸🅰" }
-- awful.util.tagnames = { "🅦🅦🅦,", "🅢🅗🅔🅛🅛,", "🅟🅡🅞🅙🅔🅒🅣,", "🅕🅘🅛🅔,", "🅜🅔🅓🅘🅐" }
-- awful.util.tagnames = { "www", "shell", "project", "file", "media"}

awful.layout.suit.tile.left.mirror = true
awful.layout.layouts = {
	awful.layout.suit.max,
	lain.layout.termfair,
	awful.layout.suit.tile,
	lain.layout.centerwork,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.floating,
	awful.layout.suit.magnifier,
}

-- Taglist Keybindings
awful.util.taglist_buttons = my_table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),

	awful.button({ cmdmod }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
			t:view_only()
		end
	end),

	awful.button({}, 3, awful.tag.viewtoggle),

	awful.button({ cmdmod }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),

	awful.button({}, 5, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

-- Tasklist butons
awful.util.tasklist_buttons = gears.table.join(awful.button({}, 1, function(c)
	if c == client.focus then
		c.minimized = true
	else
		c:emit_signal("request::activate", "tasklist", { raise = true })
	end
end))
-- ]]

-- [[ Themes
theme.list = {
	"Aqua", -- 1
	"BlackYellow", -- 2
	"Blue", -- 3
	"Brown", -- 4
	"dark", -- 5
	"Darkblue", -- 6
	"Desert", -- 7
	"Gruvbox", -- 8
	"Miami", -- 9
	"Nord", -- 10
	"Sisifo", -- 11
	"Tokyo", -- 12
	"TokyoNight", -- 13
	"Void", -- 14
}

theme.current.name = theme.list[11]
theme.current.path = string.format("%s/%s", theme.path, theme.current.name)
theme.current.config = string.format("%s/theme.lua", theme.current.path)
beautiful.init(theme.current.config)
-- ]]

-- [[ Screen
-- -- Margen nas telas porque a minha tela tem problema
awful.screen.focused().padding = {
	bottom = dpi(16),
	top = dpi(12),
	left = dpi(12),
	right = dpi(12),
}

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
	beautiful.at_screen_connect(s)
end)
-- ]]

-- [[ Keybindings
-- Root Keys
rootButtons = (
	my_table.join(awful.button({ cmdmod }, 5, awful.tag.viewnext), awful.button({ cmdmod }, 4, awful.tag.viewprev))
)

-- Root Keys
rootKeys = my_table.join(
	-- Apps
	awful.key({ cmdmod }, "w", function()
		awful.util.spawn(browsers.gui.default)
	end, { description = "Web browser", group = "APPS" }),

	awful.key({ cmdmod, shiftmod }, ":", function()
		awful.util.spawn("emote")
	end, { description = "Emoji selector", group = "APPS" }),

	awful.key({ cmdmod }, "e", function()
		awful.util.spawn(filemanagers.gui.default)
	end, { description = "File manager", group = "APPS" }),

	awful.key({}, "XF86Explorer", function()
		awful.util.spawn(filemanagers.gui.default)
	end, { description = "File manager", group = "APPS" }),

	awful.key({ cmdmod, shiftmod }, "e", function()
		awful.util.spawn(filemanagers.terminal.cmd)
	end, { description = "Terminal file manager", group = "APPS" }),

	awful.key({ }, "XF86Calculator", function()
		awful.util.spawn("gnome-calculator")
	end, { description = "Calculator", group = "APPS" }),

	awful.key({ shiftmod }, "XF86AudioPlay", function()
		awful.util.spawn(musicplayers.gui.spotify.cmd)
	end, { description = "Spotify", group = "APPS" }),

	awful.key({ cmdmod }, "s", function()
		awful.spawn(terminal.cmd)
	end, { description = "Terminal", group = "APPS" }),

	awful.key({ cmdmod }, "t", function()
		awful.spawn(editors.gui.default)
	end, { description = "Editor", group = "APPS" }),

	awful.key({ cmdmod, shiftmod }, "t", function()
		awful.spawn(editors.terminal.default)
	end, { description = "Terminal Editor", group = "APPS" }),

	awful.key({ cmdmod }, "h", function()
		awful.spawn(resourcesmonitor.cmd)
	end, { description = "Resources monitor", group = "APPS" }),

	-- Client
	awful.key({ cmdmod }, "Left", function()
		awful.client.focus.global_bydirection("left")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "Focus on left client", group = "CLIENT" }),

	awful.key({ cmdmod }, "Right", function()
		awful.client.focus.global_bydirection("right")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "Focus on right client", group = "CLIENT" }),

	awful.key({ cmdmod }, "Up", function()
		awful.client.focus.global_bydirection("up")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "Focus client above", group = "CLIENT" }),

	awful.key({ cmdmod }, "Down", function()
		awful.client.focus.global_bydirection("down")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "Focus clinet below", group = "CLIENT" }),

	awful.key({ altmod, shiftmod }, "Tab", function()
		awful.client.focus.byidx(-1)
		if client.focus then
			client.focus:raise()
		end
	end, { description = "Focus on next client", group = "CLIENT" }),

	awful.key({ altmod }, "Tab", function()
		awful.client.focus.byidx(1)
		if client.focus then
			client.focus:raise()
		end
	end, { description = "Focus on previous clinet", group = "CLIENT" }),

	awful.key({ cmdmod, shiftmod }, "Right", function()
		awful.tag.incmwfact(0.10)
	end, { description = "Increase master width factor", group = "CLIENT" }),

	awful.key({ cmdmod, shiftmod }, "Left", function()
		awful.tag.incmwfact(-0.10)
	end, { description = "Decrease master width factor", group = "CLIENT" }),

	awful.key({ cmdmod, ctrlmod }, "Left", function()
		awful.client.swap.bydirection("left", c)
	end, { description = "Swap client to left", group = "CLIENT" }),

	awful.key({ cmdmod, ctrlmod }, "Right", function()
		awful.client.swap.bydirection("right", c)
	end, { description = "Swap client to right", group = "CLIENT" }),

	awful.key({ cmdmod, ctrlmod }, "Up", function()
		awful.client.swap.bydirection("up", c)
	end, { description = "Swap client to up", group = "CLIENT" }),

	awful.key({ cmdmod, ctrlmod }, "Down", function()
		awful.client.swap.bydirection("down", c)
	end, { description = "Swap client to down", group = "CLIENT" }),

	-- Desktop
	awful.key({ cmdmod }, "F12", awesome.restart, { description = "Reload Awesome", group = "DESKTOP" }),

	awful.key({ cmdmod }, "F11", _G.awesome.quit, { description = "Quit Awesome", group = "DESKTOP" }),

	awful.key({ cmdmod }, "x", function()
		awful.spawn(propertydisplayer.cmd)
	end, { description = "Display property", group = "APPS" }),

	awful.key({ cmdmod }, "b", function()
		for s in screen do
			s.wibar.visible = not s.wibar.visible
		end
	end, { description = "Toggle wibox", group = "DESKTOP" }),

	awful.key({ cmdmod }, "F10", hotkeys_popup.show_help, { description = "Keybindings Help", group = "DESKTOP" }),

	awful.key({ cmdmod }, "F9", function()
		awful.spawn(string.format("%s%src.lua", editors.terminal.default, config_dir))
	end, { description = "Edit config", group = "DESKTOP" }),

	awful.key({ cmdmod, shiftmod }, "F9", function()
		awful.spawn(editors.terminal.default .. theme.current.config)
	end, { description = "Edit theme", group = "DESKTOP" }),

	awful.key({ cmdmod }, "End", function()
		awful.spawn(screenlocker.cmd)
	end, { description = "Lock The Screen", group = "DESKTOP" }),

	awful.key({ cmdmod }, "Home", function()
		awful.spawn(scripts.setxinit)
		awful.spawn(scripts.arduino_update)
		awful.spawn(scripts.picom)
		awful.spawn(
			"notify-send 'WashOS' 'Scripts Restarted!' --expire-time 5000 --app-name 'WashOS' --icon "
				.. theme.current.path
				.. "/icons/awesome/awesome64.png"
		)
	end, { description = "Setup Scripts", group = "DESKTOP" }),

	awful.key({}, "XF86AudioRaiseVolume", function()
		os.execute(string.format("amixer -q set %s 1%%+", beautiful.widgets.volume.channel))
		beautiful.widgets.volume.update()
	end, { description = "Volume up", group = "DESKTOP" }),

	awful.key({}, "XF86AudioLowerVolume", function()
		os.execute(string.format("amixer -q set %s 1%%-", beautiful.widgets.volume.channel))
		beautiful.widgets.volume.update()
	end, { description = "Volume down", group = "DESKTOP" }),

	-- Rofi
	awful.key({ cmdmod }, "r", function()
		awful.spawn("rofi -show run")
	end, { description = "Rofi Runner", group = "ROFI" }),

	awful.key({ cmdmod }, "v", function()
		awful.spawn("rofi -show window")
	end, { description = "Rofi Window", group = "ROFI" }),

	awful.key({ cmdmod }, "a", function()
		awful.spawn("rofi -show drun")
	end, { description = "Rofi Launcher", group = "ROFI" }),

	-- Tools
	awful.key({}, "Print", function()
		awful.spawn.with_shell(
			"scrot 'Screenshot_from_%Y-%m-%d_%H-%M-%S.png' " ..
			"--pointer --freeze --quality 100 --border --select " ..
			"--exec 'xclip -selection clipboard -t image/png -i ~/Pictures/Screenshots/$f | " ..
			"mv $f ~/Pictures/Screenshots/'"
		)
	end, { description = "Grab an area screenshot", group = "TOOL" }),

	awful.key({ shiftmod }, "Print", function()
		awful.spawn.with_shell(
			"scrot 'Screenshot_from_%Y-%m-%d_%H-%M-%S.png' " ..
			"--pointer --freeze --quality 100 --border --focused " ..
			"--exec 'xclip -selection clipboard -t image/png -i ~/Pictures/Screenshots/$f | " ..
			"mv $f ~/Pictures/Screenshots/'"
		)
	end, { description = "Grab a entire screen", group = "TOOL" }),

	awful.key({ cmdmod }, "Print", function()
		awful.spawn.with_shell("flameshot gui")
	end, { description = "Screenshot in interactive mode ", group = "TOOL" })
)

-- Binding all keys numbers to tags
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 5 do
	-- Hack to only show tags 1 and 9 in the shortcut window (cmdmod + F10)
	local descr_view, descr_toggle, descr_move, descr_toggle_focus
	if i == 1 or i == 5 then
		descr_view = { description = "view tag #", group = "TAG" }
		descr_toggle = { description = "toggle tag #", group = "TAG" }
		descr_move = { description = "move focused client to tag #", group = "TAG" }
		descr_toggle_focus = { description = "toggle focused client on tag #", group = "TAG" }
	end
	rootKeys = my_table.join(
		rootKeys,
		-- View tag only.
		awful.key({ altmod }, "F" .. i, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, descr_view),

		-- Move client to tag.
		awful.key({ altmod, shiftmod }, "F" .. i, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
					local screen = awful.screen.focused()
					screen.tags[i]:view_only()
				end
			end
		end, descr_move),

		-- Toggle tag display.
		awful.key({ altmod, ctrlmod }, "F" .. i, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, descr_toggle),

		-- Toggle tag on focusbrowser_classed client.
		awful.key({ altmod, ctrlmod, shiftmod }, "F" .. i, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, descr_toggle_focus)
	)
end

-- Client Keys
clientKeys = my_table.join(
	-- Client

	-- Fulscreen, maximize, floating
	awful.key({ altmod, shiftmod }, "d", function(c)
		c.ontop = not c.ontop
		c:raise()
	end, { description = "Toggle Ontop", group = "CLIENT" }),

	awful.key({ altmod, shiftmod }, "c", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "Toggle Maximize", group = "CLIENT" }),

	awful.key(
		{ altmod, shiftmod },
		"f",
		awful.client.floating.toggle,
		{ description = "Toggle Floating", group = "CLIENT" }
	),

	awful.key({ altmod, shiftmod }, "v", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
		for s in screen do
			s.wibar.visible = not s.wibar.visible
		end
	end, { description = "Toggle Fullscreen", group = "CLIENT" }),

	-- layouts
	awful.key({ altmod, "Ctrl" }, "d", function()
		awful.layout.set(awful.layout.suit.tile)
	end, { description = "Change layout to tile", group = "CLIENT" }),

	awful.key({ altmod, "Ctrl" }, "c", function()
		awful.layout.set(lain.layout.termfair)
	end, { description = "Change layout to termfair", group = "CLIENT" }),

	awful.key({ altmod, "Ctrl" }, "f", function()
		awful.layout.set(awful.layout.suit.tile.bottom)
	end, { description = "Change layout to tile bottom", group = "CLIENT" }),

	awful.key({ altmod, "Ctrl" }, "v", function()
		awful.layout.set(awful.layout.suit.max)
	end, { description = "Change layout to max", group = "CLIENT" }),

	-- Closing
	awful.key({ cmdmod }, escmod, function(c)
		c:kill()
		local cc = awful.client.focus.history.list[2]
		client.focus = cc
		local t = client.focus and client.focus.first_tag or nil
		if t then
			t:view_only()
		end
		if cc then
			cc:raise()
		end
	end, { description = "Close", group = "CLIENT" }),

	awful.key({ cmdmod }, "q", function(c)
		c:kill()
		local cc = awful.client.focus.history.list[2]
		client.focus = cc
		local t = client.focus and client.focus.first_tag or nil
		if t then
			t:view_only()
		end
		if cc then
			cc:raise()
		end
	end, { description = "Close", group = "CLIENT" })
)

-- Client Buttons
clientButtons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),

	awful.button({ cmdmod }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),

	awful.button({ cmdmod }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end),

	awful.button({ cmdmod }, 5, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({ cmdmod }, 4, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

-- Enabling all Keybindings
root.keys(rootKeys)
root.buttons(rootButtons)
-- ]]

-- [[ Clients Rules
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientKeys,
			buttons = clientButtons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
			size_hints_honfor = false,
		},
	},

	-- Titlebars
	{
		rule_any = { type = { "normal" }, placement = awful.placement.centered },
		properties = { titlebars_enabled = false, floating = false, maximized = false },
	},
	{
		rule_any = {
			class = {
				browsers.gui.firefox.class,
				browsers.gui.firefox_dev.class,
				browsers.gui.firefox_nightly.class,
				browsers.gui.chrome.class,
				browsers.gui.edge.class,
			},
		},
		properties = {
			screen = 1,
			tag = awful.screen.focused().tags[1],
		},
	},
	{
		rule_any = {
			class = {
				filemanagers.gui.nautilus.class
			},
		},
		properties = {
			screen = 1,
			tag = awful.screen.focused().tags[4],
		},
	},
	{
		rule_any = {
			class = {
				musicplayers.gui.spotify.class,
				musicplayers.gui.rhythmbox.class,
				screenrecorder.tag,
				discord.tag,
			},
		},
		properties = {
			screen = 1,
			tag = awful.screen.focused().tags[5],
		},
	},
	{
		rule = {
			class = "Gnome-calculator"
		},
		properties = {
			screen = 1,
			floating = true,
			ontop = true
		},
	},
	{
		rule = {
			class = propertydisplayer.class
		},
		properties = {
			screen = 1,
			floating = true,
			width = 630,
			height = 390,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			class = {
				"Update-manager",
				"Arandr",
				"Emote",
				"Gnome-calculator",
				"Gnome-font-viewer",
				"Gnome-screenshot",
				"Imagewriter",
				"Font-manager",
				"Marker",
				"Shotwell",
				"Eog",
				"Gcr-prompter",
				"File-roller",
				"Nm-connection-editor",
				"scrcpy",
				"Tor Browser",
				"feh",
				"mpv",
				"vlc",
				"Lxappearance",
				"Pavucontrol",
			},
			name = {
				"Picture in picture",
				"Event Tester",
				"Indexing Status - Sublime Text Status",
				"Library",
				"gimp-operation-tool",
				"gimp-file-save",
				"ColorPicker | AdvanceMode",
				"ColorPicker | Color Shade",
			},
			role = {
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
				"GtkFileChooserDialog",
			},
			type = {
				"dialog",
				"menu",
				"toolbar",
				"popup_menu",
				"notification",
			},
		},
		properties = { floating = true, placement = awful.placement.centered },
	},
}
-- ]]

-- [[ Client Sigals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	c.shape = function(cr, w, h)
		gears.shape.rounded_rect(cr, w, h, dpi(4))
	end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		awful.placement.no_offscreen(c)
	end
end)

-- Remove border for maximized clients
local function border_adjust(c)
	if c.maximized then -- no borders if only 1 client visible
		c.border_width = 0
	elseif #awful.screen.focused().clients > 1 then
		c.border_width = beautiful.border_width
		c.border_color = beautiful.border_focus
	end
end

-- Connect client signals
client.connect_signal("focus", border_adjust)
client.connect_signal("property::maximized", border_adjust)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)
-- ]]

-- [[ Widgets and Scripts
-- Wallpaper changer on click or by time
if startup.wallpaper_changer then
	widgets.wallpaper_changer.start({
		path = theme.current.path .. "/wallpapers/",
		show_notify = true,
		timeout = 1800,
		change_on_click = true,
	})
else
	awful.spawn("nitrogen --restore")
end

-- Start scripts
if startup.scripts then
	for script = 1, #startup.scripts_list do
		awful.spawn.with_shell(startup.scripts_list[script])
	end
end

-- Autostart Apps
if startup.apps then
	for app = 1, #startup.apps_list do
		awful.spawn.with_shell(startup.apps_list[app])
	end
end

--- Window Manager Enviroment Variables
local enviroments_variable = {
	WM_PATH = config_dir,
	WM_CONFIG = config_dir .. "rc.lua",
	WM_THEME = theme.current.name,
	WM_THEME_PATH = theme.current.path,
	WM_THEME_CONFIG = theme.current.config,
	EDITOR = editors.terminal.default,
	EDITOR_GUI = editors.gui.default,
	BROWSER = browsers.gui.default,
	TERMINAL = terminal.cmd,
}

for env_name, env_value in pairs(enviroments_variable) do
	env.export(env_name, env_value)
end

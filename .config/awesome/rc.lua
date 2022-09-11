-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
-- Set additional library search directory with `--search` arg:
--    awesome --search "$HOME/.config/awesome/lua_modules/share/lua/5.3"
-- Install packages with:
--    luarocks install --lua-version 5.3 --tree "$HOME/.config/awesome/lua_modules" <rockname>
pcall(require, "luarocks.loader")

-------------------------------------
-- Quick summary of awesome std lib
-------------------------------------
-- gears = Utils
-- awful = Window Management
-- wibox = Widget and Layouts
-- beautiful = Themes
-- naughty = Notifications (dunst alternative)
-- menubar = XDG menubar (kinda like dmenu)

local gears = require("gears")
local beautiful = require("beautiful")
local awful = require("awful")
require("awful.autofocus")
-- Enable hotkeys help widget for VIM and other apps when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-------------------------------------
-- Errors
-------------------------------------
-- Warn if error during startup/restart
if awesome.startup_errors then
  os.execute("notify-send 'Awesome startup err:\n" .. awesome.startup_errors .. "' -u critical")
end
-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal(
    "debug::error", function(err)
      if in_error then return end  -- Prevent endless error loop
      in_error = true
      os.execute("notify-send 'Awesome err:\n" .. tostring(err) .. "' -u critical")
      in_error = false
    end
  )
end

-------------------------------------
-- Initalization
-------------------------------------
-- Init theme and available layouts before doing anything else
-- Anything that comes after can assume these exists
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/custom/theme.lua")
-- Available layouts (used by awful.layout.inc), order maters
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.floating,
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}

-------------------------------------
-- Wallpaper
-------------------------------------
local function set_wallpaper(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then wallpaper = wallpaper(s) end
    gears.wallpaper.maximized(wallpaper, s, false)
  end
end
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
-- Initalize wallpapers
awful.screen.connect_for_each_screen(set_wallpaper)

-------------------------------------
-- Root key and mousebinds
-------------------------------------
local keybinds = require("config.keybinds")
root.keys(keybinds.globalkeys)
root.buttons(gears.table.join(
  awful.button({}, 3, function() dropdown_menu:toggle() end),
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)
))

-------------------------------------
-- Configure clients
-------------------------------------
local clients = require("config.clients")
awful.rules.rules = clients.rules  -- Rules to apply to new clients
client.connect_signal("manage", clients.new_client)  -- When a new client appears
-- Adds titlebar if titlebars_enabled in rules
client.connect_signal("request::titlebars", clients.titlebar)

-- Focus follows mouse
client.connect_signal(
  "mouse::enter",
  function(c) c:emit_signal("request::activate", "mouse_enter", { raise = false }) end
)
client.connect_signal(
  "focus",
  function(c) c.border_color = beautiful.border_focus end
)
client.connect_signal(
  "unfocus",
  function(c) c.border_color = beautiful.border_normal end
)

-------------------------------------
-- Panels
-------------------------------------
local top_bar = require("components.top_bar")
awful.screen.connect_for_each_screen(top_bar)

-------------------------------------

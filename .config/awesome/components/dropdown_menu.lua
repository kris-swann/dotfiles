local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful") -- Make sure beautiful.init() has already been run

local consts = require("config.consts")

local system_submenu = {
  { "quit", function() awesome.quit() end },
  { "reboot", "reboot" },
  { "shutdown", "shutdown now" },
}

local awesome_submenu = {
  { "restart wm", awesome.restart },
  { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "manpage", consts.TERM_RUN("man awesome") },
  { "edit config", consts.TERM_RUN(consts.EDITOR .. " " .. awesome.conffile) },
}

return awful.menu({
  items = {
    { "awesome", awesome_submenu, beautiful.awesome_icon },
    { "system", system_submenu },
    { "open terminal", consts.TERM }
  }
})

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- local naughty = require("naughty")  -- dunst notification alternative
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Errors
-- Warn if error during startup/restart
if awesome.startup_errors then
    os.execute("notify-send 'Awesome startup err:\n" .. awesome.startup_errors .. "' -u critical")
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
        os.execute("notify-send 'Awesome err:\n" .. tostring(err) .. "' -u critical")
        in_error = false
    end)
end
-- }}}

-- {{{ Variables
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"  -- Windows key

-- Table of layouts to cover with awful.layout.inc, order matters.
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
-- }}}

-- {{{ Menu
myawesomemenu = {
    {"hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal },
    },
})

mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu,
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag(tags, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
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
    s.mytaglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    })

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
    })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    })
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    -- Awesome
    awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
    -- awful.key({ modkey }, "m", function() mymainmenu:show() end, { description = "show main menu", group = "awesome" }),

    -- Launcher
    awful.key({ modkey }, "Return", function() awful.spawn(terminal) end, { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end, { description = "run prompt", group = "launcher" }),
    awful.key({ modkey }, "p", function() menubar.show() end, { description = "show the menubar", group = "launcher" }),

    -- Tag
    awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
    awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),

    -- Client
    awful.key({ modkey }, "h", function() awful.client.focus.global_bydirection("left") end, { description = "focus left", group = "client" }),
    awful.key({ modkey }, "j", function() awful.client.focus.global_bydirection("down") end, { description = "focus down", group = "client" }),
    awful.key({ modkey }, "k", function() awful.client.focus.global_bydirection("up") end, { description = "focus up", group = "client" }),
    awful.key({ modkey }, "l", function() awful.client.focus.global_bydirection("right") end, { description = "focus right", group = "client" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.client.swap.global_bydirection("left") end, { description = "swap left", group = "client" }),
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.global_bydirection("down") end, { description = "swap down", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.global_bydirection("up") end, { description = "swap up", group = "client" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.client.swap.global_bydirection("right") end, { description = "swap right", group = "client" }),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey, "Control" }, "n", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal("request::activate", "key.unminimize", { raise = true })
        end
    end, { description = "restore minimized", group = "client" }),

    -- Screen
    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end, { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end, { description = "focus the previous screen", group = "screen" }),

    -- Layout
    awful.key({ modkey }, "Tab", function() awful.layout.inc(1) end, { description = "next layout", group = "layout" }),
    awful.key({ modkey, "Shift" }, "Tab", function() awful.layout.inc(-1) end, { description = "prev layout", group = "layout" }),
    awful.key({ modkey }, "]", function() awful.tag.incmwfact(0.05) end, { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey }, "[", function() awful.tag.incmwfact(-0.05) end, { description = "decrease master width factor", group = "layout" })
    -- awful.key({ modkey, "Shift" }, "]", function() awful.tag.incnmaster(1, nil, true) end, { description = "increase the number of master clients", group = "layout" }),
    -- awful.key({ modkey, "Shift" }, "[", function() awful.tag.incnmaster(-1, nil, true) end, { description = "decrease the number of master clients", group = "layout" }),
    -- awful.key({ modkey, "Control" }, "]", function() awful.tag.incncol(1, nil, true) end, { description = "increase the number of columns", group = "layout" }),
    -- awful.key({ modkey, "Control" }, "[", function() awful.tag.incncol(-1, nil, true) end, { description = "decrease the number of columns", group = "layout" })
)

for i, name in ipairs(tags) do
    function view_single_tag()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            tag:view_only()
        end
    end
    function toggle_tag_display()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end
    function move_client_to_tag()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:move_to_tag(tag)
            end
        end
    end
    function toggle_tag_on_focused_client()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:toggle_tag(tag)
            end
        end
    end
    globalkeys = gears.table.join(
        globalkeys,
        awful.key({ modkey }, name, view_single_tag, { description = "view tag #" .. name, group = "tag" }),
        awful.key({ modkey, "Control" }, name, toggle_tag_display, { description = "toggle tag #" .. name, group = "tag" }),
        awful.key({ modkey, "Shift" }, name, move_client_to_tag, { description = "move focused client to tag #" .. name, group = "tag" }),
        awful.key({ modkey, "Control", "Shift" }, name, toggle_tag_on_focused_client, { description = "toggle focused client on tag #" .. name, group = "tag" })
    )
end

clientkeys = gears.table.join(
    awful.key({ modkey }, "w", function(c)
        c:kill()
    end, { description = "close", group = "client" }),
    awful.key({ modkey, "Shift" }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey }, "f", awful.client.floating.toggle, { description = "toggle floating", group = "client" }),
    awful.key({ modkey }, "t", function(c)
        c.ontop = not c.ontop
    end, { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey }, "o", function(c)
        c:move_to_screen()
    end, { description = "move to screen", group = "client" }),
    awful.key({ modkey }, "n", function(c)
        -- Will always have input focus so cannot be unminimized, so no need to toggle
        c.minimized = true
    end, { description = "minimize", group = "client" }),
    awful.key({ modkey }, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
    end, { description = "(un)maximize", group = "client" })
)


clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            titlebars_enabled = false,
        },
    },
    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
            },
        },
        properties = { floating = true },
    },
    {
        rule = {
            class = "zoom",
            name = "zoom",
        },
        properties = {
            floating = true
        },
    },
    -- Add titlebars to dialogs only
    {
        rule_any = { type = { "dialog" } },
        properties = { titlebars_enabled = true },
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- New windows at bottom of slave stack
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )
    awful.titlebar(c):setup({
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal,
        },
        { -- Middle
            { -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c),
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal,
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal(),
        },
        layout = wibox.layout.align.horizontal,
    })
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)
-- }}}

local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local consts = require("config.consts")
local dropdown_menu = require("components.dropdown_menu")

return function(s)

  s.mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = dropdown_menu,
  })
  s.mykeyboardlayout = awful.widget.keyboardlayout()

  local unhovered_clock_string = "%a %b %e, %I:%M"
  local hovered_clock_string = "%a %b %e (%m-%d-%Y), %H:%M"
  s.textclock = wibox.widget.textclock(unhovered_clock_string)
  s.textclock:connect_signal("mouse::enter", function(t)
    t.format = hovered_clock_string
  end)
  s.textclock:connect_signal("mouse::leave", function(t)
    t.format = unhovered_clock_string
  end)

  s.mypromptbox = awful.widget.prompt()

  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(
    gears.table.join(
      awful.button({}, 1, function() awful.layout.inc(1) end),
      awful.button({}, 3, function() awful.layout.inc(-1) end),
      awful.button({}, 4, function() awful.layout.inc(1) end),
      awful.button({}, 5, function() awful.layout.inc(-1) end)
    )
  )

  local taglist_buttons = gears.table.join(
    awful.button(
      {}, 1,
      function(t) t:view_only() end
    ),
    awful.button(
      { consts.MODKEY }, 1,
      function(t)
        if client.focus then client.focus:move_to_tag(t) end
      end
    ),
    awful.button(
      {}, 3,
      awful.tag.viewtoggle
    ),
    awful.button(
      { consts.MODKEY }, 3,
      function(t)
        if client.focus then client.focus:toggle_tag(t) end
      end
    ),
    awful.button(
      {}, 4,
      function(t) awful.tag.viewnext(t.screen) end
    ),
    awful.button(
      {}, 5,
      function(t) awful.tag.viewprev(t.screen) end
    )
  )
  s.mytaglist = awful.widget.taglist({
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
  })

  local tasklist_buttons = gears.table.join(
    awful.button(
      {}, 1,
      function(c)
        if c == client.focus then
          c.minimized = true
        else
          c:emit_signal("request::activate", "tasklist", { raise = true })
        end
      end
    ),
    awful.button(
      {}, 3,
      function() awful.menu.client_list({ theme = { width = 250 } }) end
    ),
    awful.button(
      {}, 4,
      function() awful.client.focus.byidx(1) end
    ),
    awful.button(
      {}, 5,
      function() awful.client.focus.byidx(-1) end
    )
  )
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
    { -- Left
      layout = wibox.layout.fixed.horizontal,
      s.mylauncher,
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle
    { -- Right
      layout = wibox.layout.fixed.horizontal,
      s.mykeyboardlayout,
      wibox.widget.systray(),
      s.textclock,
      s.mylayoutbox,
    },
  })

end

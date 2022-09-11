local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local gears = require("gears")

local sharedtags = require("external.awesome-sharedtags")
local consts = require("config.consts")
local tags = require("config.tags")

local module = {}

module.globalkeys = gears.table.join(

  -- Awesome
  awful.key(
    { consts.MODKEY, "Control" }, "r",
    awesome.restart,
    { description = "reload awesome", group = "awesome" }
  ),
  awful.key(
    { consts.MODKEY, "Shift" }, "q",
    awesome.quit,
    { description = "quit awesome", group = "awesome" }
  ),
  awful.key(
    { consts.MODKEY }, "s",
    hotkeys_popup.show_help,
    { description = "show help", group = "awesome" }
  ),

  -- Launchers
  awful.key(
    { consts.MODKEY }, "Return",
    function() awful.spawn(consts.TERM) end,
    { description = "open a terminal", group = "launcher" }
  ),
  awful.key(
    { consts.MODKEY }, "r",
    function() awful.screen.focused().mypromptbox:run() end,
    { description = "run prompt", group = "launcher" }
  ),

  -- Tags
  awful.key(
    {consts.MODKEY}, "Left",
    awful.tag.viewprev,
    {description = "view previous", group = "tag"}
  ),
  awful.key(
    {consts.MODKEY}, "Right",
    awful.tag.viewnext,
    {description = "view next", group = "tag"}
  ),

  -- Client Focus
  awful.key(
    { consts.MODKEY }, "h",
    function() awful.client.focus.global_bydirection("left") end,
    { description = "focus left", group = "client" }
  ),
  awful.key(
    { consts.MODKEY }, "j",
    function() awful.client.focus.global_bydirection("down") end,
    { description = "focus down", group = "client" }
  ),
  awful.key(
    { consts.MODKEY }, "k",
    function() awful.client.focus.global_bydirection("up") end,
    { description = "focus up", group = "client" }
  ),
  awful.key(
    { consts.MODKEY }, "l",
    function() awful.client.focus.global_bydirection("right") end,
    { description = "focus right", group = "client" }
  ),

  -- Client Swap
  awful.key(
    { consts.MODKEY, "Shift" }, "h",
    function() awful.client.swap.global_bydirection("left") end,
    { description = "swap left", group = "client" }
  ),
  awful.key(
    { consts.MODKEY, "Shift" }, "j",
    function() awful.client.swap.global_bydirection("down") end,
    { description = "swap down", group = "client" }
  ),
  awful.key(
    { consts.MODKEY, "Shift" }, "k",
    function() awful.client.swap.global_bydirection("up") end,
    { description = "swap up", group = "client" }
  ),
  awful.key(
    { consts.MODKEY, "Shift" }, "l",
    function() awful.client.swap.global_bydirection("right") end,
    { description = "swap right", group = "client" }
  ),

  -- Urgent Client
  awful.key(
    { consts.MODKEY }, "u",
    awful.client.urgent.jumpto,
    { description = "jump to urgent client", group = "client" }
  ),
  awful.key(
    { consts.MODKEY, "Control" }, "n",
    function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then c:emit_signal("request::activate", "key.unminimize", {raise = true}) end
    end,
    { description = "restore minimized", group = "client" }
  ),

  -- Screen
  awful.key(
    { consts.MODKEY, "Control" }, "j",
    function() awful.screen.focus_relative(1) end,
    { description = "focus next screen", group = "screen" }
  ),
  awful.key(
    { consts.MODKEY, "Control" }, "k",
    function() awful.screen.focus_relative(-1) end,
    { description = "focus previous screen", group = "screen" }
  ),

  -- Layout
  awful.key(
    { consts.MODKEY }, "Tab",
    function() awful.layout.inc(1) end,
    { description = "next layout", group = "layout" }
  ),
  awful.key(
    { consts.MODKEY, "Shift" }, "Tab",
    function() awful.layout.inc(-1) end,
    { description = "prev layout", group = "layout" }
  ),
  awful.key(
    { consts.MODKEY }, "]",
    function() awful.tag.incmwfact(0.05) end,
    {description = "increase master width factor", group = "layout"}
  ),
  awful.key(
    { consts.MODKEY }, "[",
    function() awful.tag.incmwfact(-0.05) end,
    { description = "decrease master width factor", group = "layout" }
  )
  -- awful.key(
  --   { consts.MODKEY, "Shift" }, "]",
  --   function() awful.tag.incnmaster(1, nil, true) end,
  --   { description = "increase the number of master clients", group = "layout" }
  -- ),
  -- awful.key(
  --   { consts.MODKEY, "Shift" }, "[",
  --   function() awful.tag.incnmaster(-1, nil, true) end,
  --   { description = "decrease the number of master clients", group = "layout" }
  -- ),
  -- awful.key(
  --   { consts.MODKEY, "Control" }, "]",
  --   function() awful.tag.incncol(1, nil, true) end,
  --   { description = "increase the number of columns", group = "layout" }
  -- ),
  -- awful.key(
  --   { consts.MODKEY, "Control" }, "[",
  --   function() awful.tag.incncol(-1, nil, true) end,
  --   { description = "decrease the number of columns", group = "layout" }
  -- )
)

-- Append tag keybinds to globalkeys
for i, tag in ipairs(tags) do
  function view_single_tag()
    local screen = awful.screen.focused()
    sharedtags.viewonly(tag, screen)
  end
  function toggle_tag_display()
    local screen = awful.screen.focused()
    sharedtags.viewtoggle(tag, screen)
  end
  function move_client_to_tag()
    if client.focus then client.focus:move_to_tag(tag) end
  end
  function toggle_tag_on_focused_client()
    if client.focus then client.focus:toggle_tag(tag) end
  end
  module.globalkeys = gears.table.join(
    module.globalkeys,
    awful.key(
      { consts.MODKEY }, tag.name,
      view_single_tag,
      { description = "view tag #" .. tag.name, group = "tag" }
    ),
    awful.key(
      { consts.MODKEY, "Control" }, tag.name,
      toggle_tag_display,
      { description = "toggle tag #" .. tag.name, group = "tag" }
    ),
    awful.key(
      { consts.MODKEY, "Shift" }, tag.name,
      move_client_to_tag,
      { description = "move focused client to tag #" .. tag.name, group = "tag" }
    ),
    awful.key(
      { consts.MODKEY, "Control", "Shift" }, tag.name,
      toggle_tag_on_focused_client,
      { description = "toggle focused client on tag #" .. tag.name, group = "tag" }
    )
  )
end

module.clientkeys = gears.table.join(
  awful.key(
    { consts.MODKEY }, "w",
    function(c) c:kill() end,
    { description = "close", group = "client" }
  ),
  awful.key(
    { consts.MODKEY, "Shift" }, "f",
    function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = "toggle fullscreen", group = "client"}
  ),
  awful.key(
    { consts.MODKEY }, "f",
    awful.client.floating.toggle,
    { description = "toggle floating", group = "client" }
  ),
  awful.key(
    { consts.MODKEY }, "t",
    function(c) c.ontop = not c.ontop end,
    { description = "toggle keep on top", group = "client" }
  ),
  awful.key(
    { consts.MODKEY }, "o",
    function(c) c:move_to_screen() end,
    { description = "move to screen", group = "client" }
  ),
  awful.key(
    { consts.MODKEY }, "n",
    function(c)
      -- Will always have input focus so cannot be unminimized, so no need to toggle
      c.minimized = true
    end,
    { description = "minimize", group = "client" }
  ),
  awful.key(
    { consts.MODKEY }, "m",
    function(c)
      c.maximized = not c.maximized
      c:raise()
    end,
    { description = "(un)maximize", group = "client" }
  )
)

return module

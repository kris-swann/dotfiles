from typing import List

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from typing import List

from libqtile import bar, layout, widget
from libqtile.command import lazy
from libqtile.config import Click, Drag, Group, Key, Screen

mod = "mod4"
terminal = guess_terminal()

keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Focus left"),
    Key([mod], "l", lazy.layout.right(), desc="Focus right"),
    Key([mod], "j", lazy.layout.down(), desc="Focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Focus up"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "equal", lazy.layout.normalize(), desc="Reset window sizes"),

    Key([mod], "f", lazy.window.toggle_floating()),
    Key([mod, "shift"], "f", lazy.window.bring_to_front()),
    Key([mod], "grave", lazy.window.toggle_fullscreen()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
]

groups = [Group(i) for i in ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]]

for group in groups:
    group_key = group.name[0]
    keys.extend([
        Key(
            [mod], group_key, lazy.group[group.name].toscreen(toggle=False),
            desc=f"Switch to group {group.name}"
        ),
        Key(
            [mod, "shift"], group_key, lazy.window.togroup(group.name),
            desc=f"Move focust window to group {group.name}"
        ),
    ])

layouts = [
    layout.MonadTall(ratio=0.6),
    layout.Max(),
    layout.Floating(),
    # Try more layouts by unleashing below layouts.
    # layout.Columns(border_focus_stack=['#d75f5f', '#8f3d3d'], border_width=4),
    # layout.Max(),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(font='sans', fontsize=12, padding=3)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(),
                widget.WindowName(),
                widget.CurrentLayoutIcon(),
                widget.CurrentLayout(),
                widget.Battery(
                    full_char="🔌",
                    charge_char="🔌",
                    discharge_char="🔋",
                    show_short_text=False,
                    # Currently hour is broken, ideally this would be what i'd use.
                    # Until that's fixed, i'll just use percentage.
                    # format="{char} {percent:2.0%} ({hour:d}:{min:02d})"
                    format="{char} {percent:2.0%}"
                ),
                widget.Systray(),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
            ],
            24,
        ),
    ),
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(),
                widget.WindowName(),
                widget.CurrentLayoutIcon(),
                widget.CurrentLayout(),
                widget.Battery(
                    full_char="🔌",
                    charge_char="🔌",
                    discharge_char="🔋",
                    show_short_text=False,
                    # Currently hour is broken, ideally this would be what i'd use.
                    # Until that's fixed, i'll just use percentage.
                    # format="{char} {percent:2.0%} ({hour:d}:{min:02d})"
                    format="{char} {percent:2.0%}"
                ),
                widget.Systray(),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
            ],
            24,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules: List = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

wmname = "LG3D"  # Setting this makes java apps happier (see docs)

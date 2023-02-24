#!/bin/sh
# Similar to xinitrc, but is executed by (some) display managers after logging-in
# Display managers include:
#   LightDM (only when "Default Xsession" is selected)

. "$HOME/.profile"
. "$HOME/.xinitrc"

#!/bin/bash

IMAGE=/tmp/i3lock.png

# Take screenshot
import -window root $IMAGE

# Blur/Pixalate/Transform
# convert $IMAGE -blur 0x8 $IMAGE
# convert $IMAGE -paint 5 $IMAGE
convert $IMAGE -interpolate nearest -virtual-pixel mirror -spread 10 $IMAGE
# convert $IMAGE -scale 10% -scale 1000% $IMAGE

# Lock the screen
i3lock -i $IMAGE

# Clean up afterwards
rm $IMAGE

exit 0

from i3pystatus import Status
from i3pystatus.weather import weathercom
import logging

# For time format specification: "man strftime"

status = Status()

status.register("clock", format=["%l:%M %p", "%X"])
status.register("clock", format=["%a %b %e, %Y", "%x"])
status.register("moon", format="{moonicon} {status} {illum:.0f}%")
status.register(
    "weather",
    format="{condition} {current_temp}{temp_unit}{icon}[ Hi: {high_temp}] Lo: {low_temp} {wind_speed}{wind_unit}",
    colorize=True,
    log_level=logging.DEBUG,
    backend=weathercom.Weathercom(location_code="USMN0503:1:US", units="imperial"),
)
status.register(
    "battery",
    format="{status}{percentage:.0f}% {remaining:%E%hh:%Mm}",
    alert=True,
    alert_percentage=5,
    status={"DIS": "↓", "CHR": "↑", "FULL": "="},
)
status.register("disk", path="/", format="Disk {used:.0f}/{total:.0f}G")
status.register("uname", format="{nodename}")

status.run()

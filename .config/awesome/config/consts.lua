local module = {}

module.EDITOR = os.getenv("EDITOR") or "nvim"
module.TERM = "kitty"
module.TERM_RUN = function(cmd) return module.TERM .. " -e " .. cmd end
module.MODKEY = "Mod4" -- Windows key

return module

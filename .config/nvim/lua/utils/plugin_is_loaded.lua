-- Cannot use this until after plugins have been loaded
local function plugin_is_loaded(name)
  return (packer_plugins[name] and packer_plugins[name].loaded)
end

return plugin_is_loaded

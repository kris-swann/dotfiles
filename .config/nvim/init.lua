-- For faster startup times, this should go as close to top as possible (may not have been installed yet, so use pcall)
pcall(function() require('impatient') end)

require('kris')
require('pkgs.packer')

local rebuild_spellfiles = require('utils.rebuild_spellfiles')
rebuild_spellfiles()
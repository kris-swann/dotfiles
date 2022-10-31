-- For faster startup times, this should go as close to top as possible (may not have been installed yet, so use pcall)
pcall(require, 'impatient')

require('kris')

local rebuild_spellfiles = require('util.rebuild_spellfiles')
rebuild_spellfiles()

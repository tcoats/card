requirejs = require 'requirejs'
requirejs.config nodeRequire: require

requirejs ['infra/cson', 'infra/hub'], (cson, hub) ->
	cson 'config.cson', (config) ->
		requirejs ("#{s}/#{s}" for s in config.systems), ->
			for e in config.events
				hub.emit e.n, e.p

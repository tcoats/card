requirejs = require 'requirejs'
requirejs.config nodeRequire: require

requirejs ['infra/cson', 'infra/hub'], (cson, hub) ->
	cson 'bootstrap.cson', (bootstrap) ->
		requirejs ("#{s}/#{s}" for s in bootstrap.systems), ->
			for e in bootstrap.events
				hub.emit e.n, e.p

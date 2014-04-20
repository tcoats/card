define ['infra/hub', 'cson'], (hub, CSON) ->
	(path, cb) ->
		CSON.parseFile path, (err, data) =>
			return hub.emit 'error', "Bad #{path}" if err?
			cb data

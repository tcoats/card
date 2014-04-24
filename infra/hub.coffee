define ['infra/template'], (template) ->
	# Simple publish and subscribe
	# Publish is async
	class Hub
		constructor: ->
			@listeners = {}
		
		_every: (e, cb) =>
			@listeners[e] = [] if !@listeners[e]?
			@listeners[e].push cb
			
			off: =>
				index = @listeners[e].indexOf(cb)
				if index isnt -1
					@listeners[e].splice index, 1
		
		# Subscribe to an event
		every: (events, cb) =>
			events = [events] unless events instanceof Array
			bindings = for e in events
				event: e
			
			for e in bindings
				e.binding = @_every e.event, cb
			
			off: => e.binding.off() for e in bindings
		
		_once: (e, cb) =>
			binding = @every e, (payload) =>
				binding.off()
				cb payload
			off: -> binding.off()
		
		once: (events, cb) =>
			events = [events] unless events instanceof Array
			
			count = 0
			bindings = for e in events
				count++
				event: e
				complete: no
			
			for e in bindings
				e.binding = @_once e.event, ->
					count--
					e.complete = yes
					cb() if count is 0
			
			off: -> e.binding.off() for e in bindings
		
		any: (events, cb) =>
			bindings = for e in events
				event: e
			
			unbind = -> e.binding.off() for e in bindings
			
			for e in bindings
				e.binding = @_once e.event, ->
					unbind()
					cb()
			
			off: unbind
		
		# Publish an event
		emit: (e, payload) =>
			console.log " - #{template e, payload}"
			
			return if !@listeners[e]?
			for listener in @listeners[e].slice()
				listener payload

	new Hub()

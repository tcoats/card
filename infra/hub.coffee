define ['infra/template'], (template) ->
	# Simple publish and subscribe
	# Publish is async
	class Hub
		constructor: ->
			@listeners = {}
		
		# Subscribe to an event
		on: (e, cb) =>
			@listeners[e] = [] if !@listeners[e]?
			@listeners[e].push cb
			off: =>
				index = @listeners[e].indexOf(cb)
				if index isnt -1
					@listeners[e].splice index, 1
		
		one: (e, cb) =>
			binding = @on e, (payload) =>
				binding.off()
				cb payload
			off: -> binding.off()
		
		saga: (events, cb) ->
			count = 0
			bindings = for e in events
				count++
				event: e
				complete: no
			
			for e in bindings
				e.binding = @one e.event, ->
					count--
					e.complete = yes
					cb() if count is 0
			
			off: ->
				e.binding.off() for e in bindings
		
		# Publish an event
		emit: (e, payload) =>
			console.log template e, payload
			
			return if !@listeners[e]?
			for listener in @listeners[e].slice()
				listener payload

	new Hub()

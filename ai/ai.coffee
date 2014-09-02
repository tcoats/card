define ['inject', 'boid', 'unit'], (inject, Boid, Unit) ->
	class AI
		constructor: ->
			@entities = []
			@types =
				boid: Boid
				unit: Unit
			inject.bind 'setup', @setup
			inject.bind 'step', @step
			inject.bind 'register ai', @register
		
		setup: =>
			inject.one('stat notify') 'istouched',
				(entity, _, istouched) =>
					if istouched
						inject.one('abs stat') entity, timesincetouch: 0 # reset counter
					else
						inject.one('rel stat') entity, timesincetouch: 1 # count time since touched
		
		step: =>
			entity.step() for entity in @entities
		
		register: (entity, n) =>
			return if !@types[n]?
			entity.ai = new @types[n] entity, n
			@entities.push entity.ai
		
	new AI()
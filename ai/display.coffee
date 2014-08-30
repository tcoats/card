define ['inject', 'colors'], (inject, colors) ->
	class Display
		constructor: ->
			@entities = []
			inject.bind 'step', @step
			inject.bind 'register display', @register
		
		# Integrate
		step: =>
			#background colors.bg
			for entity in @entities
				@[entity.n] entity.e()
		
		boid: (e) =>
			fill colors.bg
			stroke colors.blue
			ellipse e.c.p.x, e.c.p.y, 16, 16
		
		register: (entity, name) =>
			entity.d = n: name, e: -> entity
			@entities.push entity.d
		
	new Display()
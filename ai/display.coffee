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
			#console.log e.stats.distancetravelled
			fill colors.bg
			color = colors.blue
			if e.stats.iscommunity
				color = colors.red
			if e.stats.timesincetouch < 10
				color = colors.gold
			stroke color
			ellipse e.coord.p.x, e.coord.p.y, 16, 16
		
		register: (entity, name) =>
			entity.d = n: name, e: -> entity
			@entities.push entity.d
		
	new Display()
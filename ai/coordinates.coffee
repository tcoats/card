define ['inject'], (inject) ->
	class Coordinates
		constructor: ->
			@entities = []
			
			inject.bind 'step', @step
			inject.bind 'register coordinates', @register
			inject.bind 'delta position', @delta
			inject.bind 'each by distance', @eachbydistance
		
		# Clip
		step: =>
			for entity in @entities
				entity.p.x = width + 10 if entity.p.x < -10
				entity.p.x = -10 if entity.p.x > width + 10
				entity.p.y = height + 10 if entity.p.y < -10
				entity.p.y = -10 if entity.p.y > height + 10
		
		register: (entity, p) =>
			entity.c = p: p, e: -> entity
			@entities.push entity.c
		
		delta: (entity, d) =>
			entity.c.p.add d
		
		eachbydistance: (p, r, cb) =>
			for entity in @entities
				distance = p5.Vector.dist p, entity.p
				continue if distance > r
				cb distance, entity.e()
		
	new Coordinates()
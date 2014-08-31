define ['inject', 'p2'], (inject, p2) ->
	class Physics
		constructor: ->
			@maxspeed = 4
			@maxsteeringforce = 0.05
			@entities = []
			inject.bind 'step', @step
			inject.bind 'register physics', @register
			inject.bind 'apply force', @apply
			inject.bind 'calculate steering', @calculatesteering
			inject.bind 'each by distance', @eachbydistance
		
		# Integrate
		step: =>
			for entity in @entities
				entity.v.add entity.a
				entity.a.mult 0
				entity.a.limit @maxspeed
				inject.one('rel stat') entity.e(), distancetravelled: entity.v
				entity.p.add entity.v
				entity.p.x = width + 10 if entity.p.x < -10
				entity.p.x = -10 if entity.p.x > width + 10
				entity.p.y = height + 10 if entity.p.y < -10
				entity.p.y = -10 if entity.p.y > height + 10
		
		register: (entity, n, p, v) =>
			@entities.push entity.phys =
				n: n
				p: p
				v: v
				a: createVector(0, 0)
				e: -> entity
		
		apply: (entity, f) =>
			entity.phys.a.add f

		calculatesteering: (entity, steer) =>
			result = steer.get()
			result.normalize()
			result.mult @maxspeed
			result.sub entity.phys.v
			result.limit @maxsteeringforce
			result
		
		eachbydistance: (p, r, cb) =>
			for entity in @entities
				distance = p5.Vector.dist p, entity.p
				continue if distance > r
				cb distance, entity.e()
			
	new Physics()
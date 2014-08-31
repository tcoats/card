define ['inject', 'p2'], (inject, p2) ->
	class Physics
		constructor: ->
			@maxspeed = 4
			@maxsteeringforce = 30
			@entities = []
			@world = new p2.World gravity: [0, 0]
			
			inject.bind 'step', @step
			inject.bind 'register physics', @register
			inject.bind 'apply force', @apply
			inject.bind 'calculate steering', @calculatesteering
			inject.bind 'each by distance', @eachbydistance
		
		# Integrate
		step: =>
			@world.step 1 / 60
			for entity in @entities
				length = p2.vec2.len entity.b.velocity
				if length > 120
					p2.vec2.normalize entity.b.velocity, entity.b.velocity
					p2.vec2.scale entity.b.velocity, entity.b.velocity, 120
				entity.b.position[0] = width + 10 if entity.b.position[0] < -10
				entity.b.position[0] = -10 if entity.b.position[0] > width + 10
				entity.b.position[1] = height + 10 if entity.b.position[1] < -10
				entity.b.position[1] = -10 if entity.b.position[1] > height + 10
		
		register: (entity, n, p, v) =>
			body = new p2.Body mass: 5, position: p, velocity: v
			body.damping = 0
			shape = new p2.Circle 8
			body.addShape shape
			@world.addBody body
			@entities.push entity.phys =
				n: n
				b: body
				s: shape
				e: -> entity
		
		apply: (entity, f) =>
			p2.vec2.add entity.phys.b.force, entity.phys.b.force, f

		calculatesteering: (entity, steer) =>
			result = [0, 0]
			p2.vec2.normalize result, steer
			p2.vec2.scale result, result, @maxspeed
			p2.vec2.sub result, result, entity.phys.b.velocity
			length = p2.vec2.len result
			if length > @maxsteeringforce
				p2.vec2.scale result, result, @maxsteeringforce / length
			result
		
		eachbydistance: (p, r, cb) =>
			for entity in @entities
				distance = p2.vec2.dist p, entity.b.position
				continue if distance > r
				cb distance, entity.e()
			
	new Physics()
define ['inject'], (inject) ->
	class Physics
		constructor: ->
			@maxspeed = 3
			@maxsteeringforce = 0.05
			@entities = []
			inject.bind 'step', @step
			inject.bind 'register physics', @register
			inject.bind 'apply force', @apply
			inject.bind 'seek target', @seek
			inject.bind 'calculate steering', @calculatesteering
		
		# Integrate
		step: =>
			for entity in @entities
				entity.v.add entity.a
				entity.a.mult 0
				entity.a.limit @maxspeed
				inject.one('delta position') entity.e(), entity.v
		
		register: (entity, v, a) =>
			entity.p = v: v, a: a, e: -> entity
			@entities.push entity.p
		
		apply: (entity, f) =>
			entity.p.a.add f
		
		seek: (entity, target) =>
		
		
		calculatesteering: (entity, steer) =>
			result = steer.get()
			result.normalize()
			result.mult @maxspeed
			result.sub entity.p.v
			result.limit @maxsteeringforce
			result
			
		
	new Physics()
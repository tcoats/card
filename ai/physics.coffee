define ['inject'], (inject) ->
	class Physics
		constructor: ->
			@entities = []
			inject.bind 'step', @step
			inject.bind 'register physics', @register
			inject.bind 'apply force', @apply
			inject.bind 'seek target', @seek
		
		# Integrate
		step: =>
			for entity in @entities
				entity.v.add entity.a
				entity.a.mult 0
				entity.a.limit 3
				inject.one('delta position') entity.e(), entity.v
		
		register: (entity, v, a) =>
			entity.p = v: v, a: a, e: -> entity
			@entities.push entity.p
		
		apply: (entity, f) =>
			entity.p.a.add f
		
		seek: (entity, target) =>
			
		
	new Physics()
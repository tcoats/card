define ['inject'], (inject) ->
	class AI
		constructor: ->
			@entities = []
			
			inject.bind 'step', @step
			inject.bind 'register ai', @register
			
		step: =>
			for entity in @entities
				@separate entity
				@align entity
				@cohere entity
		
		register: (entity, n) =>
			entity.ai =
				n: n
				isrepulsed: no
				e: -> entity
			@entities.push entity.ai
		
		separate: (entity) =>
			averagerepulsion = createVector 0, 0
			inject.one('each by distance') entity.e().c.p, 25, (d, boid) =>
				return if boid is entity.e()
				diff = p5.Vector.sub entity.e().c.p, boid.c.p
				diff.div diff.mag() * 2
				averagerepulsion.add diff
			
			isrepulsed = averagerepulsion.mag() isnt 0
			if entity.isrepulsed isnt isrepulsed
				entity.isrepulsed = isrepulsed
			return if !isrepulsed
			
			force = inject.one('calculate steering') entity.e(), averagerepulsion
			force.mult 4.5
			inject.one('apply force') entity.e(), force

		align: (entity) =>
			averagedirection = createVector 0, 0
			inject.one('each by distance') entity.e().c.p, 50, (d, boid) =>
				return if boid is entity.e()
				averagedirection.add boid.p.v
			return if averagedirection.mag() is 0
			
			forece = inject.one('calculate steering') entity.e(), averagedirection
			forece.mult 1.0
			inject.one('apply force') entity.e(), forece

		cohere: (entity) =>
			averageposition = createVector 0, 0
			count = 0
			inject.one('each by distance') entity.e().c.p, 100, (d, boid) =>
				return if boid is entity.e()
				averageposition.add boid.c.p # Add location
				count++
			return if averageposition.mag() is 0
			averageposition.div count
			direction = p5.Vector.sub averageposition, entity.e().c.p
			force = inject.one('calculate steering') entity.e(), direction
			force.mult 1.0
			inject.one('apply force') entity.e(), force
	
	new AI()
define ['inject', 'boid'], (inject, Boid) ->
	class AI
		constructor: ->
			# Add an initial set of boids into the system
			@boids = []
			@boids.push new Boid random(width), random(height) for _ in [0..100]
	
			inject.bind 'step', @step
		
		step: =>
			boid.run @boids for boid in @boids
	
	new AI()
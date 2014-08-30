define ['inject', 'boid'], (inject, Boid) ->
	class AI
		constructor: ->
			# Add an initial set of boids into the system
			@boids = []
			for _ in [0..90]
				@boids.push new Boid(
					createVector(random(width), random(height)),
					p5.Vector.random2D(),
					createVector(0, 0),
					'boid'
				)
				
			for _ in [0..10]
				@boids.push new Boid(
					createVector(random(width), random(height)),
					p5.Vector.random2D(),
					createVector(0, 0),
					'boid2'
				)
	
			inject.bind 'step', @step
		
		step: =>
			boid.step @boids for boid in @boids
	
	new AI()
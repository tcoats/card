define ['inject', 'boid'], (inject, Boid) ->
	class AI
		constructor: ->
			# Add an initial set of boids into the system
			@boids = []
			for _ in [0..90]
				@boids.push new Boid
					position: createVector random(width), random(height)
					velocity: p5.Vector.random2D()
					name: 'boid'
				
			for _ in [0..10]
				@boids.push new Boid
					position: createVector random(width), random(height)
					velocity: p5.Vector.random2D()
					name: 'boid2'
				
			@boids.push new Boid
				position: createVector random(width), random(height)
				velocity: p5.Vector.random2D()
				name: 'boid3'
	
			inject.bind 'step', @step
		
		step: =>
			boid.step @boids for boid in @boids
	
	new AI()
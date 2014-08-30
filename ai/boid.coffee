# # Reynolds Boid
define ['colors'], (colors) ->
	class Boid
		constructor: (x, y) ->
			@a = createVector 0, 0
			@v = p5.Vector.random2D()
			@p = createVector x, y
			@r = 3.0
			@maxspeed = 3
			@maxsteeringforce = 0.05 # Maximum steering force

		run: (boids) ->
			@flock boids
			@update()
			@borders()
			@render()

		# Draw boid as a circle
		render: ->
			fill colors.bg
			stroke colors.blue
			ellipse @p.x, @p.y, 16, 16
		
		# We accumulate a new acceleration each time based on three rules
		flock: (boids) ->
			sep = @separate boids
			ali = @align boids
			coh = @cohesion boids
			
			# Arbitrarily weight these forces
			sep.mult 2.5
			ali.mult 1.0
			coh.mult 1.0
			
			@apply sep
			@apply ali
			@apply coh

		# Integrate
		update: ->
			@v.add @a # Update velocity
			@v.limit @maxspeed # Limit speed
			@p.add @v # Update position
			@a.mult 0 # Reset accelertion to 0 each cycle

		# Forces go into acceleration
		apply: (force) -> @a.add force

		# A method that calculates and applies a steering force towards a target
		# STEER = DESIRED MINUS VELOCITY
		seek: (target) ->
			desired = p5.Vector.sub target, @p # position to target
			desired.normalize()
			desired.mult @maxspeed
			steer = p5.Vector.sub desired, @v # Steering = Desired minus Velocity
			steer.limit @maxsteeringforce # Limit to maximum steering force
			steer

		# Wraparound
		borders: ->
			@p.x = width + @r if @p.x < -@r
			@p.x = -@r if @p.x > width + @r
			@p.y = height + @r if @p.y < -@r
			@p.y = -@r if @p.y > height + @r

		# # Separation
		# Method checks for nearby boids and steers away
		separate: (boids) ->
			desiredseparation = 25.0
			steer = createVector 0, 0
			
			# For every boid in the system, check if it's too close
			count = 0
			for boid in boids
				d = p5.Vector.dist @p, boid.p
				continue if d is 0 or d >= desiredseparation # 0 when you are yourself
				diff = p5.Vector.sub @p, boid.p # vector away from neighbor
				diff.normalize()
				diff.div d # Weight by distance
				steer.add diff
				count++
			
			steer.div count if count > 0 # Average -- divide by how many
			
			# Steering = Desired - Velocity
			if steer.mag() > 0
				steer.normalize()
				steer.mult @maxspeed
				steer.sub @v
				steer.limit @maxsteeringforce
			steer

		# # Alignment
		# For every nearby boid in the system, calculate the average velocity
		align: (boids) ->
			neighbordist = 50
			sum = createVector 0, 0
			count = 0
			
			for boid in boids
				d = p5.Vector.dist @p, boid.p
				if d > 0 and d < neighbordist
					sum.add boid.v
					count++
			
			return createVector 0, 0 if count is 0
			
			sum.div count
			sum.normalize()
			sum.mult @maxspeed
			steer = p5.Vector.sub sum, @v
			steer.limit @maxsteeringforce
			steer

		# # Cohesion
		# For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
		cohesion: (boids) ->
			neighbordist = 50
			sum = createVector 0, 0
			count = 0
			
			for boid in boids
				d = p5.Vector.dist @p, boid.p
				if d > 0 and d < neighbordist
					sum.add boid.p # Add location
					count++
					
			return createVector 0, 0 if count is 0
			
			sum.div count
			@seek sum # Steer towards the location
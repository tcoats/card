# # Reynolds Boid
define ['inject'], (inject) ->
	class Boid
		constructor: (p, v, a, n) ->
			inject.one('register coordinates') @, p
			inject.one('register physics') @, v, a
			inject.one('register display') @, n
			
			@maxspeed = 3
			@maxsteeringforce = 0.05 # Maximum steering force

		step: (boids) ->
			@separate()
			@align()
			@cohere()

		separate: ->
			steer = createVector 0, 0
			count = 0
			
			for boid in inject.one('select by distance') @c.p, 25
				continue if boid is @
				diff = p5.Vector.sub @c.p, boid.c.p
				d = diff.mag()
				diff.normalize()
				diff.div d # Weight by distance
				steer.add diff
				count++
			
			# Average -- divide by how many
			steer.div count if count > 0
			return if steer.mag() is 0
			
			# Steering = Desired - Velocity
			steer.normalize()
			steer.mult @maxspeed
			steer.sub @p.v
			steer.limit @maxsteeringforce
			steer.mult 2.5
			inject.one('apply force') @, steer

		align: ->
			sum = createVector 0, 0
			count = 0
			
			for boid in inject.one('select by distance') @c.p, 50
				continue if boid is @
				sum.add boid.p.v
				count++
			
			return createVector 0, 0 if count is 0
			
			sum.div count
			sum.normalize()
			sum.mult @maxspeed
			steer = p5.Vector.sub sum, @p.v
			steer.limit @maxsteeringforce
			steer.mult 1.0
			inject.one('apply force') @, steer

		cohere: ->
			sum = createVector 0, 0
			count = 0
			
			for boid in inject.one('select by distance') @c.p, 100
				continue if boid is @
				sum.add boid.c.p # Add location
				count++
					
			return createVector 0, 0 if count is 0
			
			sum.div count
			@seek sum

		seek: (target) ->
			# position to target
			desired = p5.Vector.sub target, @c.p
			desired.normalize()
			desired.mult @maxspeed
			# Steering = Desired minus Velocity
			steer = p5.Vector.sub desired, @p.v
			steer.limit @maxsteeringforce
			steer.mult 1.0
			inject.one('apply force') @, steer
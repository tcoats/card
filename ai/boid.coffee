# # Reynolds Boid
define ['inject'], (inject) ->
	class Boid
		constructor: (options) ->
			inject.one('register coordinates') @, options.position
			inject.one('register physics') @, options.velocity
			inject.one('register display') @, options.name

		step: =>
			@separate()
			@align()
			@cohere()

		separate: =>
			averagerepulsion = createVector 0, 0
			inject.one('each by distance') @c.p, 25, (d, boid) =>
				return if boid is @
				diff = p5.Vector.sub @c.p, boid.c.p
				diff.div diff.mag() * 2
				averagerepulsion.add diff
			return if averagerepulsion.mag() is 0
			
			force = inject.one('calculate steering') @, averagerepulsion
			force.mult 4.5
			inject.one('apply force') @, force

		align: =>
			averagedirection = createVector 0, 0
			inject.one('each by distance') @c.p, 50, (d, boid) =>
				return if boid is @
				averagedirection.add boid.p.v
			return if averagedirection.mag() is 0
			
			forece = inject.one('calculate steering') @, averagedirection
			forece.mult 1.0
			inject.one('apply force') @, forece

		cohere: =>
			averageposition = createVector 0, 0
			count = 0
			inject.one('each by distance') @c.p, 100, (d, boid) =>
				return if boid is @
				averageposition.add boid.c.p # Add location
				count++
			return if averageposition.mag() is 0
			averageposition.div count
			direction = p5.Vector.sub averageposition, @c.p
			force = inject.one('calculate steering') @, direction
			force.mult 1.0
			inject.one('apply force') @, force
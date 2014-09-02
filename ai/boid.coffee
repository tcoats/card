define ['inject', 'p2'], (inject, p2) ->
	class Boid
		constructor: (entity, n) ->
			@e = entity
			@n = n
		
		step: =>
			@separate()
			@align()
			@cohere()
		
		separate: =>
			averagerepulsion = [0, 0]
			inject.one('each by distance') @e.phys.b.position, 25, (d, e) =>
				return if e is @e or !e.ai?
				diff = [0, 0]
				# proportional to distance from other?
				p2.vec2.sub diff, @e.phys.b.position, e.phys.b.position
				p2.vec2.normalize diff, diff
				p2.vec2.add averagerepulsion, averagerepulsion, diff
			
			istouched = p2.vec2.len(averagerepulsion) isnt 0
			inject.one('abs stat') @e, istouched: istouched
			return if !istouched
			
			inject.one('scale to max velocity') averagerepulsion
			force = inject.one('calculate steering') @e.phys.b.velocity, averagerepulsion
			p2.vec2.scale force, force, 2
			inject.one('apply force') @e, force

		align: =>
			averagedirection = [0, 0]
			count = 0
			inject.one('each by distance') @e.phys.b.position, 50, (d, e) =>
				return if e is @e or !e.ai?
				p2.vec2.add averagedirection, averagedirection, e.phys.b.velocity
				count++
			return if p2.vec2.len(averagedirection) is 0
			
			inject.one('scale to max velocity') averagedirection
			force = inject.one('calculate steering') @e.phys.b.velocity, averagedirection
			p2.vec2.scale force, force, 0.5
			inject.one('apply force') @e, force

		cohere: =>
			averageposition = [0, 0]
			count = 0
			inject.one('each by distance') @e.phys.b.position, 100, (d, e) =>
				return if e is @e or !e.ai?
				p2.vec2.add averageposition, averageposition, e.phys.b.position
				count++
			
			inject.one('abs stat') @e,
				iscommunity: count > 0
			iscommunity = count > 0
			
			return if p2.vec2.len(averageposition) is 0
			p2.vec2.scale averageposition, averageposition, 1 / count
			
			targetvelocity = inject.one('calculate seeking') @e.phys.b.position, averageposition
			force = inject.one('calculate steering') @e.phys.b.velocity, targetvelocity
			p2.vec2.scale force, force, 1
			inject.one('apply force') @e, force
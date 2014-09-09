define ['inject', 'p2'], (inject, p2) ->
	class Unit
		constructor: (entity, n) ->
			@e = entity
			@n = n
		
		step: =>
			@separate()
			@align()
		
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
			p2.vec2.scale force, force, 1
			inject.one('apply force') @e, force
		
		align: =>
			@e.target = null
			
			closestunit = null
			closestdistance = 200
			
			inject.one('each by distance') @e.phys.b.position, 200, (d, e) =>
				return if e is @e or !e.ai?
				if d < closestdistance
					closestunit = e
					closestdistance = d
				
			return if !closestunit?
			
			position = p2.vec2.clone closestunit.phys.b.position
			p2.vec2.sub position, position, @e.phys.b.position
			normal = [0, 0]
			p2.vec2.normalize normal, position
			p2.vec2.scale normal, normal, 30
			p2.vec2.sub position, position, normal
			@e.target = p2.vec2.clone position
			p2.vec2.add @e.target, @e.target, @e.phys.b.position
			
			nextclosestunit = null
			closestdistance = 50
			inject.one('each by distance') closestunit.phys.b.position, 35, (d, e) =>
				return if e is @e or e is closestunit or !e.ai?
				if d < closestdistance
					nextclosestunit = e
					closestdistance = d
			
			if nextclosestunit?
				alignpos = [0, 0]
				p2.vec2.sub alignpos, closestunit.phys.b.position, nextclosestunit.phys.b.position
				p2.vec2.normalize alignpos, alignpos
				p2.vec2.scale alignpos, alignpos, 30
				
				anticlockwise = (vec) ->
					x = vec[0]
					y = vec[1]
					[-y, x]
				
				point1 = p2.vec2.clone alignpos
				point2 = [point1[1], -point1[0]]
				point3 = [-point1[1], point1[0]]
				
				p2.vec2.add point1, closestunit.phys.b.position, point1
				p2.vec2.add point2, closestunit.phys.b.position, point2
				p2.vec2.add point3, closestunit.phys.b.position, point3
				
				p2.vec2.sub point1, point1, @e.phys.b.position
				p2.vec2.sub point2, point2, @e.phys.b.position
				p2.vec2.sub point3, point3, @e.phys.b.position
				
				len1 = p2.vec2.len point1
				len2 = p2.vec2.len point2
				len3 = p2.vec2.len point3
				
				target = null
				if len1 < len2 # and len1 < len3
				 	target = point1
				else #if len2 < len3
				#if len2 < len3
					target = point2
				#else
				#	target = point3
				
				@e.target = p2.vec2.clone target
				p2.vec2.add @e.target, @e.target, @e.phys.b.position
				
				
				inject.one('limit to max velocity') target
				force = [0, 0]
				p2.vec2.scale force, target, 10
				inject.one('apply force') @e, force
				return
			
			force = [0, 0]
			inject.one('limit to max velocity') position
			p2.vec2.scale force, position, 20
			inject.one('apply force') @e, force
			
			
			
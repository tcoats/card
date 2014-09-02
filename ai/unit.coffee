define ['inject', 'p2'], (inject, p2) ->
	class Unit
		constructor: (entity, n) ->
			@e = entity
			@n = n
		
		step: =>
			@align()
		
		align: =>
			averageposition = [0, 0]
			distances = []
			inject.one('each by distance') @e.phys.b.position, 50, (d, e) =>
				return if e is @e or !e.ai?
				distances.push
					d: d
					e: e
			
			return if distances.length is 0
			
			distances.sort (a,b) -> if a.d >= b.d then 1 else -1
			force1 = [0, 0]
			p2.vec2.sub force1, distances[0].e.phys.b.position, @e.phys.b.position
			normal1 = [0, 0]
			p2.vec2.normalize normal1, force1
			ideal1 = [0, 0]
			p2.vec2.scale ideal1, normal1, 20
			p2.vec2.sub force1, force1, ideal1
			p2.vec2.scale force1, force1, 10
			inject.one('apply force') @e, force1
			
			return if distances.length is 1
			
			force2 = [0, 0]
			p2.vec2.sub force2, distances[1].e.phys.b.position, @e.phys.b.position
			normal2 = [0, 0]
			p2.vec2.normalize normal2, force2
			ideal2 = [0, 0]
			p2.vec2.scale ideal2, normal2, 20
			p2.vec2.sub force2, force2, ideal2
			p2.vec2.scale force2, force2, 10
			inject.one('apply force') @e, force2
			
			dist = p2.vec2.dist distances[0].e.phys.b.position, distances[1].e.phys.b.position
			return if dist < 20
			
			mid = [0, 0]
			p2.vec2.add mid, distances[0].e.phys.b.position, distances[1].e.phys.b.position
			p2.vec2.scale mid, mid, 0.5
			force3 = [0, 0]
			p2.vec2.sub force3, mid, @e.phys.b.position
			p2.vec2.normalize force3, force3
			p2.vec2.scale force3, force3, 300
			p2.vec2.scale force3, force3, p2.vec2.dot normal1, normal2
			inject.one('apply force') @e, force3
			
			
			
			
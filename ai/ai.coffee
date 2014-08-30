define ['inject', 'hub'], (inject, hub) ->
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
				e: -> entity
			@entities.push entity.ai
		
		separate: (entity) =>
			averagerepulsion = createVector 0, 0
			inject.one('each by distance') entity.e().coord.p, 25, (d, boid) =>
				return if boid is entity.e() or !boid.ai?
				diff = p5.Vector.sub entity.e().coord.p, boid.coord.p
				diff.div diff.mag() * 2
				averagerepulsion.add diff
			
			if !entity.timesincetouch?
				entity.timesincetouch
			if averagerepulsion.mag() is 0
				entity.timesincetouch++
				return
			entity.timesincetouch = 0
			
			force = inject.one('calculate steering') entity.e(), averagerepulsion
			force.mult 4.5
			inject.one('apply force') entity.e(), force

		align: (entity) =>
			averagedirection = createVector 0, 0
			inject.one('each by distance') entity.e().coord.p, 50, (d, boid) =>
				return if boid is entity.e() or !boid.ai?
				averagedirection.add boid.phys.v
			return if averagedirection.mag() is 0
			
			forece = inject.one('calculate steering') entity.e(), averagedirection
			forece.mult 1.0
			inject.one('apply force') entity.e(), forece

		cohere: (entity) =>
			averageposition = createVector 0, 0
			count = 0
			inject.one('each by distance') entity.e().coord.p, 100, (d, boid) =>
				return if boid is entity.e() or !boid.ai?
				averageposition.add boid.coord.p # Add location
				count++
			
			if !entity.iscommunity?
				entity.iscommunity = no
			iscommunity = count > 0
			if entity.iscommunity isnt iscommunity
				entity.iscommunity = iscommunity
			
			return if averageposition.mag() is 0
			averageposition.div count
			direction = p5.Vector.sub averageposition, entity.e().coord.p
			force = inject.one('calculate steering') entity.e(), direction
			force.mult 1.0
			inject.one('apply force') entity.e(), force
	
	new AI()
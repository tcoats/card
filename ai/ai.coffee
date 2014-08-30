define ['inject', 'hub'], (inject, hub) ->
	class AI
		constructor: ->
			@entities = []
			
			inject.bind 'setup', @setup
			inject.bind 'step', @step
			inject.bind 'register ai', @register
		
		setup: =>
			# Derived statistic
			inject.one('stat notify') 'istouched',
				(entity, _, istouched) =>
					if istouched
						inject.one('abs stat') entity, timesincetouch: 0
					else
						inject.one('rel stat') entity, timesincetouch: 1
		
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
			inject.one('each by distance') entity.e().coord.p, 25, (d, e) =>
				return if e is entity.e() or !e.ai?
				diff = p5.Vector.sub entity.e().coord.p, e.coord.p
				diff.div diff.mag() * 2
				averagerepulsion.add diff
			
			istouched = averagerepulsion.mag() isnt 0
			inject.one('abs stat') entity.e(), istouched: istouched
			return if !istouched
			
			force = inject.one('calculate steering') entity.e(), averagerepulsion
			force.mult 4.5
			inject.one('apply force') entity.e(), force

		align: (entity) =>
			averagedirection = createVector 0, 0
			inject.one('each by distance') entity.e().coord.p, 50, (d, e) =>
				return if e is entity.e() or !e.ai?
				averagedirection.add e.phys.v
			return if averagedirection.mag() is 0
			
			forece = inject.one('calculate steering') entity.e(), averagedirection
			forece.mult 1.0
			inject.one('apply force') entity.e(), forece

		cohere: (entity) =>
			averageposition = createVector 0, 0
			count = 0
			inject.one('each by distance') entity.e().coord.p, 100, (d, e) =>
				return if e is entity.e() or !e.ai?
				averageposition.add e.coord.p # Add location
				count++
			
			inject.one('abs stat') entity.e(),
				iscommunity: count > 0
			iscommunity = count > 0
			
			return if averageposition.mag() is 0
			averageposition.div count
			direction = p5.Vector.sub averageposition, entity.e().coord.p
			force = inject.one('calculate steering') entity.e(), direction
			force.mult 1.0
			inject.one('apply force') entity.e(), force
	
	new AI()
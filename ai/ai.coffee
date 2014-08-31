define ['inject', 'hub', 'p2'], (inject, hub, p2) ->
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
				#inject.one('apply force') entity.e(), [0, 600]
		
		register: (entity, n) =>
			entity.ai =
				n: n
				e: -> entity
			@entities.push entity.ai
		
		separate: (entity) =>
			averagerepulsion = [0, 0]
			inject.one('each by distance') entity.e().phys.b.position, 25, (d, e) =>
				return if e is entity.e() or !e.ai?
				diff = [0, 0]
				p2.vec2.sub diff, entity.e().phys.b.position, e.phys.b.position
				p2.vec2.normalize diff, diff
				p2.vec2.add averagerepulsion, averagerepulsion, diff
			
			istouched = p2.vec2.len(averagerepulsion) isnt 0
			inject.one('abs stat') entity.e(), istouched: istouched
			return if !istouched
			
			p2.vec2.scale averagerepulsion, averagerepulsion, 800
			inject.one('apply force') entity.e(), averagerepulsion
			return
			
			force = inject.one('calculate steering') entity.e(), averagerepulsion
			p2.vec2.scale force, force, 800
			inject.one('apply force') entity.e(), force

		align: (entity) =>
			averagedirection = [0, 0]
			count = 0
			inject.one('each by distance') entity.e().phys.b.position, 50, (d, e) =>
				return if e is entity.e() or !e.ai?
				p2.vec2.add averagedirection, averagedirection, e.phys.b.velocity
				count++
			return if p2.vec2.len(averagedirection) is 0
			
			p2.vec2.normalize averagedirection, averagedirection
			p2.vec2.scale averagedirection, averagedirection, 100
			inject.one('apply force') entity.e(), averagedirection
			return
			
			force = inject.one('calculate steering') entity.e(), averagedirection
			p2.vec2.scale force, force, 800
			inject.one('apply force') entity.e(), force

		cohere: (entity) =>
			averageposition = [0, 0]
			count = 0
			inject.one('each by distance') entity.e().phys.b.position, 100, (d, e) =>
				return if e is entity.e() or !e.ai?
				p2.vec2.add averageposition, averageposition, e.phys.b.position
				count++
			
			inject.one('abs stat') entity.e(),
				iscommunity: count > 0
			iscommunity = count > 0
			
			return if p2.vec2.len(averageposition) is 0
			p2.vec2.scale averageposition, averageposition, 1 / count
			direction = [0, 0]
			p2.vec2.sub averageposition, averageposition, entity.e().phys.b.position
			
			p2.vec2.normalize averageposition, averageposition
			p2.vec2.scale averageposition, averageposition, 800
			inject.one('apply force') entity.e(), averageposition
			return
			
			force = inject.one('calculate steering') entity.e(), direction
			p2.vec2.scale force, force, 800
			inject.one('apply force') entity.e(), force
	
	new AI()
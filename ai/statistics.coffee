define ['inject'], (inject) ->
	class Statistics
		constructor: ->
			@entities = []
			
			inject.bind 'step', @step
			inject.bind 'register statistics', @register
			
		step: =>
			#for entity in @entities
			#	@separate entity
		
		register: (entity, n) =>
			entity.stats =
				n: n
				e: -> entity
			@entities.push entity.stats
	
	new Statistics
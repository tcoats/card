define ['inject'], (inject) ->
	class Statistics
		constructor: ->
			@entities = []
			
			inject.bind 'step', @step
			inject.bind 'register statistics', @register
			inject.bind 'absolute statistic', @absolutestatistic
			inject.bind 'relative statistic', @relativestatistic
			
		step: =>
			#for entity in @entities
			#	@separate entity
		
		register: (entity, n) =>
			entity.stats =
				n: n
				e: -> entity
			@entities.push entity.stats
		
		absolutestatistic: (entity, values) =>
			stats = entity.stats
			for key, value of values
				stats[key] = value
		
		relativestatistic: (entity, values) =>
			stats = entity.stats
			for key, value of values
				stats[key] = 0 if !stats[key]?
				stats[key] += value
	
	new Statistics
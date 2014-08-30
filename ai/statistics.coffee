define ['inject'], (inject) ->
	class Statistics
		constructor: ->
			@entities = []
			@derived = {}
			
			inject.bind 'step', @step
			inject.bind 'register statistics', @register
			inject.bind 'absolute statistic', @absolutestatistic
			inject.bind 'relative statistic', @relativestatistic
			inject.bind 'register derived statistic', @derivedstatstic
			
		step: =>
			#for entity in @entities
			#	@separate entity
		
		register: (entity) =>
			entity.stats =
				e: -> entity
			@entities.push entity.stats
		
		absolutestatistic: (entity, values) =>
			stats = entity.stats
			for key, value of values
				if @derived[key]?
					current = stats[key]
					for derived in @derived[key]
						derived entity, current, value
				stats[key] = value
		
		relativestatistic: (entity, values) =>
			stats = entity.stats
			for key, value of values
				stats[key] = 0 if !stats[key]?
				stats[key] += value
		
		derivedstatstic: (key, cb) =>
			if !@derived[key]?
				@derived[key] = []
			@derived[key].push cb
			off: =>
				index = @derived[key].indexOf(cb)
				if index isnt -1
					@derived[key].splice index, 1
	
	new Statistics
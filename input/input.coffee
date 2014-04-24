define ['infra/hub', 'readline'], (hub, readline) ->
	class Input
		constructor: ->
			@rl = readline.createInterface
				input: process.stdin
				output: process.stdout
			
			hub.every 'Randomly select starting player', ->
				hub.emit 'Player 2 will start'
			
			hub.every 'Player 1 select from options', @selectfromoptions
			hub.every 'Player 2 select from options', @selectfromoptions
				
			hub.every 'Game quit', =>
				@rl.close()
		
		selectfromoptions: (options) =>
			hub.emit 'error', 'No options present' if options.length is 0
			return options[0]() if options.length is 1
			
			index = 0
			selection = []
			for option, cb of options
				selection[index] = cb
				console.log "#{index + 1}) #{option}"
				index++
			
			@getselection options.length, (index) =>
				selection[index]()
		
		getselection: (max, cb) =>
			@rl.question '? ', (index) =>
				cb(index - 1)
				
	new Input()

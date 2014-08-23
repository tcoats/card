define ['odo/hub'], (hub) ->
	class Game
		constructor: ->
			hub.once 'Game start', (m, cb) ->
				hub.emit 'Player 1 choose deck'
				cb()
				
			hub.once 'Player 1 has chosen {deck} deck', (m, cb) ->
				hub.emit 'Player 2 choose deck'
				cb()
			
			hub.once [
				'Player 1 has chosen {deck} deck'
				'Player 2 has chosen {deck} deck'
			], (m, cb) ->
				hub.emit 'Randomly select starting player'
				cb()
			
			hub.once 'Player 2 will start', (m, cb) ->
				console.log 'Player 2 starting'
				cb()

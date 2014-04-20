define ['infra/hub'], (hub) ->
	class Game
		constructor: ->
			hub.saga [
				'Game start'
			],
			->
				hub.emit 'Player 1 choose deck'
				
			hub.saga [
				'Player 1 has chosen {deck} deck'
			],
			->
				hub.emit 'Player 2 choose deck'
			
			hub.saga [
				'Player 1 has chosen {deck} deck'
				'Player 2 has chosen {deck} deck'
			],
			->
				hub.emit 'Randomly select starting player'
			
	new Game()

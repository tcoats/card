define ['infra/hub'], (hub) ->
	class Game
		constructor: ->
			hub.once 'Game start',
				-> hub.emit 'Player 1 choose deck'
				
			hub.once 'Player 1 has chosen {deck} deck',
				-> hub.emit 'Player 2 choose deck'
			
			hub.once [
				'Player 1 has chosen {deck} deck'
				'Player 2 has chosen {deck} deck'
			],
			-> hub.emit 'Randomly select starting player'
			
			hub.once 'Player 2 will start',
				-> console.log 'Player 2 starting'
			
	new Game()

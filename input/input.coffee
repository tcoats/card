define ['infra/hub', 'infra/delay'], (hub, delay) ->
	class Input
		constructor: ->
			hub.on 'Player 1 choose deck', @player1ChooseDeck
			hub.on 'Player 2 choose deck', @player2ChooseDeck
			hub.on 'Randomly select starting player', @randomlySelectStartingPlayer
		
		player1ChooseDeck: =>
			delay 500, -> hub.emit 'Player 1 has chosen {deck} deck', deck: 'Aggro'
		
		player2ChooseDeck: =>
			delay 500, -> hub.emit 'Player 2 has chosen {deck} deck', deck: 'Control'
			
		randomlySelectStartingPlayer: =>
			delay 500, -> hub.emit 'Player 2 will start'

	new Input()

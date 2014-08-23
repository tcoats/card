define ['odo/hub', 'odo/delay'], (hub, delay) ->
	class Decks
		constructor: ->
			@decks = {}
			
			hub.every '{deck} deck has been created', (p, cb) =>
				@decks[p.deck] =
					deck: p.deck
				cb()
				
			hub.every '{deck} deck has new cards {cards}', (p, cb) =>
				@decks[p.deck].cards = p.cards
				cb()
				
			hub.every 'Player 1 choose deck', (m, cb) =>
				options = {}
				
				add = (deck) ->
					options[deck.deck] = ->
						hub.emit 'Player 1 has chosen {deck} deck', deck: deck.deck
					
				for name, deck of @decks
					add deck
				
				console.log 'Player 1 choose a deck'
				hub.emit 'Player 1 select from options', options
				cb()
				
			hub.every 'Player 2 choose deck', (m, cb) =>
				options = {}
				
				add = (deck) ->
					options[deck.deck] = ->
						hub.emit 'Player 2 has chosen {deck} deck', deck: deck.deck
					
				for name, deck of @decks
					add deck
				
				console.log 'Player 2 choose a deck'
				hub.emit 'Player 2 select from options', options
				cb()

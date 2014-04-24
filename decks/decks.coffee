define ['infra/hub', 'infra/delay'], (hub, delay) ->
	class Decks
		constructor: ->
			@decks = {}
			
			hub.every '{deck} deck has been created', (p) =>
				@decks[p.deck] =
					deck: p.deck
				
			hub.every '{deck} deck has new cards {cards}', (p) =>
				@decks[p.deck].cards = p.cards
				
			hub.every 'Player 1 choose deck', =>
				options = {}
				
				add = (deck) ->
					options[deck.deck] = ->
						hub.emit 'Player 1 has chosen {deck} deck', deck: deck.deck
					
				for name, deck of @decks
					add deck
				
				console.log 'Player 1 choose a deck'
				hub.emit 'Player 1 select from options', options
				
			hub.every 'Player 2 choose deck', =>
				options = {}
				
				add = (deck) ->
					options[deck.deck] = ->
						hub.emit 'Player 2 has chosen {deck} deck', deck: deck.deck
					
				for name, deck of @decks
					add deck
				
				console.log 'Player 2 choose a deck'
				hub.emit 'Player 2 select from options', options

	new Decks()

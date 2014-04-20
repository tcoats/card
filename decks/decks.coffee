define ['infra/hub', 'infra/cson'], (hub, cson) ->
	class Decks
		constructor: ->
			@decks = {}
			
			hub.on '{deck} deck has been created', (p) =>
				@decks[p.deck] = {}
				
			hub.on '{deck} deck has new cards {cards}', (p) =>
				@decks[p.deck].cards = p.cards

	new Decks()

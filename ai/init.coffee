# # AI Testbed

define 'plugins', [
	'ai'
	'physics'
	'coordinates'
	'display'
]

window.setup = ->
	createCanvas windowWidth, windowHeight
	requirejs.config urlArgs: 'v=' + (new Date()).getTime() # cache busting
	requirejs ['colors', 'inject', 'plugins'], (colors, inject) ->
		window.draw = ->
			exec() for exec in inject.many 'step'
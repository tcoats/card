# # AI Testbed

define 'plugins', [
	'ai'
]

window.setup = ->
	createCanvas 1920, 1200
	requirejs.config urlArgs: 'v=' + (new Date()).getTime() # cache busting
	requirejs ['colors', 'inject', 'plugins'], (colors, inject) ->
		window.draw = ->
			#background colors.bg
			exec() for exec in inject.many 'step'
# # AI Testbed

define 'plugins', [
	'statistics'
	'ai'
	'physics'
	'coordinates'
	'display'
]

define 'game', ['inject', 'plugins'], (inject) ->
	# Add an initial set of boids into the system
	for _ in [0..50]
		e = {}
		name = 'boid'
		inject.one('register ai') e, name
		inject.one('register statistics') e, name
		inject.one('register physics') e, p5.Vector.random2D()
		inject.one('register coordinates') e, createVector random(width), random(height)
		inject.one('register display') e, name

window.setup = ->
	createCanvas windowWidth, windowHeight
	requirejs.config urlArgs: 'v=' + (new Date()).getTime() # cache busting
	requirejs ['inject', 'game'], (inject) ->
		window.draw = ->
			exec() for exec in inject.many 'step'
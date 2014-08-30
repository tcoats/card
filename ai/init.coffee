# # AI Testbed

define 'game', ['boid', 'plugins'], (Boid) ->
	# Add an initial set of boids into the system
	for _ in [0..10]
		new Boid
			position: createVector random(width), random(height)
			velocity: p5.Vector.random2D()
			name: 'boid'

define 'plugins', [
	'ai'
	'physics'
	'coordinates'
	'display'
]

window.setup = ->
	createCanvas windowWidth, windowHeight
	requirejs.config urlArgs: 'v=' + (new Date()).getTime() # cache busting
	requirejs ['colors', 'inject', 'game'], (colors, inject) ->
		window.draw = ->
			exec() for exec in inject.many 'step'
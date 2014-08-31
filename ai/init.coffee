# # AI Testbed

define 'plugins', [
	'statistics'
	'ai'
	'physics'
	'display'
]

define 'game', ['inject', 'plugins'], (inject) ->
	# Add an initial set of boids into the system
	for _ in [0..5]
		e = {}
		name = 'boid'
		inject.one('register ai') e, name
		inject.one('register statistics') e
		inject.one('register physics') e, 'circle', createVector(random(width), random(height)), p5.Vector.random2D()
		inject.one('register display') e, name

window.setup = ->
	createCanvas windowWidth, windowHeight
	requirejs.config urlArgs: 'v=' + (new Date()).getTime() # cache busting
	requirejs ['inject', 'game'], (inject) ->
		setup() for setup in inject.many 'setup'
		window.draw = ->
			step() for step in inject.many 'step'
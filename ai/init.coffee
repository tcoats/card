# # AI Testbed

define 'plugins', [
	'statistics'
	'ai'
	'physics'
	'display'
]

define 'game', ['inject', 'plugins'], (inject) ->
	# Add an initial set of boids into the system
	for _ in [0..100]
		e = {}
		name = 'boid'
		inject.one('register ai') e, name
		inject.one('register statistics') e
		inject.one('register physics') e, name, [random(width), random(height)], p5.Vector.random2D().mult(60).array()
		inject.one('register display') e, name
	#for _ in [0..200]
	#	u = {}
	#	inject.one('register ai') u, 'unit'
	#	inject.one('register statistics') u
	#	inject.one('register physics') u, 'unit', [random(width), random(height)], [0, 0]
	#	inject.one('register display') u, 'unit'
	#return
	#u1 = {}
	#inject.one('register ai') u1, 'unit'
	#inject.one('register statistics') u1
	#inject.one('register physics') u1, 'unit', [100, 100], [0, 0]
	#inject.one('register display') u1, 'unit'
	#u2 = {}
	#inject.one('register ai') u2, 'unit'
	#inject.one('register statistics') u2
	#inject.one('register physics') u2, 'unit', [130, 100], [0, 0]
	#inject.one('register display') u2, 'unit'
	#u3 = {}
	#inject.one('register ai') u3, 'unit'
	#inject.one('register statistics') u3
	#inject.one('register physics') u3, 'unit', [140, 100], [0, 0]
	#inject.one('register display') u3, 'unit'
	#u4 = {}
	#inject.one('register ai') u4, 'unit'
	#inject.one('register statistics') u4
	#inject.one('register physics') u4, 'unit', [120, 120], [0, 0]
	#inject.one('register display') u4, 'unit'

window.setup = ->
	createCanvas windowWidth, windowHeight
	requirejs.config
		urlArgs: 'v=' + (new Date()).getTime() # cache busting
		paths: p2: 'p2.min'
	requirejs ['inject', 'game'], (inject) ->
		setup() for setup in inject.many 'setup'
		window.draw = ->
			step() for step in inject.many 'step'
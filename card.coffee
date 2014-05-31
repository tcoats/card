requirejs.config
	paths:
		jquery: 'bower_components/jquery/jquery.min'
		fontawesome: 'bower_components/font-awesome/css/font-awesome.min'
		uuid: 'bower_components/node-uuid/uuid'
		q: 'bower_components/q/q'
		humanize: 'bower_components/humanize/public/dist/humanize.min'
		moment: 'bower_components/momentjs/min/moment.min'
		interact: 'bower_components/interact/interact.min'
		screenfull: 'bower_components/screenfull/dist/screenfull.min'
		bootstrap: 'bower_components/bootstrap/dist/js/bootstrap.min'
		bootstrapcss: 'bower_components/bootstrap/dist/css/bootstrap'
		velocity: 'bower_components/velocity/jquery.velocity.min'
		hammer: 'bower_components/hammerjs/hammer.min'

	map:
		'*':
			css: 'bower_components/require-css/css.min'

	shim:
		bootstrap: deps: ['jquery']
		velocity: deps: ['jquery']
		humanize: exports: 'Humanize'
		interact: exports: 'interact'
		screenfull: exports: 'screenfull'
	
	# don't cache in development
	urlArgs: 'v=' + (new Date()).getTime()


	

define [
	'jquery'
	'interact'
	'screenfull'
	'hammer'
	'bootstrap'
	'velocity'
	'css!bootstrapcss'
	'css!fontawesome'
	'css!card'
], ($, interact, screenfull, Hammer) ->
	$.fn.velocity = ->
		# syntactic sugar for coffeescript
		_velocity = $.velocity || Zepto.velocity || window.velocity
		if arguments[0].properties?
			propertiesMap = arguments[0].properties
			options = arguments[0].options
			_velocity.animate.call(this, propertiesMap, options)
		else
			_velocity.animate.apply(this, arguments)

	class Card
		constructor: (container) ->
			@x = 0
			@y = 0
			
			@elcc = $('<div />').addClass('card-c')
			@elc = $('<div />').addClass('card').appendTo @elcc
			@elc.append $('<h3 />').text 'Ion Cannon'
			@elc.append $('<p />').text 'Ion Cannon is online, requesting firing coodinates'
			
			container.append @elcc
			
			interact(@elcc[0])
				.draggable(
					onstart: @_ondragstart
					onmove: @_ondragmove
					onend: @_ondragend
				)
				.inertia(yes)
			
			@elc.velocity
				properties:
					translateZ: -100
				options:
					duration: 0
						
		_ondragstart: (e) =>
			@elcc.css('z-index', 1)
			@elc
				.velocity('stop')
				.velocity
					properties:
						translateZ: 0
					options:
						duration: 100
		
		_ondragmove: (e) =>
			@x += e.dx
			@y += e.dy
			dx = e.dx * 1.5
			dx = Math.min dx, 45
			dx = Math.max dx, -45
			dy = e.dy * 1.5
			dy = Math.min dy, 45
			dy = Math.max dy, -45
			
			@elcc.velocity
					properties:
						translateX: @x
						translateY: @y
					options:
						duration: 0
			
			@elc
				.velocity('stop')
				.velocity
					properties:
						rotateY: dx
						rotateX: -dy
					options:
						duration: 0
		
		_ondragend:(e) =>
			@elc
				.velocity(
					properties:
						rotateY: 0
						rotateX: 0
					options:
						duration: 100)
				.velocity
					properties:
						translateZ: -100
					options:
						duration: 100
						complete: =>
							@elcc.css('z-index', 0)

	$board = $ '#board'
	new Card $board
	new Card $board
	new Card $board
	new Card $board
	
	## Bring this back one day
	#$('.fa-arrows').on 'click', ->
	#	return if !screenfull.enabled
	#	if screenfull.isFullscreen
	#		screenfull.exit() 
	#	else
	#		screenfull.request() 

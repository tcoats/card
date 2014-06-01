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
		
	# timer
	getTimestamp = if !window.performance?
			-> new Date().getTime()
		else if window.performance.now?
			-> window.performance.now()
		else if window.performance.webkitNow? 
			-> window.performance.webkitNow()
		else
			-> new Date().getTime()
	
	class Card
		constructor: (container) ->
			@x = 0
			@y = 0
			
			@elcc = $('<div />').addClass('card-c')
			@elc = $('<div />').addClass('card').appendTo @elcc
			$('<h3>Ion Cannon</h3>').appendTo @elc
			$('<p>Ion Cannon is online, requesting firing coodinates</p>').appendTo @elc
			$('<span class="action">6</span>').appendTo @elc
			$('<span class="attack">10</span>').appendTo @elc
			$('<span class="armour">1</span>').appendTo @elc
			
			container.append @elcc
			
			interact(@elc[0])
				.draggable(
					onstart: @_ondragstart
					onmove: @_ondragmove
					onend: @_ondragend
				)
			
			@elc.velocity
				properties:
					translateZ: 0
				options:
					duration: 0
		
		_ondragstart: (e) =>
			@elcc.css('z-index', 1)
			@elc
				.velocity('stop')
				.velocity
					properties:
						translateZ: 100
					options:
						duration: 100
			@elc
				.find('> *')
				.velocity
					properties:
						translateZ: 20
					options:
						duration: 100
						
			@lastTime = getTimestamp()
			@dy = 0
			@dx = 0
		
		_ondragmove: (e) =>
			current = getTimestamp()
			delta = current - @lastTime
			@lastTime = current
			
			@x += e.dx
			@y += e.dy
			@dx += e.dx * 2
			@dy += e.dy * 2
			
			decay = Math.exp -delta * 0.05
			@dx *= decay
			@dy *= decay
			# Max 45 degree turn
			@dx = Math.max @dx, -45
			@dx = Math.min @dx, 45
			@dy = Math.max @dy, -45
			@dy = Math.min @dy, 45
			
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
						rotateY: @dx
						rotateX: -@dy
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
						translateZ: 0
					options:
						duration: 100
						complete: =>
							@elcc.css('z-index', 0)
			@elc
				.find('> *')
				.velocity
					properties:
						translateZ: 0
					options:
						duration: 100
		
		hide: =>
			@elcc.hide()
		
		animate: (done) =>
			@elcc.show().velocity
				properties:
					translateY: [@y, 0]
					translateX: [@x, 'easeOutSine', 1000]
					rotateZ: [0, 'easeOutSine', 90]
					rotateY: [0, 'easeInSine', -90]
				options:
					complete: done

	$board = $ '#board'
	cards = [
		new Card $board
		new Card $board
		new Card $board
		new Card $board
	]
	
	delay = (func, time) ->
		setTimeout func, time
	
	$board.find('button').on 'click', ->
		wait = 0
		for card in cards
			card.hide()
			delay card.animate, wait
			wait += 200
				
	
	## Bring this back one day
	#$('.fa-arrows').on 'click', ->
	#	return if !screenfull.enabled
	#	if screenfull.isFullscreen
	#		screenfull.exit() 
	#	else
	#		screenfull.request() 

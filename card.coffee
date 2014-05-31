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
	'bootstrap'
	'velocity'
	'css!bootstrapcss'
	'css!fontawesome'
	'css!card'
], ($, interact, screenfull) ->
	$.fn.velocity = ->
		_velocity = $.velocity || Zepto.velocity || window.velocity
		if arguments[0].properties?
			propertiesMap = arguments[0].properties
			options = arguments[0].options
			_velocity.animate.call(this, propertiesMap, options)
		else
			_velocity.animate.apply(this, arguments)
	
	
	x = 0
	y = 0

	interact('.card-c')
		.draggable(
			onstart: (e) ->
				$(e.target)
					.find('.card')
					.velocity('stop')
					.velocity(
						properties:
							translateZ: 0
						options:
							duration: 200)
				
			onmove: (e) ->
				x += e.dx
				y += e.dy
				dx = e.dx * 1.5
				dx = Math.min dx, 45
				dx = Math.max dx, -45
				dy = e.dy * 1.5
				dy = Math.min dy, 45
				dy = Math.max dy, -45
				
				$(e.target)
					.velocity(
						properties:
							translateX: x
							translateY: y
						options:
							duration: 0
					)
				
				$(e.target)
					.find('.card')
					.velocity('stop')
					.velocity(
						properties:
							rotateY: "#{dx}deg"
							rotateX: "#{-dy}deg"
						options:
							duration: 0
					)
					
			onend: (e) ->
				$(e.target)
					.find('.card')
					.velocity(
						properties:
							rotateY: '0deg'
							rotateX: '0deg'
						options:
							duration: 200)
					.velocity(
						properties:
							translateZ: -100
						options:
							duration: 200)
					
				#e.target.querySelector('p').textContent =
				#	"moved a distance of #{Math.sqrt(e.dx * e.dx + e.dy * e.dy) | 0}px"
		)
		.restrict( drag: 'parent' )
		
	$('.card')
		.velocity('stop')
		.velocity(
			properties:
				translateZ: -100
			options:
				duration: 0)
	
	## Bring this back one day
	#$('.fa-arrows').on 'click', ->
	#	return if !screenfull.enabled
	#	if screenfull.isFullscreen
	#		screenfull.exit() 
	#	else
	#		screenfull.request() 

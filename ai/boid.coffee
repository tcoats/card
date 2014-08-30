# # Reynolds Boid
define ['inject'], (inject) ->
	class Boid
		constructor: (options) ->
			inject.one('register coordinates') @, options.position
			inject.one('register physics') @, options.velocity
			inject.one('register display') @, options.name
			inject.one('register ai') @, options.name
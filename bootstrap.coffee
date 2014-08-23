module.exports = (contexts) ->
	requirejs = require 'requirejs'
	requirejs.config
		nodeRequire: require
		paths:
			odo: "#{__dirname}/node_modules/odo"
			local: "#{__dirname}/"
	requirejs ['odo/bootstrap'], (b) -> b contexts

args = process.argv.slice 2
if args.length > 0
	module.exports args

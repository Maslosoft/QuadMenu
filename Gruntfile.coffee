coffees = [
	'js/_ns.coffee'
	'js/Options.coffee'
	'js/ItemBase.coffee'
	'js/Item.coffee'
	'js/Menu.coffee'
	'js/Quad.coffee'
	'js/QuadMenu.coffee'
	'js/Renderer.coffee'
	'js/Menu.coffee'
]

less = [
	'css/quad-menu.less'
]

module.exports = (grunt) ->

	# Project configuration.
	grunt.initConfig
		coffee:
			compile:
				options:
					sourceMap: true
					join: true
					expand: true
				files: [
					'dist/quad-menu.js': coffees
				]
		uglify:
			compile:
				files:
					'dist/quad-menu.min.js' : ['dist/quad-menu.js']
		watch:
			compile:
				files: coffees
				tasks: ['coffee:compile']
			less:
				files: less
				tasks: ['less:compile']
		less:
			compile:
				files:
					'dist/quad-menu.css' : less
				options:
					sourceMap: true

	# These plugins provide necessary tasks.
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-less'

	# Default task.
	grunt.registerTask 'default', ['coffee', 'less', 'uglify']

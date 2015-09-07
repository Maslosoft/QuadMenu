coffees = [
	'_ns'
	'Options'
	'ItemBase'
	'Item'
	'Menu'
	'Quad'
	'QuadMenu'
	'Renderer'
	'Menu'
]

less = [
	'css/quad-menu.less'
]

module.exports = (grunt) ->
	c = new Array
	for name in coffees
		c.push "js/#{name}.coffee"

	# Project configuration.
	grunt.initConfig
		coffee:
			compile:
				options:
					sourceMap: true
					join: true
					expand: true
				files: [
					'dist/quad-menu.js': c
				]
		uglify:
			compile:
				files:
					'dist/quad-menu.min.js' : ['dist/quad-menu.js']
		watch:
			compile:
				files: c
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
		cssmin:
			target:
				files:
					'dist/quad-menu.min.css' : ['dist/quad-menu.css']

	# These plugins provide necessary tasks.
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-less'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'

	# Default task.
	grunt.registerTask 'default', ['coffee', 'less', 'uglify', 'cssmin']

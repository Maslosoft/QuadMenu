class @Maslosoft.QuadMenu.Options
	
	region: 'document'
	
	event: 'mousedown'
	
	#
	# Whenever to allow default browse context menu
	# @var bool
	#
	browserContext = false
	
	quads: []
	
	#
	# Options constructor. Will merge provided params with defaults.
	# @param object options
	#
	constructor: (options = {}) ->
		for name, value of options
			@[name] = value
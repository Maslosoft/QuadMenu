class @Maslosoft.QuadMenu.Menu
	
	#
	# Options
	# @var Maslosoft.QuadMenu.Options
	#
	options: null
	
	#
	# Quads. This has structure of quad id and list of quads:
	# 
	# quads = [
	#	1: [
	#		new Maslosoft.QuadMenu.Quad,
	#		new Maslosoft.QuadMenu.Quad
	#	],
	#	2: [
	#		new Maslosoft.QuadMenu.Quad
	#	]
	# ]
	# @var Maslosoft.QuadMenu.Quad[][]
	#
	quads: [
		[],
		[],
		[],
		[],
	]
	
	
	
	#
	#
	# @var DomElement
	#
	menu: null
	
	#
	# Renderer instance
	# @var Maslosoft.QuadMenu.Render
	#
	renderer: null
	
	constructor: (options = {}) ->
		@options = new Maslosoft.QuadMenu.Options(options)
		for quad in @options.quads
			@add quad
		
		console.log @options.region
		if @options.region is 'document'
			jQuery(document).on @options.event, @onClick
			jQuery(document).on 'contextmenu', @onContext
		else
			jQuery(document).on @options.event, @options.region, @onClick
			jQuery(document).on 'contextmenu', @options.region, @onContext
			
		@renderer = new Maslosoft.QuadMenu.Renderer @
		
	
	onClick: (e) =>
		console.log e
		@open e.clientX, e.clientY
		
	onContext: (e) =>
		e.preventDefault()
	
	open: (x, y) =>
		@renderer.open x, y
		
	
	#
	# Add quad to menu
	# @param Maslosoft.QuadMenu.Quad
	#
	add: (quad) ->
		preferred = parseInt quad.getPreferred()
		
		if preferred < -1 or preferred > 3
			throw new Error('Preferred quad must be between -1 and 3')
		
		# Push into preferred space
		if preferred >= 0
			@quads[preferred].push quad
			
		# Iterate over size of existing quads
		for size in [0 ... 4] 
			# Push into first empty or low num quad
			for id, quads in @quads
				if quads.length is size
					@quads[id].push quad
					return
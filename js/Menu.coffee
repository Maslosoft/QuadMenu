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
	#	0: [
	#		new Maslosoft.QuadMenu.Quad,
	#		new Maslosoft.QuadMenu.Quad
	#	],
	#	1: [
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
	
	#
	# Quad menu entry class
	# @param Maslosoft.QuadMenu.Options options|object
	#
	constructor: (options = {}) ->
		
		# Merge options with defaults
		@options = new Maslosoft.QuadMenu.Options(options)
		
		# Assign renderer
		@renderer = new Maslosoft.QuadMenu.Renderer @
		
		console.log @options
		
		# Add quads
		for quad in @options.quads
			@add quad
		
		console.log @options.region
		
		if @options.region is 'document'
			# Attach directly to document if region is document
			jQuery(document).on @options.event, @onClick
			jQuery(document).on 'contextmenu', @preventContext
		else
			# Attach by delegate to selected region
			jQuery(document).on @options.event, @options.region, @onClick
			jQuery(document).on 'contextmenu', @options.region, @preventContext
		
		# Stop propagation when clicked on menu itself
		@renderer.container.on @options.event, @stop
		
		# Close on Esc
		jQuery(document).on 'keydown', (e) =>
			# ESC key code is 27
			if e.keyCode is 27
				@close()
			
		# Close if clicked elsewere
		
		
	
	onClick: (e) =>
		
		if e.which is 3
			# Show on right button click
			@open e.clientX, e.clientY
			if not @options.browserContext
				e.preventDefault()
		else
			# Close on other buttons 
			@close()
		
	preventContext: (e) =>
		e.preventDefault()
		if not @options.browserContext
			e.preventDefault()
			
	stop: (e) =>
		e.stopPropagation()
	
	open: (x, y) =>
		@renderer.open x, y
		
	close: () =>
		@renderer.close()
	
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
			for quads, id in @quads
				console.log quad
				if quads.length is size
					quads.push quad
					@renderer.add id, quad
					return
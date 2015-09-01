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
		
		# Stop propagation when has event (click or mousedown) 
		# on menu itself
		@renderer.container.on @options.event, @stop
		
		# Prevent click events default action on menu.
		# This is to operate on mousedown, known as RapidClick™.
		# No seriously, it looks like menu is very fast.
		@renderer.container.on 'click', @prevent
			
		
		# Close on Esc
		jQuery(document).on 'keydown', (e) =>
			# ESC key code is 27
			if e.keyCode is 27
				@close()
			
		# Close if clicked elsewere
		
		
	#
	# TODO Rename to regionClick
	onClick: (e) =>
		console.log e
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

	#
	# TODO Rename to menu click or item click			
	stop: (e) =>
		data = jQuery(e.target).data()
		quadItems = @quads[data.quadId]
		if quadItems
			# @var quad Maslosoft.QuadMenu.Quad
			quad = quadItems[data.menuId]
		if quad
			# @var quad Maslosoft.QuadMenu.Item
			item = quad.items[data.itemId]
		if item
			console.log item.onClick(e, item)
		
		e.stopPropagation()
		
	prevent: (e) ->
		e.preventDefault()
	
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
					menuId = quads.push quad
					@renderer.add id, menuId - 1, quad
					return
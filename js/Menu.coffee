class @Maslosoft.QuadMenu.Menu extends @Maslosoft.QuadMenu.ItemBase
	
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
	# @param options Maslosoft.QuadMenu.Options options|object
	#
	constructor: (options = {}) ->
		
		# Merge options with defaults
		@options = new Maslosoft.QuadMenu.Options(options)
		
		# Assign renderer
		@renderer = new Maslosoft.QuadMenu.Renderer @
		
		# Add quads
		for quad in @options.quads
			@add quad
		
		if @options.region is 'document'
			# Attach directly to document if region is document
			jQuery(document).on @options.event, @regionClick
			jQuery(document).on 'contextmenu', @preventContext
		else
			# Attach by delegate to selected region
			jQuery(document).on @options.event, @options.region, @regionClick
			jQuery(document).on 'contextmenu', @options.region, @preventContext
		
		# Attach click on item 
		@renderer.container.on @options.event, @itemClick
		
		# Prevent click events default action on menu.
		# This is to operate on mousedown, known as RapidClick™.
		# No seriously, it looks like menu is very fast.
		@renderer.container.on 'click', @prevent
			
		
		# Close on Esc
		jQuery(document).on 'keydown', (e) =>
			# ESC key code is 27
			if e.keyCode is 27
				@close()
		
	#
	# Click on active region
	# @param e Event
	#
	regionClick: (e) =>
		if e.which is 3
			# Show on right button click
			@open e.clientX, e.clientY
			if not @options.browserContext
				e.preventDefault()
		else
			# Close on other buttons 
			@close()
	#
	# Click on item
	# @param e Event
	#	
	itemClick: (e) =>
		data = jQuery(e.target).data()
		item = @getItem(data)
		if item
			item.onClick(e, item)
		
		e.stopPropagation()
		
	preventContext: (e) =>
		e.preventDefault()
		if not @options.browserContext
			e.preventDefault()

		
	prevent: (e) ->
		e.preventDefault()
	
	getItem: (data) ->
		item = null
		quadItems = @quads[data.quadId]
		if quadItems
			# @var quad Maslosoft.QuadMenu.Quad
			quad = quadItems[data.menuId]
		if quad
			# @var quad Maslosoft.QuadMenu.Item
			item = quad.items[data.itemId]
		return item
	
	getMenu: (data) ->
		
	
	getQuad: (data) ->
		return @quads[data.quadId]
	
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
				if quads.length is size
					menuId = quads.push quad
					@renderer.add id, menuId - 1, quad
					return
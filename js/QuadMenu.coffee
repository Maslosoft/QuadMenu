class @Maslosoft.QuadMenu.QuadMenu
	
	#
	# Options
	# @var Maslosoft.QuadMenu.Options
	#
	options: null
	
	#
	# Quads. This has structure of quad id and list of quads:
	# 
	# quads = [
	#		new Maslosoft.QuadMenu.Quad,
	#		new Maslosoft.QuadMenu.Quad
	# ]
	# @var Maslosoft.QuadMenu.Quad[][]
	#
	quads: []
	
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

		# For reference problems
		@quads = new Array

		# Merge options with defaults
		@options = new Maslosoft.QuadMenu.Options(options)
		
		# Assign renderer
		@renderer = new Maslosoft.QuadMenu.Renderer @
		
		# Init quads
		for id in [0 ... 4]
			@quads[id] = new Maslosoft.QuadMenu.Quad {id: id}

		# Add menus to quads
		for menu in @options.menus
			@add menu
		
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
		item = @getItem data
		console.log item
		if item
			item.onClick e, item
		
		e.stopPropagation()
		
	preventContext: (e) =>
		e.preventDefault()
		if not @options.browserContext
			e.preventDefault()

		
	prevent: (e) ->
		e.preventDefault()
	
	getItem: (data) ->
		menu = @getMenu data
		if menu
			# @var quad Maslosoft.QuadMenu.Item
			return menu.get data.itemId
		return null
	
	getMenu: (data) ->
		quad = @getQuad data
		# @var quad Maslosoft.QuadMenu.Quad
		if quad
			# @var menu Maslosoft.QuadMenu.Menu
			return quad.get data.menuId
		return null
	
	getQuad: (data) ->
		console.log @quads
		console.log data
		if @quads[data.quadId]
			return @quads[data.quadId]
		return null
	
	open: (x, y) =>
		@renderer.open x, y
		
	close: () =>
		@renderer.close()
	
	#
	# Add menu to quad
	# @param Maslosoft.QuadMenu.Menu
	#
	add: (menu, preferred = -1) ->

		# Get preferred from from menu if not set by function call
		if preferred >= 0
			preferred = parseInt menu.getPreferred()

		# Sanitize prefered quad id
		if preferred < -1 or preferred > 3
			throw new Error('Preferred quad must be between `-1` and `3`')
		
		# Push into preferred quad
		if preferred >= 0
			@quads[preferred].items.push menu
			
		# Iterate over size of existing quads
		for size in [0 ... 4]

			# Push into first empty quad or with lowest number of menus
			for quad, id in @quads
				q = quad
				if q.length is size
					menuId = q.add(menu)
					@renderer.add id, menuId, menu
					return

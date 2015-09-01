if not @Maslosoft
	@Maslosoft = {}
if not @Maslosoft.QuadMenu
	@Maslosoft.QuadMenu = {}

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
class @Maslosoft.QuadMenu.Item

	#
	# Title of menu item 
	# @var string
	#
	title: ''
	
	href: ''
	
	#
	# Menu instance. This help closing menu if nessesary.
	# @var Maslosoft.QuadMenu.Menu
	#
	menu: ''
	
	constructor: (options = {}) ->
		for name, value of options
			@[name] = value
	
	setMenu: (@menu) ->
	
	onClick: () ->
		return @click
	
	#
	# Get menu item title 
	# @return string item title
	#
	getTitle: () ->
		return @title
	
	#
	# Set title
	# @param string title
	#
	setTitle: (@title) ->

	getHref: () ->
		return '#'
class @Maslosoft.QuadMenu.Quad

	#
	# Title of quad. If not set, it will 
	# @var string
	#
	title: ''

	#
	# Quad items
	# @var Maslosoft.QuadMenu.Item[]
	#
	items: []

	constructor: (options = {}) ->
		for name, value of options
			@[name] = value
	
	#
	# Set title
	# @param string title
	#
	setTitle: (@title) ->
		
	#
	# Get quad title. This will appear on top of menu.
	# @return string quad title
	#
	getTitle: () ->
		return @title
		
	#
	# Get quad menu items. This should return type 
	# of Maslosoft.QuadMenu.Item or compatible.
	# @return Maslosoft.QuadMenu.Item[]
	#
	getItems: () ->
		
	
	#
	# Get preferred quad starting conterclockwise from bottom right.
	# Return -1 for auto which is default.
	# @return int preferred quad
	#
	getPreferred: () ->
		return -1
	#
	# Whenever quad should be visible.
	# Return true to include quad in quad menu
	# @return bool
	#
	isVisible: () ->
		return true
	
	#
	# Show quad only in selected region.
	# Return null or empty string to show in each region.
	# @return string selector
	#
	inRegion: () ->
		return null
#
# Renderer of Quad menu. This generates
# HTML markup containing for quads
#
#
#
#
class @Maslosoft.QuadMenu.Renderer
	
	#
	# Menu instance
	# @var Maslosoft.QuadMenu.Menu
	#
	menu: null
	
	#
	# Quad menu container
	# @var jQuery
	#
	container: null
	
	#
	# Quads html elements
	# @var jQuery
	#
	quads: []
	
	#
	# Class constructor
	# @param Maslosoft.QuadMenu.Menu
	#
	constructor: (@menu) ->
		
		
		@container = jQuery '<div class="maslosoft-quad-menu"></div>'
		
		for id in [0 ... 4]
			quad = jQuery "<ul class='quad-#{id}' />"
			@quads.push quad
			@container.append quad
		
		jQuery('body').append @container
		
	#
	# show quad menu at specified location
	# @var int X coordinate
	# @var int Y coordinate
	#
	open: (x, y) =>
		@container.css 'left', x
		@container.css 'top', y
		@container.show()
		
	#
	# Close context menu
	#
	#
	close: () =>
		@container.hide()
	
	#
	# Add quad html markup
	# @param int Id
	# @param Maslosoft.QuadMenu.Quad 
	#
	add: (id, menuId, quad) =>
		if quad.getTitle()
			@quads[id].append "<li class='quad-title'>#{quad.getTitle()}</li>"
		for itemId, item of quad.items
			item.setMenu @menu
			
			itemElement = """
			<li>
				<a href="#{item.getHref()}" 
					data-item-id="#{itemId}"
					data-menu-id="#{menuId}"
					data-quad-id="#{id}"	
					>
					#{item.getTitle()}
				</a>
			</li>
			"""
			if id in [1, 2]
				# Top quads - need prepend
				@quads[id].prepend itemElement
			else
				# Bottom quads - need append
				@quads[id].append itemElement
		
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
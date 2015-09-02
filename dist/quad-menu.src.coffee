if not @Maslosoft
	@Maslosoft = {}
if not @Maslosoft.QuadMenu
	@Maslosoft.QuadMenu = {}

class @Maslosoft.QuadMenu.Options
	
	#
	# Region on which menu will be active.
	# Default to document, which allow clicking anywhere, 
	# including after html close tag.
	#
	# @var string
	#
	region: 'document'
	
	#
	# Whenever to show spot
	#
	# @var bool
	#
	showSpot: true
	
	#
	# Event on which menu will react. Default to mousedown.
	# This applies for both menu opening and items clicking.
	#
	# @var string
	#
	event: 'mousedown'
	
	#
	# Whenever to allow default browse context menu
	#
	# @var bool
	#
	browserContext = false
	
	#
	# Menus which will be added to quads
	#
	# @var Maslosoft.QuadMenu.Menu[]
	#
	menus: []
	
	#
	# Options constructor. Will merge provided params with defaults
	
	# @param object options
	#
	constructor: (options = {}) ->
		for name, value of options
			@[name] = value
#
# Shared items, menus and quads properties 
#
#
class @Maslosoft.QuadMenu.ItemBase

	id: 0

	length: 0

	visible: true

	#
	# Quad items
	# @var Maslosoft.QuadMenu.Item[]
	#
	items: []

	constructor: (options = {}) ->

		# This is to avid reference problems
		@items = new Array

		# Init from options
		for name, value of options
			@[name] = value

	add: (item) ->
		@length++;
		@items.push item
		return @length - 1

	get: (itemId) ->
		if @items[itemId]
			return @items[itemId]
		return null

	#
	# Get quad menu items. This should return type 
	# of Maslosoft.QuadMenu.Item or compatible.
	# @return Maslosoft.QuadMenu.Item[]
	#
	getItems: () ->
		return @items
	
	#
	# Whenever quad should be visible.
	# Return true to include quad in quad menu
	# @return bool
	#
	isVisible: (visible = null) ->
		if visible isnt null
			@visible = visible
		return @visible;
	
	#
	# Show quad only in selected region.
	# Return null or empty string to show in each region.
	# @return string selector
	#
	inRegion: () ->
		return null

class @Maslosoft.QuadMenu.Item extends @Maslosoft.QuadMenu.ItemBase

	#
	# Title of menu item 
	# @var string
	#
	title: ''
	
	href: ''
	
	#
	# Menu instance. This help closing menu if nessesary.
	# @var Maslosoft.QuadMenu.QuadMenu
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
#
# Menu class
#
#
class @Maslosoft.QuadMenu.Menu  extends @Maslosoft.QuadMenu.ItemBase

	#
	# Title of menu. If not set, it will
	# @var string
	#
	title: ''

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
	# Get preferred quad starting conterclockwise from bottom right.
	# Return -1 for auto which is default.
	# @return int preferred quad
	#
	getPreferred: () ->
		return -1

#
# Quad class
#
#
class Maslosoft.QuadMenu.Quad extends @Maslosoft.QuadMenu.ItemBase



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
	# @var Maslosoft.QuadMenu.QuadMenu
	#
	menu: null
	
	#
	# Quad menu container
	# @var jQuery
	#
	container: null
	
	#
	# Quad HTML elements
	# @var jQuery
	#
	quads: []

	#
	# Menus HTML elements
	# @var jQuery
	#
	menus: []

	#
	# Items HTML elements
	# @var jQuery
	#
	items: []
	
	#
	# Class constructor
	# @param Maslosoft.QuadMenu.QuadMenu
	#
	constructor: (@menu) ->

		@quads = new Array
		@menus = new Array
		@items = new Array

		# Create menu container
		@container = jQuery """<div class="maslosoft-quad-menu"></div>"""
		
		# Show spot if enabled
		if @menu.options.showSpot
			@container.append """<div class="quad-spot" /> """
		
		# Create empty quads
		for quadId in [0 ... 4]
			quad = jQuery "<div class='quad-#{quadId}' />"
			@quads.push quad
			@container.append quad
		
		# Attach it to body
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
		
		# Show or hide quads
		for quad, quadId in @menu.quads
			quadElement = @container.find ".quad-#{quadId}"
			# show = quad.isVisible()
			show = true
			isVisible = quadElement.is ":visible"
			if show and not isVisible
				quadElement.show()
			if not show and isVisible
				quadElement.hide()
				
				
		# Show or hide items
		@container.find('a').each (index, element) =>
			element = jQuery element
			item = @menu.getItem element.data()
			console.log element.data()
			isVisible = element.is ":visible"
			show = item.isVisible()
			if show and not isVisible
				element.show()
			if not show and isVisible
				element.hide()
		
	#
	# Close context menu
	#
	#
	close: () =>
		@container.hide()
	
	getItem: (quadId, menuId, itemId) ->
		return @items[quadId][menuId][itemId]

	getMenu: (menuId, quadId) ->
		return @menus[quadId][menuId]

	getQuad: (quadId) ->
		return @quads[quadId]

	#
	# Add menu html markup
	# @param int quadId
	# @param int menuId
	# @param Maslosoft.QuadMenu.Menu 
	#
	add: (quadId, menuId, menu) =>

		@menus[quadId] = []
		@items[quadId] = []
		@items[quadId][menuId] = []

		menuElement = jQuery """<ul data-menu-id="#{menuId}" /> """
		@menus[quadId][menuId] = menuElement
		if menu.getTitle()
			menuElement.append """
			<li class="menu-title"
				data-menu-id="#{menuId}"
				data-quad-id="#{quadId}"
				>
				#{menu.getTitle()}
			</li>"""
		for itemId, item of menu.items
			item.setMenu @menu
			
			itemElement = """
			<li>
				<a href="#{item.getHref()}"
					data-item-id="#{itemId}"
					data-menu-id="#{menuId}"
					data-quad-id="#{quadId}"
					>
					#{item.getTitle()}
				</a>
			</li>
			"""
			menuElement.append itemElement
			@items[quadId][menuId][itemId] = menuElement
			if quadId in [1, 2]
				# Top quads - need prepend
				@quads[quadId].prepend menuElement
			else
				# Bottom quads - need append
				@quads[quadId].append menuElement
		

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
	#
	# @var Maslosoft.QuadMenu.QuadMenu
	#
	menu: null
	
	#
	# Quad menu container
	#
	# @var jQuery
	#
	container: null
	
	#
	# Quad HTML elements
	#
	# @var jQuery
	#
	quads: []

	#
	# Menus HTML elements
	#
	# @var jQuery
	#
	menus: []

	#
	# Items HTML elements
	#
	# @var jQuery
	#
	items: []
	
	#
	# Class constructor
	#
	# @param Maslosoft.QuadMenu.QuadMenu menu
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
			@quads[quadId] = quad
			@menus[quadId] = new Array
			@items[quadId] = new Array
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
		
		# Show or hide quads, menus, items
		for quad, quadId in @menu.quads

			quadElement = @getQuad quadId
			visibleMenus = 0

			for menu, menuId in quad.items

				menuElement = @getMenu quadId, menuId
				visibleItems = 0

				for item, itemId in menu.items
					itemElement = @getItem quadId, menuId, itemId
					visibleItems += @setVisibilityOf item, itemElement
				
				if visibleItems is 0
					menuElement.hide()
				else
					visibleMenus += @setVisibilityOf menu, menuElement

			if visibleMenus is 0
				quadElement.hide()
			
			@setVisibilityOf quad, quadElement
	#
	# Set visibility of element
	#
	# @return int 1 if visible
	#
	setVisibilityOf: (item, element, parent = null, perentElement = null) ->
		show = item.isVisible()
		isVisible = element.is ":visible"
		if show
			element.show()
			return 1
		if not show
			element.hide()
			return 0

	#
	# Close context menu
	#
	#
	close: () =>
		@container.hide()
	
	getItem: (quadId, menuId, itemId) ->
		if quadId > 3 or quadId < 0
			throw new Error("Bad quad id must be in `0 ... 3` however `#{quadId}` given")

		return @items[quadId][menuId][itemId]

	getMenu: (quadId, menuId) ->
		if quadId > 3 or quadId < 0
			throw new Error("Bad quad id must be in `0 ... 3` however `#{quadId}` given")
		
		return @menus[quadId][menuId]

	getQuad: (quadId) ->
		if quadId > 3 or quadId < 0
			throw new Error("Bad quad id must be in `0 ... 3` however `#{quadId}` given")

		return @quads[quadId]

	#
	# Add menu html markup
	# @param Maslosoft.QuadMenu.Quad quad
	# @param Maslosoft.QuadMenu.Menu menu
	#
	add: (quad, menu) =>
		quadId = quad.id
		menuId = menu.id
		
		if not @items[quadId][menuId]
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
			
			itemElement = jQuery """
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
			@items[quadId][menuId][itemId] = itemElement
			if quadId in [1, 2]
				# Top quads - need prepend
				@quads[quadId].prepend menuElement
			else
				# Bottom quads - need append
				@quads[quadId].append menuElement
		

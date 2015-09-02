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
		

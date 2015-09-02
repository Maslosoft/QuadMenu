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
		
		# Create menu container
		@container = jQuery """<div class="maslosoft-quad-menu"></div>"""
		
		# Show spot if enabled
		if @menu.options.showSpot
			@container.append """<div class="quad-spot" /> """
		
		# Create empty quads
		for id in [0 ... 4]
			quad = jQuery "<div class='quad-#{id}' />"
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
		for quad, id in @menu.quads
			quadElement = @container.find ".quad-#{id}"
			# show = quad.isVisible()
			show = true
			isVisible = quadElement.is ":visible"
			if show and not isVisible
				quadElement.show()
			if not show and isVisible
				quadElement.hide()
				
				
		# Show or hide items
		@container.find('a').each (index, element) =>
			element = jQuery(element)
			item = @menu.getItem element.data()
			isVisible = element.is ":visible"
			show = item.isVisible()
			if show and not isVisible
				element.show()
			if not show and isVisible
				element.hide()
			
			console.log item
		
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
			@quads[id].append """
			<li class="quad-title"
				data-menu-id="#{menuId}"
				data-quad-id="#{id}"
				>
				#{quad.getTitle()}
			</li>"""
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
		
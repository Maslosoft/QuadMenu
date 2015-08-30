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
	
	constructor: (options = {}) ->
		for name, value of options
			@[name] = value
class @Maslosoft.QuadMenu.Item
	
	#
	# Get menu item title 
	# @return string item title
	#
	getTitle: () ->
		
class @Maslosoft.QuadMenu.Quad

	#
	# Get quad title. This will appear on top of menu.
	# @return string quad title
	#
	getTitle: () ->
		
		
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
		return -1;
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
class @Maslosoft.QuadMenu.Renderer
	
	#
	# Menu instance
	# @var @Maslosoft.QuadMenu.Menu
	#
	@menu: null
	
	@container: null
	
	constructor: (@menu) ->
		
		
		@container = jQuery('<div class="maslosoft-quad-menu"></div>');
		
		for id in [0 ... 4]
			@container.append "<div class='quad-#{id}' />"
		
		jQuery('body').append @container
		
	open: (x, y) =>
		@container.css 'left', x
		@container.css 'top', y
		@container.show()
	
	add: (id, quad) =>
		
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
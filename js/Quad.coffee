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
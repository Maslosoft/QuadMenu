#
# Shared items, menus and quads properties 
#
#
class @Maslosoft.QuadMenu.ItemBase

	id: 0

	parent: null

	length: 0

	visible: true

	#
	# Quad items
	# @var Maslosoft.QuadMenu.Item[]
	#
	items: []

	constructor: (options = {}) ->

		# This is to avid reference problems
		@reset()

		# Init from options
		for name, value of options
			@[name] = value

	add: (item) ->
		@length++;
		@items.push item
		id = @length - 1
		item.id = id
		item.parent = @
		return id

	reset: () ->
		@parent = null
		@length = 0
		@items = new Array

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

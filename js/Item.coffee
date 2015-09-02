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
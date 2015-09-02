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

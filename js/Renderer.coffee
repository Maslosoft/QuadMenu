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
		
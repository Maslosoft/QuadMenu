<?php
require '_header.php'
?>
<label>
	<input type="checkbox" id="close" />
	Close menu when I click item
</label>
<script>
	jQuery(document).ready(function(){
		var click = function(e, item){
			jQuery('#log').append("Clicked " + item.getTitle() + "<br />");
			if(jQuery('#close').is(":checked")) {
				item.menu.close();
			}
		};
		var quads = [];
		var quad = new Maslosoft.QuadMenu.Quad({
			title: 'First quad ever',
			items: [
				new Maslosoft.QuadMenu.Item({title: 'First item', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'First item 2', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'First item 3', onClick: click})
			]
		});
		
		quads.push(quad);
		var options = {
			browserContext: true,
			quads: quads
		}
		var menu = new Maslosoft.QuadMenu.Menu(options);
		
		
		quad = new Maslosoft.QuadMenu.Quad({
			items: [
				new Maslosoft.QuadMenu.Item({title: 'Second item', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Second item 2', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Second item 3', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Second item 4 (this one has longer title)', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Second item 5', onClick: click})
				
			]
		});
		quad.setTitle('Second quad ever');
		menu.add(quad);
		
		quad = new Maslosoft.QuadMenu.Quad({
			items: [
				new Maslosoft.QuadMenu.Item({title: 'Third item', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Third item 2', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Third item 3', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Third item 4 (longer title)', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Third item 5', onClick: click})
				
			]
		});
		quad.setTitle('Third quad ever');
		menu.add(quad);
		
		quad = new Maslosoft.QuadMenu.Quad({
			items: [
				new Maslosoft.QuadMenu.Item({title: 'Forth item', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Forth item 2', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Forth item 3', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Forth item 4', onClick: click})
				
			]
		});
		quad.setTitle('Forth quad ever');
		menu.add(quad);
		
		quad = new Maslosoft.QuadMenu.Quad({
			items: [
				new Maslosoft.QuadMenu.Item({title: 'Fifth item', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Fifth item 2', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Fifth item 3', onClick: click})
			]
		});
		quad.setTitle('Fifth quad ever');
		menu.add(quad);
		
		
	});
</script>
<div id="log">
	
</div>
<?php
	require '_footer.php'
?>
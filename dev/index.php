<?php
require '_header.php'
?>
<h1>
	Quad Menu Demo
</h1>
<p>
	<b>Right click somewhere</b>
</p>
<label>
	<input type="checkbox" id="close" />
	Close menu when I click item
</label>
<div id="quadsHide">
	<?php foreach ([0, 1, 2, 3] as $id): ?>
		<label data-quad-id="<?= $id; ?>">
			<input type="checkbox" />
			Hide quad <?= $id; ?>
		</label>
	<?php endforeach; ?>
</div>
<div id="itemsHide">
	<?php foreach ([0, 1, 2] as $id): ?>
		<label data-item-id="<?= $id; ?>"
				 data-menu-id="0"
				 data-quad-id="0">
			<input type="checkbox" />
			Hide item 0, 0, <?= $id; ?>
		</label>
	<?php endforeach; ?>
</div>
<script>
	jQuery(document).ready(function () {
		var click = function (e, item) {
			jQuery('#log').append("Clicked " + item.getTitle() + "<br />");
			if (jQuery('#close').is(":checked")) {
				item.menu.close();
			}
		};
		var menus = [];
		var menu = new Maslosoft.QuadMenu.Menu({
			title: 'First quad',
			items: [
				new Maslosoft.QuadMenu.Item({title: 'First item', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'First item 2', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'First item 3', onClick: click})
			]
		});

		menus.push(menu);
		var options = {
			browserContext: true,
			menus: menus
		};
		var quadMenu = new Maslosoft.QuadMenu.QuadMenu(options);


		menu = new Maslosoft.QuadMenu.Menu({
			items: [
				new Maslosoft.QuadMenu.Item({title: 'Second item', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Second item 2', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Second item 3', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Second item 4 (this one has longer title)', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Second item 5', onClick: click})

			]
		});
		menu.setTitle('Second menu');
		quadMenu.add(menu);

		menu = new Maslosoft.QuadMenu.Menu({
			items: [
				new Maslosoft.QuadMenu.Item({title: 'Third item', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Third item 2', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Third item 3', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Third item 4 (longer title)', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Third item 5', onClick: click})

			]
		});
		menu.setTitle('Third menu');
		quadMenu.add(menu);

		menu = new Maslosoft.QuadMenu.Menu({
			items: [
				new Maslosoft.QuadMenu.Item({title: 'Forth item', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Forth item 2', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Forth item 3', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Forth item 4', onClick: click})

			]
		});
		menu.setTitle('Forth menu');
		quadMenu.add(menu);

		menu = new Maslosoft.QuadMenu.Menu({
			items: [
				new Maslosoft.QuadMenu.Item({title: 'Fifth item', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Fifth item 2', onClick: click}),
				new Maslosoft.QuadMenu.Item({title: 'Fifth item 3', onClick: click})
			]
		});
		menu.setTitle('Fifth menu');
		quadMenu.add(menu);

		// Additional stuff
		// Show/hide items
		jQuery('#itemsHide').on('click', 'label', function (e) {
			e.stopPropagation();
			var el = jQuery(e.target);
			var box = el.find('checkbox');
			var data = el.data();
			if (data.itemId !== null) {
				var item = quadMenu.getItem(data);
				if (item) {
					item.isVisible(box.is(':checked'));
				}
			}
		});
		// Show hide quads
		jQuery('#quadsHide').on('click', 'label', function (e) {
			e.stopPropagation();
			var el = jQuery(e.target);
			var box = el.find('checkbox');
			var data = el.data();
			if (data.quadId !== null) {
				var quad = quadMenu.getQuad(data);
				if (quad) {
					quad.isVisible(box.is(':checked'));
				}
			}
		});
	});
</script>
<div id="log">

</div>
<?php
require '_footer.php'
?>

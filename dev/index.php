<?php
require '_header.php'
?>
<script>
	jQuery(document).ready(function(){
		var menu = new Maslosoft.QuadMenu.Menu({browserContext: true});
		var quad = new Maslosoft.QuadMenu.Quad();
		quad.setTitle('First quad ever');
		console.log(menu.renderer);
		menu.add(quad);
	});
</script>
<?php
	require '_footer.php'
?>
<?php
require '_header.php'
?>
<script>
	jQuery(document).ready(function(){
		var menu = new Maslosoft.QuadMenu.Menu();
		var quad = new Maslosoft.QuadMenu.Quad();
		menu.add(quad);
	});
</script>
<?php
	require '_footer.php'
?>
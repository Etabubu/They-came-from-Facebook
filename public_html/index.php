<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.w3.org/1999/xhtml
                          http://www.w3.org/MarkUp/SCHEMA/xhtml11.xsd"
>

<head>
	<title>Gogogic - They Came From FacoBeOK!</title>
	
	<style type="text/css">
		* { margin:0; padding:0; }
	</style>
	
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
	<script type="text/javascript" src="http://connect.facebook.net/en_US/all.js"></script>
	<script type="text/javascript" src="FBJSBridge.js"></script>
	
	<script type="text/javascript">
		function embedPlayer() {
			var flashvars = {};
			embedSWF("Application.swf", "flashContent", "760", "850", "10.0");
		}
		//Redirect for authorization for application loaded in an iFrame on Facebook.com 
		/*function redirect(id,perms,uri) {
			var params = window.location.toString().slice(window.location.toString().indexOf('?'));
			top.location = 'https://graph.facebook.com/oauth/authorize?client_id='+id+'&scope='+perms+'&redirect_uri='+uri+params;				 
		}*/
		embedPlayer();
	</script>
</head>

<body>
	<div id="fb-root"></div>
	<div id="flashContent">
		<h1>You need at least Flash Player 10.0 to view this page.</h1>
		<p><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a></p>
	</div>
</body>

</html>
<?php
require_once 'facebook.php';

// This needs to be set to work on windows, possibly not on linux
Facebook::$CURL_OPTS[CURLOPT_SSL_VERIFYPEER] = false;
Facebook::$CURL_OPTS[CURLOPT_SSL_VERIFYHOST] = 2;

$appapikey = 'f85f8f9afe40043328d4c37935a4fefc';
$appsecret = '8efe04f6b6843f249929d55631117641';

$appname = 'They Came From FacoBeOK';
$appcallbackurl = 'http://apps.gogogic.com/tcff/';
$appcanvasurl = 'http://apps.facebook.com/gogogic_tcff/';

$facebook = new Facebook(array(
  'appId'  => $appapikey,
  'secret' => $appsecret,
  'cookie' => true
));

$session = $facebook->getSession();
$me = null;

// Session based API call.
if ($session) {
  try {
    $me = $facebook->api('/me');
  } catch (FacebookApiException $e) {
    error_log($e);
  }
}

if (!$me) { // We need to authorize
    $loginUrl = $facebook->getLoginUrl(array('req_perms' => 'publish_stream,user_about_me,user_relationships,user_relationship_details', 'next' => $appcanvasurl));
    echo("<html><body><script language=javascript>"); 
    echo("top.location.href='$loginUrl';"); 
    echo("</script></body></html>");
    exit();
}

$uid = $facebook->getUser();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
	<title>They Came From FacoBeOK!</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	
	<style type="text/css">
		* { margin:0; padding:0; }
	</style>
	
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
	<script type="text/javascript" src="http://connect.facebook.net/en_US/all.js"></script>
	<!---<script type="text/javascript" src="FBJSBridge.js"></script>--->
	<script type="text/javascript">
		function embedPlayer() {
			var AccessToken = "<?php echo($session['access_token']); ?>";
			var flashvars = { "fb_sig_session": "<? echo($session['session_key']); ?>", "fb_sig_user": "<? echo($uid); ?>", "assetUrl": "http://apps.gogogic.com/tcff/" };
			var params = {
				menu: "false",
				scale: "noScale",
				bgcolor: "#FFFFFF",
				wmode: "opaque",
				allowScriptAccess: "always"
			};
			swfobject.embedSWF("http://apps.gogogic.com/tcff/Application.swf", "flashContent", "760", "850", "10.0.0", flashvars, params);
			FB.Canvas.setSize();
		}
		//Redirect for authorization for application loaded in an iFrame on Facebook.com 
		function redirect(id,perms,uri) {
			var params = window.location.toString().slice(window.location.toString().indexOf('?'));
			top.location = 'https://graph.facebook.com/oauth/authorize?client_id='+id+'&scope='+perms+'&redirect_uri='+uri+params;				 
		}
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
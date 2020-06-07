<?php

require_once (__DIR__ . "/vendor/autoload.php");

require_once("app.php");


$anon_ok = 1;

pstart ();

$body .= "<div>\n";
$body .= mklink ("home", "/");
$body .= "</div>\n";

$body .= "<p>hello</p>\n";


function put_google_login_button() {
    global $extra_head;
    global $google_client_id;
    
    $extra_head .= sprintf ("<meta name='google-signin-client_id'"
        ." content='%s' />\n", urlencode($google_client_id));
    $extra_head .= "<script src='https://apis.google.com/js/platform.js'"
                ." async defer></script>";

    global $body;
    $body .= "<button id='login'>google login</button>";
    $body .= '<div class="g-signin2" data-onsuccess="onSignIn"></div>';
}

if (($login_email = getsess ("login_email")) == "") {
    put_google_login_button ();
    pfinish ();
}

$body .= "<div>\n";
$body .= sprintf ("logged in as %s ", h($login_email));
$body .= "</div>\n";


pfinish ();

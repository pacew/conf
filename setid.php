<?php

require_once (__DIR__ . "/vendor/autoload.php");

require_once("app.php");


$anon_ok = 1;

pstart ();

// https://developers.google.com/identity/sign-in/web

$arg_id = @$_REQUEST['id'];

$client = new Google_Client(['client_id' => $google_client_id]);

$payload = $client->verifyIdToken($arg_id);

if ($payload['aud'] != $google_client_id) {
    $body .= "invalid audience in authentication ticket";
    pfinish ();
}

/* real unique id for a careful app */
$google_acct_id = $payload['sub'];

if (($google_email = @$payload['email']) == "") {
    $body .= "no email address received";
    pfinish ();
}

putsess ("login_email", $google_email);

redirect ("/");

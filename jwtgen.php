<?php

require_once (__DIR__ . "/vendor/autoload.php");

use \Firebase\JWT\JWT;


require_once("app.php");


$anon_ok = 1;

pstart ();

$body .= "<div>\n";
$body .= mklink ("home", "/");
$body .= "</div>\n";

$body .= "<p>hello</p>\n";



$key = "example_key";
$payload = array(
    "iss" => "http://example.org",
    "aud" => "http://example.com",
    "iat" => 1356999524,
    "nbf" => 1357000000
);

$jwt = JWT::encode($payload, $key);
var_dump ($jwt);
$decoded = JWT::decode($jwt, $key, array('HS256'));

var_dump ($decoded);


pfinish ();

<?php
error_reporting( -1 );
ini_set( 'display_errors', 'On' );

require_once( empty( $_SERVER['PHP_AUTH_USER'] ) ? 'non_auth.php' : 'auth.php' );
?>
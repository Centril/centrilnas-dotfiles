<?php
if ( empty( $_SERVER['PHP_AUTH_USER'] ) ) {
	die( "ACCESS DENIED!" );
}

echo "Hello, " . $_SERVER['PHP_AUTH_USER'];
?>
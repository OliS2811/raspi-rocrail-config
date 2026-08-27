<?php
// get_rocweb_port.php
header('Content-Type: text/plain');

$filename = "/var/www/html/tmp/.rocweb_port";

if (file_exists($filename)) {
    echo trim(file_get_contents($filename));
}

<?php
header('Content-Type: application/json; charset=utf-8');

$wartungFile = '/var/www/html/wartung.php';

echo json_encode([
  'installed' => file_exists($wartungFile),
  'path' => $wartungFile
]);
?>

<?php
header('Content-Type: application/json');

// Robuste Prüfung: existiert "smbd"?
$path = trim(shell_exec('command -v smbd'));
$installed = !empty($path) && file_exists($path);

echo json_encode(['samba_installed' => $installed]);
?>

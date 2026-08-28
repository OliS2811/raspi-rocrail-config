<?php
// status_summary.php
header('Content-Type: application/json');

$rocrailRunning = trim(shell_exec("pgrep -x rocrail 2>/dev/null")) !== '';

$free = disk_free_space('/');
$freeGb = $free !== false ? round($free / 1073741824, 1) : null;

echo json_encode([
    "rocrail_running" => $rocrailRunning,
    "disk_free_gb" => $freeGb,
]);

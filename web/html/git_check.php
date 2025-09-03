<?php
header("Content-Type: application/json");

// Sicherstellen, dass der richtige Pfad geprüft wird
$repoDir = "/home/pi/Documents/Rocrail/.git";

$gitInstalled = file_exists("/usr/bin/git");
$repoExists = is_dir($repoDir);

// Debug-Infos mitgeben
echo json_encode([
    "installed" => $gitInstalled && $repoExists,
    "git_found" => $gitInstalled,
    "repo_exists" => $repoExists,
    "checked_path" => $repoDir,
    "whoami" => trim(shell_exec("whoami"))
]);
?>

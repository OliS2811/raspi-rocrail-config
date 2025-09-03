<?php
// Git & Changelog Webinterface für Rocrail
// Datei: /var/www/html/git_changelog.php

$repoDir = "/home/pi/Documents/Rocrail";
$installScript = "$repoDir/install_git_changelog.sh";
$updateScript  = "$repoDir/update_changelog.sh";

?>
<!DOCTYPE html>
<html lang="de">
<head>
  <meta charset="UTF-8">
  <title>Git & Changelog – Rocrail</title>
  <style>
    body { font-family: sans-serif; margin: 20px; }
    h2 { margin-top: 30px; }
    input, button { padding: 5px; margin: 5px; }
    pre { background: #f0f0f0; padding: 10px; border-radius: 5px; }
  </style>
</head>
<body>

<h1>⚙️ Git & Changelog Verwaltung</h1>

<!-- Einrichtung -->
<h2>Einrichtung</h2>
<form method="post">
  <input type="text" name="git_user" placeholder="Git Benutzername" required>
  <input type="email" name="git_email" placeholder="Git E-Mail" required>
  <input type="text" name="git_remote" placeholder="Git Remote URL (SSH)" required>
  <button type="submit" name="action" value="setup">Git & Changelog einrichten</button>
</form>

<!-- Commit -->
<h2>Commit speichern</h2>
<form method="post">
  <input type="text" name="commit_msg" placeholder="Änderungsbeschreibung" required size="60">
  <button type="submit" name="action" value="commit">Änderung speichern</button>
</form>

<!-- Push -->
<h2>Push zu Remote</h2>
<form method="post">
  <button type="submit" name="action" value="push">Änderungen pushen</button>
</form>

<!-- Changelog -->
<h2>Changelog anzeigen</h2>
<form method="post">
  <button type="submit" name="action" value="showlog">Changelog anzeigen</button>
</form>

<hr>

<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'];

    if ($action === 'setup') {
        $user   = escapeshellarg($_POST['git_user']);
        $email  = escapeshellarg($_POST['git_email']);
        $remote = escapeshellarg($_POST['git_remote']);
        echo "<h3>🔧 Einrichtung läuft …</h3><pre>";
        system("$installScript $user $email $remote 2>&1");
        echo "</pre>";
    }

    if ($action === 'commit') {
        $msg = escapeshellarg($_POST['commit_msg']);
        echo "<h3>💾 Commit wird gespeichert …</h3><pre>";
        system("$updateScript $msg 2>&1");
        echo "</pre>";
    }

    if ($action === 'push') {
        echo "<h3>🚀 Push zu Remote …</h3><pre>";
        system("cd $repoDir && git push origin main 2>&1");
        echo "</pre>";
    }

    if ($action === 'showlog') {
        echo "<h3>📜 Aktueller Changelog</h3><pre>";
        if (file_exists("$repoDir/CHANGELOG.md")) {
            readfile("$repoDir/CHANGELOG.md");
        } else {
            echo "Noch kein CHANGELOG vorhanden.";
        }
        echo "</pre>";
    }
}
?>

</body>
</html>

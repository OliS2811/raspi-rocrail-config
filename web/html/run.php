<?php
$allowed = range(0, 16);
$repoDir = "/home/pi/Documents/Rocrail";   // Ordner, in dem plan.xml liegt

header("Content-Type: text/plain");

// ------------------------------------------------------------
// 🧩 Automatisches Sudo-Setup für Rocrail Webinterface
// ------------------------------------------------------------
$SUDO_FILE = "/etc/sudoers.d/rocrail-web";

if (!file_exists($SUDO_FILE)) {
    echo "🔧 Erstelle fehlende Sudo-Regeln für Rocrail Webinterface...\n";

    $sudoRules = <<<EOT
# Rocrail Webinterface – automatische Sudoer-Regeln
www-data ALL=(pi) NOPASSWD: \
/usr/bin/git, \
/usr/bin/curl, \
/usr/bin/wget, \
/usr/bin/chmod, \
/usr/bin/chown, \
/usr/bin/mkdir, \
/usr/bin/rm, \
/usr/bin/mv, \
/usr/bin/cp, \
/usr/local/bin/*_addon.sh, \
/usr/local/share/rocrail-addons/*_addon.sh, \
/var/www/html/addons/*_addon.sh, \
/var/www/html/*_addon.sh
Defaults:www-data !requiretty
EOT;

    // Regel als temporäre Datei ablegen
    file_put_contents("/tmp/rocrail-web", $sudoRules);

    // und mit sudo ins System kopieren
    shell_exec("sudo cp /tmp/rocrail-web /etc/sudoers.d/rocrail-web && sudo chmod 440 /etc/sudoers.d/rocrail-web");

    echo "✅ Sudo-Regeln eingerichtet.\n";
}

// === Addon Installation ===
if (isset($_POST['addon_id']) && isset($_POST['script_url'])) {
    $addon = escapeshellarg($_POST['addon_id']);
    $url   = escapeshellarg($_POST['script_url']);
    $tmp   = "/tmp/${addon}.sh";

    echo "📥 Lade Addon-Skript von $url...\n";
    passthru("wget -qO $tmp $url && chmod +x $tmp && sudo -u pi bash $tmp 2>&1", $ret);

    if ($ret === 0) {
        echo "\n✅ Addon $addon erfolgreich installiert.";
    } else {
        echo "\n❌ Fehler bei Installation von $addon.";
    }
    exit;
}

// === Git & Changelog Aktionen ===
if (isset($_POST['git_action'])) {
    $action = $_POST['git_action'];

    if ($action === "setup") {
        $user   = escapeshellarg($_POST['git_user']);
        $email  = escapeshellarg($_POST['git_email']);
        $remote = escapeshellarg($_POST['git_remote']);
        passthru("sudo -u pi /usr/local/bin/install_git_changelog.sh $user $email $remote 2>&1");
        exit;
    }

    if ($action === "commit") {
        $msg = escapeshellarg($_POST['commit_msg']);
        passthru("sudo -u pi /usr/local/bin/update_git_plan.sh $msg 2>&1");
        exit;
    }

    if ($action === "push") {
        passthru("sudo -u pi git -C $repoDir push origin main 2>&1");
        exit;
    }

    if ($action === "showlog") {
        header("Content-Type: text/plain; charset=UTF-8");
        // Ausgabe: Hash | Datum | Autor | Nachricht
        $log = shell_exec("cd $repoDir && sudo -u pi git --no-pager log --pretty=format:'%h | %ad | %an | %s' --date=short -n 20 2>&1");
        echo $log;
        exit;
    }

    http_response_code(400);
    echo "Ungültige Git-Aktion.";
    exit;
}

// === Klassische Menü-Punkte 0–16 ===
if (isset($_POST['punkt'])) {
    $punkt = intval($_POST['punkt']);

    if ($punkt === 15) {
        echo "✅ [INFO] Setze Samba-Passwort für Benutzer 'pi'...\n";
        $cmd = "sudo /usr/local/bin/set_samba_pass.sh";
        exec($cmd, $output, $ret);
        echo implode("\n", $output) . "\n";
        exit;
    }

    if (in_array($punkt, $allowed)) {
        $script = escapeshellcmd("/var/www/html/punkt{$punkt}.sh");
        passthru("sudo -u pi $script");
        exit;
    }

    http_response_code(400);
    echo "Ungültiger Menüpunkt.";
    exit;
}

// === Fallback ===
http_response_code(400);
echo "Keine Aktion übergeben.";
?>
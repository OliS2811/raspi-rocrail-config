#!/bin/bash
set -e

REPO_DIR="/home/pi/Documents/Rocrail"
WWW_DIR="/var/www/html"

echo "=== Git-Support Addon installieren ==="

# Git installieren
sudo apt-get update
sudo apt-get install -y git

# SSH-Key erzeugen falls nicht vorhanden
if [ ! -f /home/pi/.ssh/id_ed25519 ]; then
    echo "-> Erzeuge SSH-Key für pi..."
    sudo -u pi ssh-keygen -t ed25519 -C "rocrail@local" -f /home/pi/.ssh/id_ed25519 -N ""
    echo "⚠️ Wichtig: Public Key bei GitHub eintragen!"
    sudo -u pi cat /home/pi/.ssh/id_ed25519.pub
fi

# Repo vorbereiten
cd "$REPO_DIR"
if [ ! -d .git ]; then
    echo "-> Initialisiere Git-Repo (nur lokal)..."
    sudo -u pi git init
    # Platzhalter-Config (wird später im Webinterface überschrieben)
    sudo -u pi git config user.name "RocrailUser"
    sudo -u pi git config user.email "rocrail@example.com"

    # .gitignore anlegen
    echo "*" > .gitignore
    echo "!plan.xml" >> .gitignore

    # Ersten Commit mit plan.xml
    sudo -u pi git add plan.xml || true
    sudo -u pi git commit -m "Initial commit von plan.xml" || true
fi

# Helper-Skripte installieren
sudo tee /usr/local/bin/install_git_changelog.sh >/dev/null <<'EOF'
#!/bin/bash
REPO_DIR="/home/pi/Documents/Rocrail"
USER=$1
EMAIL=$2
REMOTE=$3
cd "$REPO_DIR"
[ ! -d ".git" ] && git init
git config user.name "$USER"
git config user.email "$EMAIL"
git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE"
git add plan.xml
git commit -m "Initial commit von plan.xml" || true
EOF

sudo tee /usr/local/bin/update_git_plan.sh >/dev/null <<'EOF'
#!/bin/bash
REPO_DIR="/home/pi/Documents/Rocrail"
MSG=$1
cd "$REPO_DIR"
git add plan.xml
git commit -m "$MSG" || true
EOF

sudo chmod +x /usr/local/bin/install_git_changelog.sh
sudo chmod +x /usr/local/bin/update_git_plan.sh

# PHP-Dateien fürs Webinterface
sudo tee $WWW_DIR/git_check.php >/dev/null <<'EOF'
<?php
header("Content-Type: application/json");

$gitInstalled = trim(shell_exec("which git")) !== "";
$repoDir = "/home/pi/Documents/Rocrail/.git";
$repoExists = is_dir($repoDir);

echo json_encode([
    "git_found" => $gitInstalled,
    "repo_exists" => $repoExists,
    "checked_path" => $repoDir,
    "whoami" => trim(shell_exec("whoami"))
]);
?>
EOF

sudo tee $WWW_DIR/git_changelog.php >/dev/null <<'EOF'
<?php
header("Content-Type: text/plain");
$repoDir = "/home/pi/Documents/Rocrail";
passthru("sudo -u pi git -C $repoDir --no-pager log --oneline -n 20 2>&1");
?>
EOF

sudo tee $WWW_DIR/git_info.html >/dev/null <<'EOF'
<!DOCTYPE html>
<html lang="de">
<head>
  <meta charset="UTF-8">
  <title>Git & Changelog – Info</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="p-4 bg-light">
  <div class="container">
    <h2>🚂 Git & Changelog für Rocrail</h2>
    <p>Mit diesem Addon kannst du deine <code>plan.xml</code> versionieren und Änderungen nach GitHub hochladen.</p>

    <h4>🔑 Einrichtung</h4>
    <ol>
      <li>SSH-Key erzeugt – zu finden unter <code>/home/pi/.ssh/id_ed25519.pub</code></li>
      <li>Public Key bei GitHub eintragen:
        <ul>
          <li>GitHub → Settings → SSH and GPG Keys → New SSH key</li>
        </ul>
      </li>
      <li>Im Webinterface Git-Setup ausfüllen (Name, Mail, Repo-URL).</li>
      <li>Verbindung testen:
        <pre>ssh -T git@github.com</pre>
      </li>
    </ol>

    <h4>⚙️ Nutzung</h4>
    <ul>
      <li><b>Commit</b> – speichert Änderungen an <code>plan.xml</code></li>
      <li><b>Push</b> – schiebt Änderungen nach GitHub</li>
      <li><b>Changelog</b> – zeigt letzte Änderungen an</li>
    </ul>

    <p class="text-muted">ℹ️ Nur <code>plan.xml</code> wird versioniert. Andere Dateien werden ignoriert.</p>
  </div>
</body>
</html>
EOF

# Sudoers-Eintrag
echo "www-data ALL=(pi) NOPASSWD: /usr/bin/git, /usr/local/bin/install_git_changelog.sh, /usr/local/bin/update_git_plan.sh, /usr/local/bin/*_addon.sh" \
  | sudo tee /etc/sudoers.d/rocrail-git

echo "✅ Git-Support Addon komplett installiert"
echo "ℹ️ Bitte im Webinterface Git-Setup ausführen, um User, Mail und Remote einzurichten."

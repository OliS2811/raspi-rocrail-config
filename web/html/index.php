<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Rocrail Web-Konfiguration</title>
</head>
<body>
    <h1>Rocrail Webinterface (PHP)</h1>
    <form method="post">
        <?php
        for ($i = 0; $i <= 16; $i++) {
            echo "<button name='action' value='punkt{$i}'>${i}) Menüpunkt ${i}</button><br>";
        }
        ?>
    </form>
    <pre>
<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $allowed = range(0, 16);
    $action = str_replace("punkt", "", $_POST['action']);
    if (in_array((int)$action, $allowed)) {
        $script = escapeshellcmd("/var/www/html/punkt${action}.sh");
        echo shell_exec("sudo -u pi $script");
    } else {
        echo "Ungültiger Menüpunkt.";
    }
}
?>
    </pre>
</body>
</html>

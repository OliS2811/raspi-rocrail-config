async function checkSambaInstalled() {
  try {
    const res = await fetch('/check_samba_installed.php');
    const data = await res.json();
    if (data.installed) {
      document.getElementById('samba-password-section').style.display = 'block';
    }
  } catch (err) {
    console.error('Fehler beim Prüfen von Samba:', err);
  }
}

window.addEventListener('DOMContentLoaded', () => {
  checkSambaInstalled();
});

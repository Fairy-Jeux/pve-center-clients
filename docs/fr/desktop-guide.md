[English](../en/desktop-guide.md) | [Français](desktop-guide.md)

# Guide Desktop — Windows & Linux (Tauri v2)

PVE Command Center Desktop empaquette le tableau de bord React 19 dans une enveloppe native légère **Tauri v2** (`io.github.pvepanel.desktop`), ciblant **Windows 10/11** (`.exe` NSIS & `.msi`) et **Linux** (`.AppImage` & `.deb`).

---

## Fonctionnalités Desktop

- **Fenêtre native & Zone de notification (System Tray)** : ouvre une fenêtre `1280x820` (`960x640` minimum) avec icône dans le tray système (*Show PVE Center*, *Hide to Tray*, *Quit*). Un clic gauche sur l’icône affiche ou masque la fenêtre.
- **Client HTTP Rust sans blocage CORS** : `src/lib/apiClient.ts` détecte Tauri (`isTauriPlatform()`) et achemine les requêtes vers votre serveur distant via `@tauri-apps/plugin-http` (`tauri-plugin-http`), évitant tout blocage CORS de WebView2 / WebKitGTK vers une IP LAN ou Tailscale Serve.
- **Flux temps réel** : connexion WebSocket (`/api/ws/events`) avec repli automatique en Server-Sent Events (`/api/events/stream`) vers l’URL du serveur configuré.

---

## Connexion à votre serveur PVE Panel

1. Lancez **PVE Center**. Au premier démarrage, la modale **Connexion Serveur & Mode Démo** s’ouvre automatiquement.
2. Choisissez votre mode d’accès :
   - **Connexion serveur** :
     - **Tailscale Serve** : `https://<nom>.ts.net` (jeton Bearer optionnel si Tailscale SSO est actif, ou authentification par PIN Admin / jeton `pve_...`).
     - **Réseau local LAN** : `http://<ip-serveur>:8000` (si le serveur renvoie `401`, l’URL est mémorisée et la fenêtre de connexion par PIN Admin / Bearer s’ouvre automatiquement).
   - **Mode Démo interactif** : cliquez sur **Activer le Mode Démo** pour explorer l’ensemble de l’interface avec des données simulées.

La configuration serveur est persistée dans `localStorage` (`pve_panel_server_url`, `pve_panel_auth_token`, `pve_panel_demo_mode`).

---

## Compilation depuis les sources

### 1. Linux (Ubuntu / Debian)

Installez les bibliothèques système requises par Tauri v2 (WebKit2GTK 4.1 + Ayatana AppIndicator) :

```bash
sudo apt-get update
sudo apt-get install -y \
  libwebkit2gtk-4.1-dev \
  libayatana-appindicator3-dev \
  librsvg2-dev \
  libxdo-dev \
  libssl-dev \
  build-essential \
  patchelf \
  xdg-utils
```

Installez Rust (`rustup`) et Node.js 22+, puis exécutez :

```bash
npm install
./scripts/build-desktop.sh
```

Les paquets générés se trouvent dans `src-tauri/target/release/bundle/` :
- `appimage/*.AppImage`
- `deb/*.deb`

Pour lancer une fenêtre de développement avec rechargement à chaud :

```bash
npm run tauri:dev
```

### 2. Windows 10 / 11

Prérequis :
- **Node.js 22+**
- **Rust & Cargo** (chaîne MSVC via `rustup`)
- **Visual Studio Build Tools** (Développement Desktop C++)
- **Microsoft Edge WebView2 Runtime** (préinstallé sur Windows 11 ; bootstrapper intégré dans l’installeur)

Exécutez dans PowerShell :

```powershell
npm install
.\scripts\build-windows.ps1
```

Les installeurs générés se trouvent dans `src-tauri\target\release\bundle\` :
- `nsis\*-setup.exe`
- `msi\*.msi`

---

## Dépannage

- **Erreur AppImage dans un conteneur sans FUSE** : exportez `APPIMAGE_EXTRACT_AND_RUN=1` avant de lancer `./scripts/build-desktop.sh`.
- **Vérification Rust après modification de `src-tauri/`** : lancez `cargo check` dans `src-tauri/`.
- **Serveur LAN injoignable** : vérifiez l’accessibilité du port `8000` et saisissez explicitement `http://` pour les serveurs HTTP locaux.

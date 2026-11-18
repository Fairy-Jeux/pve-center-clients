[English](desktop-guide.md) | [Français](../fr/desktop-guide.md)

# Desktop Guide — Windows & Linux (Tauri v2)

PVE Command Center Desktop packages the React 19 dashboard inside a lightweight **Tauri v2** native shell (`io.github.pvepanel.desktop`), targeting **Windows 10/11** (`.exe` NSIS & `.msi`) and **Linux** (`.AppImage` & `.deb`).

---

## Key Desktop Capabilities

- **Native Window & System Tray**: Opens a `1280x820` desktop window (minimum `960x640`) with a native system tray icon (`Show PVE Center`, `Hide to Tray`, `Quit`). Left-clicking the tray icon toggles window visibility.
- **CORS-Free Rust HTTP Client**: `src/lib/apiClient.ts` detects Tauri (`isTauriPlatform()`) and routes API calls to your configured remote server through `@tauri-apps/plugin-http` (`tauri-plugin-http`), avoiding browser CORS restrictions when targeting LAN IPs or Tailscale Serve domains.
- **Real-Time Events**: Connects over WebSocket (`/api/ws/events`) with automatic fallback to SSE (`/api/events/stream`) using the active server URL and Bearer token.

---

## Connecting to Your PVE Panel Server

1. Launch **PVE Center**. On first run, the **Server Configuration** modal opens automatically.
2. Choose one of two modes:
   - **Connect to a server**:
     - **Tailscale Serve**: `https://<hostname>.ts.net` (Bearer token optional if Tailscale SSO applies; otherwise authenticate with Admin PIN or Bearer token `pve_...`).
     - **Local LAN**: `http://<server-ip>:8000` (if the server responds `401`, the client saves the server URL and opens the Admin PIN / Bearer Token login modal).
   - **Interactive Demo Mode**: Click **Activer le Mode Démo** to explore all screens with simulated homelab data.

Server preferences are persisted in WebView `localStorage` (`pve_panel_server_url`, `pve_panel_auth_token`, `pve_panel_demo_mode`).

---

## Building from Source

### 1. Linux (Ubuntu / Debian)

Install system dependencies for Tauri v2 (WebKit2GTK 4.1 + Ayatana AppIndicator):

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

Install Rust (`rustup`) and Node.js 22+, then run:

```bash
npm install
./scripts/build-desktop.sh
```

Output bundles are generated under `src-tauri/target/release/bundle/`:
- `appimage/*.AppImage`
- `deb/*.deb`

You can run a live development window at any time with:

```bash
npm run tauri:dev
```

### 2. Windows 10 / 11

Ensure you have:
- **Node.js 22+**
- **Rust & Cargo** (`rustup` MSVC toolchain)
- **Visual Studio Build Tools** (Desktop development with C++)
- **WebView2 Runtime** (preinstalled on Windows 11; the NSIS/MSI configuration embeds the Microsoft bootstrapper automatically)

Run in PowerShell:

```powershell
npm install
.\scripts\build-windows.ps1
```

Output installers are created under `src-tauri\target\release\bundle\`:
- `nsis\*-setup.exe`
- `msi\*.msi`

---

## Troubleshooting

- **AppImage build fails in container without FUSE**: Set `APPIMAGE_EXTRACT_AND_RUN=1` before running `./scripts/build-desktop.sh`.
- **Rust compile errors after editing `src-tauri/`**: Run `cargo check` inside `src-tauri/` to inspect compiler diagnostics.
- **Cannot reach LAN server**: Verify port `8000` is reachable from your desktop machine and include the `http://` scheme explicitly for non-HTTPS LAN addresses.

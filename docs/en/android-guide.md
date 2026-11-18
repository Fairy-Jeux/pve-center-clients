[English](android-guide.md) | [Français](../fr/android-guide.md)

# Android Guide (Capacitor 8)

The Android client wraps the responsive Liquid Glass React 19 UI inside **Capacitor 8** (`io.github.pvepanel.app`), supporting Android 7.0+ (`minSdk 24`, `compileSdk/targetSdk 36`).

---

## Android Configuration Highlights

- **Network Permissions** (`android/app/src/main/AndroidManifest.xml`): Declares `android.permission.INTERNET` and `android.permission.ACCESS_NETWORK_STATE`.
- **LAN HTTP & Tailscale HTTPS Support**:
  - `android:usesCleartextTraffic="true"` is enabled in `AndroidManifest.xml`.
  - `capacitor.config.ts` enables `CapacitorHttp`, `server.androidScheme: 'http'`, `server.cleartext: true`, and `android.allowMixedContent: true` so both HTTP LAN (`http://192.168.x.x:8000`) and HTTPS Tailscale Serve (`https://...ts.net`) connections, WebSockets, and SSE streams work cleanly.
- **Theme & Splash Assets**: Launcher icons and splash screens are pre-generated from `public/icon-512.png` with `#030712` background matching the dark obsidian Liquid Glass UI.

---

## Prerequisites

- **Node.js 22+** and **npm**
- **JDK 21** (Temurin 21 recommended — Capacitor 8 Gradle targets Java 21)
- **Android SDK** (`ANDROID_HOME` configured, Android Studio or `sdkmanager`)

---

## Building & Running

### Sync Web Assets & Open in Android Studio

```bash
npm install
npm run cap:sync
npx cap open android
```

### Build APK via CLI

```bash
# Debug APK (no keystore required)
./scripts/build-android.sh --debug

# Or via npm script
npm run android:build
```

Generated APKs are placed at:
- `android/app/build/outputs/apk/debug/app-debug.apk`

For signed release builds (`--release` or `--aab`), configure signing properties in Android Studio or `android/app/build.gradle` (never commit `.keystore` or `.jks` files to Git).

---

## Connecting from Android

1. Install **Tailscale** on your Android device (recommended for remote access) or connect to your local homelab Wi-Fi.
2. Launch **PVE Center**.
3. Enter your server URL:
   - Tailscale Serve: `https://<hostname>.ts.net`
   - LAN IP: `http://<lan-ip>:8000`
4. Authenticate with an **API Bearer token** (`pve_...`) or your **Admin PIN**, or tap **Activer le Mode Démo** to explore offline.

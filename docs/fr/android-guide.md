[English](../en/android-guide.md) | [Français](android-guide.md)

# Guide Android (Capacitor 8)

Le client Android empaquette l’interface responsive Liquid Glass React 19 dans **Capacitor 8** (`io.github.pvepanel.app`), compatible Android 7.0+ (`minSdk 24`, `compileSdk/targetSdk 36`).

---

## Spécificités de la configuration Android

- **Permissions réseau** (`android/app/src/main/AndroidManifest.xml`) : déclare `android.permission.INTERNET` et `android.permission.ACCESS_NETWORK_STATE`.
- **Support HTTP LAN & Tailscale HTTPS** :
  - `android:usesCleartextTraffic="true"` est activé dans `AndroidManifest.xml`.
  - `capacitor.config.ts` active `CapacitorHttp`, `server.androidScheme: 'http'`, `server.cleartext: true` et `android.allowMixedContent: true` afin que les adresses HTTP locales (`http://192.168.x.x:8000`), Tailscale HTTPS (`https://...ts.net`), les WebSockets et SSE fonctionnent sans erreur de contenu mixte.
- **Thème & Écrans de démarrage** : les icônes adaptatives et splash screens sont générés depuis `public/icon-512.png` sur fond `#030712` assorti au thème sombre Liquid Glass.

---

## Prérequis

- **Node.js 22+** et **npm**
- **JDK 21** (Eclipse Temurin 21 recommandé — Gradle Capacitor 8 cible Java 21)
- **Android SDK** (`ANDROID_HOME` configuré via Android Studio ou `sdkmanager`)

---

## Compilation & Exécution

### Synchroniser et ouvrir dans Android Studio

```bash
npm install
npm run cap:sync
npx cap open android
```

### Compiler un APK en ligne de commande

```bash
# APK Debug (sans keystore requis)
./scripts/build-android.sh --debug

# Ou via script npm
npm run android:build
```

L’APK généré est disponible sous :
- `android/app/build/outputs/apk/debug/app-debug.apk`

Pour les builds Release signés (`--release` ou `--aab`), configurez votre keystore dans Android Studio ou `android/app/build.gradle` (ne commitez jamais de fichier `.keystore` ou `.jks`).

---

## Connexion depuis Android

1. Installez **Tailscale** sur votre téléphone/tablette Android (recommandé pour l’accès distant) ou connectez-vous au Wi-Fi de votre réseau local.
2. Ouvrez **PVE Center**.
3. Saisissez l’URL de votre serveur :
   - Tailscale Serve : `https://<nom>.ts.net`
   - IP LAN : `http://<ip-locale>:8000`
4. Authentifiez-vous avec votre **jeton API Bearer** (`pve_...`) ou votre **code PIN Admin**, ou touchez **Activer le Mode Démo** pour explorer hors ligne.

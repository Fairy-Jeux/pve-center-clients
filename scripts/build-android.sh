#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

usage() {
  cat <<'EOF'
Usage: ./scripts/build-android.sh [--release | --aab | --debug] [--no-install]

Builds the PVE Center Android package via Vite + Capacitor 8 + Gradle.

Options:
  --debug       Build debug APK via ./gradlew assembleDebug (default)
  --release     Build release APK via ./gradlew assembleRelease
  --aab         Build release App Bundle via ./gradlew bundleRelease
  --no-install  Skip npm ci even if node_modules is missing
  -h, --help    Show this help message
EOF
}

GRADLE_TASK="assembleDebug"
AUTO_INSTALL=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --debug)
      GRADLE_TASK="assembleDebug"
      shift
      ;;
    --release)
      GRADLE_TASK="assembleRelease"
      shift
      ;;
    --aab)
      GRADLE_TASK="bundleRelease"
      shift
      ;;
    --no-install)
      AUTO_INSTALL=0
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

for cmd in node npm java; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: '$cmd' is required to build the Android client." >&2
    exit 1
  fi
done

if [[ ! -d node_modules && "$AUTO_INSTALL" -eq 1 ]]; then
  echo "[1/4] Installing npm dependencies..."
  npm ci
fi

echo "[2/4] Building web assets..."
npm run build

echo "[3/4] Syncing Capacitor Android project..."
npx cap sync android

echo "[4/4] Running Gradle task '$GRADLE_TASK'..."
cd android
chmod +x ./gradlew
./gradlew "$GRADLE_TASK"

echo "Done. Outputs are under android/app/build/outputs/"

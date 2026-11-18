#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

usage() {
  cat <<'EOF'
Usage: ./scripts/build-desktop.sh [--bundles <list>] [--no-install]

Builds the PVE Center Linux desktop bundles (.AppImage and .deb by default) via Tauri v2.

Options:
  --bundles <list>  Comma-separated Tauri bundle targets (default: appimage,deb)
  --no-install      Skip npm install even if node_modules is missing
  -h, --help        Show this help message
EOF
}

BUNDLES="appimage,deb"
AUTO_INSTALL=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --bundles)
      BUNDLES="${2:-}"
      shift 2
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

for cmd in node npm cargo rustc; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: '$cmd' is required to build the Tauri desktop client." >&2
    exit 1
  fi
done

if [[ ! -d node_modules && "$AUTO_INSTALL" -eq 1 ]]; then
  echo "[1/3] Installing npm dependencies..."
  npm ci
fi

echo "[2/3] Building frontend bundle (Vite + TypeScript)..."
npm run build

echo "[3/3] Building Tauri v2 desktop packages ($BUNDLES)..."
npx tauri build --bundles "$BUNDLES"

echo "Done. Artifacts are located under src-tauri/target/release/bundle/"

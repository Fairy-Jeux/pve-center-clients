[CmdletBinding()]
param(
    [string]$Bundles = "nsis,msi",
    [switch]$SkipInstall
)

$ErrorActionPreference = "Stop"
$RootDir = Split-Path -Parent $PSScriptRoot
Set-Location $RootDir

foreach ($cmd in @("node", "npm", "cargo", "rustc")) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        throw "Required tool '$cmd' was not found in PATH."
    }
}

if ((-not (Test-Path "node_modules")) -and (-not $SkipInstall)) {
    Write-Host "[1/3] Installing npm dependencies..."
    npm ci
}

Write-Host "[2/3] Building frontend bundle (Vite + TypeScript)..."
npm run build

Write-Host "[3/3] Building Tauri v2 Windows installers ($Bundles)..."
npx tauri build --bundles $Bundles

Write-Host "Done. Installers are located under src-tauri\target\release\bundle\"

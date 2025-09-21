<#
vcpkg_installer.ps1
Installs vcpkg into C:\vcpkg, bootstraps it, and sets PATH + VCPKG_ROOT.
Run as Administrator.
#>

# ==== Elevation guard ====
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator (elevated PowerShell)."
    exit 1
}

# ==== Target directory ====
$vcpkgRoot = "C:\vcpkg"

# Remove existing install if you want a clean reset
if (Test-Path $vcpkgRoot) {
    Write-Host "Removing existing $vcpkgRoot..."
    Remove-Item -Recurse -Force $vcpkgRoot
}

# ==== Clone vcpkg ====
Write-Host "Cloning vcpkg into $vcpkgRoot..."
git clone https://github.com/microsoft/vcpkg.git $vcpkgRoot

# ==== Bootstrap ====
Write-Host "Bootstrapping vcpkg..."
& "$vcpkgRoot\bootstrap-vcpkg.bat"

# ==== Set environment variables ====
Write-Host "Setting VCPKG_ROOT and updating PATH..."

# Set VCPKG_ROOT (system-wide)
[System.Environment]::SetEnvironmentVariable("VCPKG_ROOT", $vcpkgRoot, "Machine")

# Add to PATH (system-wide)
$oldPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
if (-not ($oldPath -split ";" | Where-Object { $_ -eq $vcpkgRoot })) {
    $newPath = "$oldPath;$vcpkgRoot"
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
    Write-Host "Added $vcpkgRoot to PATH."
} else {
    Write-Host "$vcpkgRoot already in PATH."
}

Write-Host "vcpkg installation complete. You may need to restart your shell or reboot for PATH changes to take effect."

# Temporarily bypass execution policy with unsigned script
Set-ExecutionPolicy Bypass -Scope Process -Force

#Manual Install:
    #Blender
    #ZeroTier
    #Python3-aider
    #cywgin -> devel + mintty -> "C:\cygwin64\bin" to path
    #msys2
    #git-lfs
    #May not be a bad idea to parse this list for software that chocolatey doesn't keep updated well.
    
    #Lib:
    #SDL2
    #zlib -> OpenTTD

#Chocolatey:
Write-Host "Installing Chocolatey if not installed."
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey is not installed. Installing Chocolatey..."
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
choco upgrade chocolatey -y

#Function to call Chocolatey and install a package if it's not already installed.
function Install-ChocoPackageIfNotInstalled {
    param (
        [string]$packageName
    )

    if (-not (choco list --local-only | Select-String $packageName)) {
        choco install $packageName -y
    } else {
        Write-Host "$packageName is already installed."
    }
}
#WSL-Ubuntu:
Write-Host "Installing Ubuntu Preview WSL if not installed."
if (-not (wsl --list --verbose | Select-String "Ubuntu-Preview")) {
    wsl --install -d Ubuntu-Preview
} else {
    Write-Host "Ubuntu Preview is already installed."
}
#IDE:
Write-Host "Installing IDEs and related software."
Install-ChocoPackageIfNotInstalled "visualstudio2022community"

#JB/IDE:
Install-ChocoPackageIfNotInstalled "jetbrainstoolbox"

#Text Editor:
Write-Host "Installing text editors"
Install-ChocoPackageIfNotInstalled "neovim"
Install-ChocoPackageIfNotInstalled "vscode"

#Coding Tools:
Write-Host "Installing common software development tools."
Install-ChocoPackageIfNotInstalled "docker-desktop"
Install-ChocoPackageIfNotInstalled "github-desktop"
Install-ChocoPackageIfNotInstalled "git"
Install-ChocoPackageIfNotInstalled "cmake --installargs 'ADD_CMAKE_TO_PATH=System'"
Install-ChocoPackageIfNotInstalled "cygwin"


#LLM:
Install-ChocoPackageIfNotInstalled "ollama"


#Messaging:
Write-Host "Installing messaging software."
Install-ChocoPackageIfNotInstalled "signal"

#Gaming/Launcher:
Write-Host "Installing game launchers"
Install-ChocoPackageIfNotInstalled "steam"
Install-ChocoPackageIfNotInstalled "epicgameslauncher"
#ea origin

#Emulation/VM:
Write-Host "Installing VM software"
Install-ChocoPackageIfNotInstalled "virtualbox"
#QEMU?

#Conda:
Write-Host "Installing python and tools."
Install-ChocoPackageIfNotInstalled "miniconda3"

#Python3

#Misc:
Write-Host "Installing miscellaneous Windows software."
Install-ChocoPackageIfNotInstalled "okular"
Install-ChocoPackageIfNotInstalled "powertoys"
Install-ChocoPackageIfNotInstalled "7zip"
Install-ChocoPackageIfNotInstalled "windirstat"

#Art:
Write-Host "Installing art related software. Please remember to install necessary dependencies and build Aseprite from source."
Install-ChocoPackageIfNotInstalled "paint.net"
#Install-ChocoPackageIfNotInstalled "cherrytree"
#Install-ChocoPackageIfNotInstalled "greenshot"
Install-ChocoPackageIfNotInstalled "gimp"
Install-ChocoPackageIfNotInstalled "krita"
#Install-ChocoPackageIfNotInstalled "blender" 

#Productivity:
Write-Host "Installing productivity tools."
Install-ChocoPackageIfNotInstalled "obsidian"
Install-ChocoPackageIfNotInstalled "joplin"

#java:
#Install-ChocoPackageIfNotInstalled "openjdk"
#Install-ChocoPackageIfNotInstalled "javaruntime"

Write-Host "Installation complete. Please run VCPKG setup script and restart your computer."
Write-Host "Other software not included here: OneNote, Massgrave AS, Aseprite, Godot, Unreal."
Write-Host "Other dependencies not included here: Skia for Aseprite, Ninja Build, SDL2, Zlib."
# Re-enable execution policy
Set-ExecutionPolicy Restricted -Scope Process -Force

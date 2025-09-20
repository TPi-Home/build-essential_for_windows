#oh my posh, fastfetch, fzf, cascadia nerd, meslolgm
winget install JanDeDobbeleer.OhMyPosh --source winget --scope user --force
#Install-Module -Name Terminal-Icons -Repository PSGallery
#Import-Module -Name Terminal-Icons
#Install-Module posh-git -Scope CurrentUser
#Install-Module oh-my-posh -Scope CurrentUser
#Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
# Temporarily bypass execution policy with unsigned script
Set-ExecutionPolicy Bypass -Scope Process -Force

# Ensure winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Warning "winget (Windows Package Manager) is not available. Install 'App Installer' from Microsoft Store, then rerun."
    exit 1
}

# Resolve & install a winget package if not already installed.
function Install-WingetPackageIfNotInstalled {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Name,      # Human name (used to search if Id not given)
        [string]$Id,                                    # Exact winget Id (preferred)
        [string]$OverrideArgs                           # e.g., 'ADD_CMAKE_TO_PATH=System'
    )

    # Helper: return $true if package with Id is already installed
    function Test-PackageInstalledById([string]$PkgId) {
        if (-not $PkgId) { return $false }
        try {
            $list = winget list --id $PkgId -s winget -o json 2>$null | ConvertFrom-Json
            return ($list.SourceDetails.Count -gt 0 -or $list.Matches.Count -gt 0 -or $list.InstalledPackages.Count -gt 0)
        } catch { return $false }
    }

    # Resolve Id from Name (exact) if needed
    $resolvedId = $Id
    if (-not $resolvedId) {
        try {
            $srch = winget search --name "$Name" -e -s winget -o json 2>$null | ConvertFrom-Json
            if ($srch.Count -gt 0) {
                # Prefer first exact result
                $resolvedId = $srch[0].Id
            }
        } catch { $resolvedId = $null }
    }

    # If we still don't have an Id, give up gracefully
    if (-not $resolvedId) {
        Write-Warning "No winget package found for: $Name. Commented out and moved to Manual section."
        return $false
    }

    # Skip if already installed
    if (Test-PackageInstalledById $resolvedId) {
        Write-Host "$Name is already installed."
        return $true
    }

    # Build install command
    $args = @("install","--id",$resolvedId,"-e","--silent","--accept-package-agreements","--accept-source-agreements")
    if ($OverrideArgs) {
        $args += @("--override",$OverrideArgs)
    }

    Write-Host "Installing $Name ($resolvedId)..."
    $proc = Start-Process winget -ArgumentList $args -Wait -PassThru
    if ($proc.ExitCode -ne 0) {
        Write-Warning "winget failed for $Name ($resolvedId) with exit code $($proc.ExitCode)."
        return $false
    }
    return $true
}

# --------------------------
# WSL: Ubuntu Preview
# --------------------------
Write-Host "Ensuring WSL Ubuntu-Preview is installed..."
if (-not (wsl --list --verbose 2>$null | Select-String "Ubuntu-Preview")) {
    wsl --install -d Ubuntu-Preview
} else {
    Write-Host "Ubuntu-Preview is already installed."
}

# --------------------------
# Packages (most have exact IDs; a few rely on Name auto-resolve)
# --------------------------
$packages = @(
    # Network
    @{ Name="ZeroTier"; Id="ZeroTier.ZeroTierOne" }


    # Shells
    @{ Name="PowerShell 7";                 Id="Microsoft.PowerShell" }

    # DB tools
    @{ Name="DB Browser for SQLite";        Id="DBBrowserForSQLite.DBBrowserForSQLite" }

    # Office
    @{ Name="Microsoft 365 Apps (Office)";  Id="Microsoft.Office" }

    # VPN
    @{ Name="Proton VPN";                   Id="Proton.ProtonVPN" }

    # IDEs
    @{ Name="Visual Studio Community 2022"; Id="Microsoft.VisualStudio.2022.Community" }   # workloads can be added later
    @{ Name="JetBrains Toolbox";            Id="JetBrains.Toolbox" }

    # Terminals
    @{ Name="Windows Terminal Preview";     Id="Microsoft.WindowsTerminal.Preview" }

    # Editors
    @{ Name="Neovim";                       Id="Neovim.Neovim" }
    @{ Name="Visual Studio Code";           Id="Microsoft.VisualStudioCode" }

    # Coding tools
    @{ Name="Docker Desktop";               Id="Docker.DockerDesktop" }
    @{ Name="GitHub Desktop";               Id="GitHub.GitHubDesktop" }
    @{ Name="Git";                          Id="Git.Git" }
    @{ Name="CMake";                        Id="Kitware.CMake";           OverrideArgs="ADD_CMAKE_TO_PATH=System" }
    #@{ Name="Cygwin";                       Id="Cygwin.Cygwin" }
    #@{ Name="MSYS2";                        Id="MSYS2.MSYS2" }
    #@{ Name="Git LFS";                      Id="GitHub.GitLFS" }

    # LLM / DevOps
    @{ Name="Ollama";                       Id="Ollama.Ollama" }

    # Messaging
    @{ Name="Signal";                       Id="OpenWhisperSystems.Signal" }

    # Gaming / Launchers
    @{ Name="Steam";                        Id="Valve.Steam" }
    @{ Name="Epic Games Launcher";          Id="EpicGames.EpicGamesLauncher" }
    #@{ Name="EA App";                       Id="ElectronicArts.EADesktop" }

    # Emulation / VM
    @{ Name="VirtualBox";                   Id="Oracle.VirtualBox" }
    #@{ Name="QEMU";                         Id="SoftwareFreedomConservancy.QEMU" }

    # Python / Conda
    #@{ Name="Miniconda3";                   Id="Anaconda.Miniconda3" }

    # Misc
    @{ Name="Okular";                       Id="KDE.Okular" }
    @{ Name="PowerToys";                    Id="Microsoft.PowerToys" }
    #@{ Name="7-Zip";                        Id="7zip.7zip" }
    #@{ Name="WinDirStat";                   Id="WinDirStat.WinDirStat" }

    # Art
    #@{ Name="Paint.NET";                    Id="dotPDNLLC.paintdotnet" }
    #@{ Name="GIMP";                         Id="GIMP.GIMP" }
    #@{ Name="Krita";                        Id="KDE.Krita" }
    #@{ Name="Blender";                      Id="BlenderFoundation.Blender" }

    # Productivity
    @{ Name="Obsidian";                     Id="Obsidian.Obsidian" }
    #@{ Name="Joplin";                       Id="Joplin.Joplin" }
)

# Install loop
$failed = @()
foreach ($p in $packages) {
    $ok = Install-WingetPackageIfNotInstalled -Name $p.Name -Id $p.Id -OverrideArgs $p.OverrideArgs
    if (-not $ok) { $failed += $p }
}

# --------------------------
# Manual installs (commented out or not found)
# --------------------------
# If something above couldn't be resolved/installed, it will be listed here at runtime:
if ($failed.Count -gt 0) {
    Write-Warning "The following entries were not installed via winget and may need manual install:"
    $failed | ForEach-Object { Write-Host (" - {0} (Id tried: {1})" -f $_.Name, ($_.Id | ForEach-Object {$_})) }
}

# Extra notes you had in the original script
Write-Host "Other software not included here: OneNote, Massgrave AS, Aseprite (build), Godot, Unreal."
Write-Host "Other dev libs not handled by winget: SDL2, Zlib (via vcpkg or your build system)."
Write-Host "Installation complete. Consider running your VCPKG setup next."
. "$PSScriptRoot\clean.ps1"

# Re-enable execution policy
Set-ExecutionPolicy Restricted -Scope Process -Force

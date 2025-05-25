Write-Host "Starting script execution..."






# ========== Logging Setup ==========

# Get user's Desktop path
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$LogFile = Join-Path $DesktopPath "InstallLog.txt"

# Function to log actions
function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "$timestamp - $Message"
    Write-Host $entry
    Add-Content -Path $LogFile -Value $entry
}

Write-Log "===== Script started ====="








# ========== Admin Check ==========

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Log "ERROR: Script must be run as Administrator."
    Exit 1
}








# ========== Winget Check ==========

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Log "ERROR: winget is not installed on this system."
    exit 1
}








# ========== Winget Update ==========

Write-Log "Upgrading existing packages via winget..."
winget upgrade --all --silent








# ========== Application List ==========

$apps = @(

    # == Essentials ==
    "Microsoft.VisualStudioCode",        # Code editor
    "Mozilla.Firefox",                   # Browser
    "7zip.7zip",                         # Archive tool
    "RARLab.WinRAR",                     # WinRAR
    "Microsoft.PowerToys",               # Productivity tools
    "Discord.Discord",                   # Voice/chat for games and community
    "Spotify.Spotify",                   # Music

    # == Gaming Platforms ==
    "RiotGames.LeagueOfLegends.EUW",     # LoL EUW
    "RiotGames.LeagueOfLegends.PBE",     # LoL PBE
    "RiotGames.LegendsOfRuneterra.EUW",  # LoR EUW
    "Blizzard.BattleNet",                # Battle.net
    "Valve.Steam",                       # Steam
    "Ubisoft.Connect",                   # Ubisoft launcher

    # == Proton Apps ==
    "Proton.ProtonMail",                 # Proton Mail
    "ProtonTechnologies.ProtonVPN",      # Proton VPN
    "Proton.ProtonPass",                 # Proton Pass
    "Proton.ProtonDrive",                # Proton Drive
    "Proton.ProtonCalendar",             # Proton Calendar

    # == Java Runtime ==
    "Oracle.JavaRuntimeEnvironment",     # Java Runtime

    # == .NET Runtimes ==
    "Microsoft.DotNet.Runtime.8",        # .NET Runtime 8
    "Microsoft.DotNet.DesktopRuntime.9", # .NET Desktop Runtime 9
    "Microsoft.DotNet.Framework.DeveloperPack_4.8"  # .NET Framework 4.8

)








# ========== Install Loop ==========

foreach ($app in $apps) {
    Write-Log "Attempting to install $app..."
    try {
        winget install --id="$app" --silent --accept-package-agreements --accept-source-agreements
        Write-Log "Successfully installed $app."
    } catch {
        Write-Log "FAILED to install $app: $_"
    }
}








# ========== Wrap Up ==========

Write-Log "===== Script completed ====="
Write-Host "Script execution completed. Log file created at $LogFile"








# ========== Wait and Reboot ==========

Write-Host "System will reboot in 1 minute. Press ESC to cancel reboot."

$reboot = $true

for ($i = 60; $i -gt 0; $i--) {
    Write-Host -NoNewline "`rRebooting in $i seconds... Press CTRL+C to cancel. "
    Start-Sleep -Seconds 1
}

if ($reboot) {
    Write-Log "Rebooting system..."
    Restart-Computer
}
if ($reboot) {
    Write-Log "Rebooting system..."
    Restart-Computer
} else {
    Write-Log "Reboot cancelled by user (use CTRL+C to cancel during countdown)."
}

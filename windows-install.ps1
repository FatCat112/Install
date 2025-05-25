Write-Host "Starting script execution..."






# ========== Logging Setup ==========

# Get user's Desktop path
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$LogFile = Join-Path $DesktopPath "InstallLog.txt"

# Function to log actions
function Log-Action {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "$timestamp - $Message"
    Write-Host $entry
    Add-Content -Path $LogFile -Value $entry
}

Log-Action "===== Script started ====="








# ========== Admin Check ==========

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Log-Action "ERROR: Script must be run as Administrator."
    exit
}








# ========== Winget Check ==========

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Log-Action "ERROR: winget is not installed on this system."
    exit
}








# ========== Winget Update ==========

Log-Action "Upgrading existing packages via winget..."
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
    "Microsoft.DotNet.Framework.DeveloperPack_4" # .NET Framework 4.8

)








# ========== Install Loop ==========

foreach ($app in $apps) {
    Log-Action "Attempting to install $app..."
    try {
        winget install --id=$app --silent --accept-package-agreements --accept-source-agreements
        Log-Action "Successfully installed $app."
    } catch {
        Log-Action "FAILED to install $app: $_"
    }
}








# ========== Wrap Up ==========

Log-Action "===== Script completed ====="
Write-Host "Script execution completed. Log file created at $LogFile"








# ========== Wait and Reboot ==========

Write-Host "System will reboot in 1 minute. Press ESC to cancel reboot."

$reboot = $true

for ($i = 60; $i -gt 0; $i--) {
    Write-Host -NoNewline "`rRebooting in $i seconds... Press ESC to cancel. "
    Start-Sleep -Seconds 1

    if ([console]::KeyAvailable) {
        $key = [console]::ReadKey($true)
        if ($key.Key -eq 'Escape') {
            Write-Host "`nReboot cancelled by user."
            $reboot = $false
            break
        }
    }
}

if ($reboot) {
    Log-Action "Rebooting system..."
    Restart-Computer
}

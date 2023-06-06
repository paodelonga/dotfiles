# Languages & Configs
Set-WinUserLanguageList -LanguageList en-NZ pt-BR
foreach ($regkey in (Get-ChildItem -File -Path "$PWD\reg\")) {
	Invoke-Expression "REG IMPORT $PWD\reg\$regkey"
}

# Windows Store Packages
$wsPackages = @(
    "40459File-New-Project.EarTrumpet_1sdd7yawvg6ne"
    "Microsoft.WindowsTerminal_8wekyb3d8bbwe"
)

foreach ($package in $wsPackages) {
    Add-AppxPackage -RegisterByFamilyName -MainPackage "$package" -ErrorAction SilentlyContinue
}

# Windows Terminal
$wtPath = "C:\Users\$ENV:USERNAME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\"

if (Get-AppxPackage -Name "Microsoft.WindowsTerminal") {
    Copy-Item -Force -Path "$PWD\config\windows-terminal\*" -Destination "$wtPath" -ErrorAction SilentlyContinue
} else { 
    Throw "Windows Terminal is not installed. install it manually"
}

# Scoop.sh
function updateScoop {
	scoop install git
    scoop update
    $scoopPackages = @(
        "extras/vcredist2022"
        "arduino-cli"
        "micro"
        "btop"
        "spicetify-cli"
        "neofetch"
        "ncspot"
        "gpg"
        "git"
        "sudo"
    )
    
    foreach ($package in $scoopPackages) {
        scoop install $package
    }
    scoop update
}

if (Get-Command "scoop" -ErrorAction SilentlyContinue) {
    updateScoop                  
} else {
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
    updateScoop                 
}

# Spotify
Get-AppxPackage -Name "SpotifyAB.SpotifyMusic"  | Remove-AppxPackage
Invoke-WebRequest -Uri "https://download.scdn.co/SpotifySetup.exe" -OutFile "$ENV:TEMP\SpotifySetup.exe"
Start-Process -File "$ENV:TEMP\SpotifySetup.exe" -Wait
Invoke-Expression "spicetify apply --quiet"

# OBS Studio
Copy-Item -Force -Path "$PWD\config\obs-studio\*" -Destination "$ENV:APPDATA\obs-studio\" -ErrorAction SilentlyContinue

# Configs
$homeConfigs = @(
    "btop"
    "micro"
    "neofetch"
    "spicetify"
)

foreach ($folder in $homeConfigs) {
    Copy-Item -Force -Path "$PWD\config\$folder" -Destination "$ENV:USERPROFILE\.config\" -ErrorAction SilentlyContinue
}

# Firefox
Invoke-WebRequest -Uri "https://download.mozilla.org/?product=firefox-devedition-stub&os=win&lang=en-US" -OutFile "$ENV:TEMP\FirefoxSetup.exe"

function Write-Typewriter {
  param(
      [string]$Text,
      [int]$DelayMs = 10,
      [switch]$NoNewLine,
      [switch]$Rainbow
  )

  foreach ($char in $Text.ToCharArray()) {
      if (-not $Rainbow) {
        Write-Host -NoNewline $char
      } else {
          Write-Rainbow $char -NoNewLine 
        }
      Start-Sleep -Milliseconds $DelayMs
  }
  if (-not $NoNewLine) {
    Write-Host ""
  }
}

function Write-Section {
  param(
    [string]$text,
    [switch]$Rainbow
  )
  $width = 40
  Write-Host ""
  Write-Host ("~=" * ($width / 2)) -ForegroundColor DarkGray
  $textLength = $text.Length
  $innerWidth = $width - 4  # space for "= " and " ="
  $leftPadding = [math]::Floor(($innerWidth - $textLength) / 2)
  $rightPadding = $innerWidth - $textLength - $leftPadding

  $line = "= " + (" " * $leftPadding) + $text + (" " * $rightPadding) + " ="
  if (-not $Rainbow) {
    Write-Typewriter $line
  } else {
    Write-Typewriter $line -Rainbow
  }

  Write-Host ("~=" * ($width / 2)) -ForegroundColor DarkGray
  Write-Host ""
}

$cols = @('Red', 'DarkYellow', 'Green', 'Blue', 'Magenta')
$script:colIndex = Get-Random -Minimum 0 -Maximum $cols.Count

function Write-Rainbow {
  param(
    [string]$text,
    [switch]$NoNewLine
  )
  $col = $cols[$colIndex % $cols.Count]
  if (-not $NoNewLine) {
    Write-Host $text -ForegroundColor $col
  } else {
    Write-Host $text -ForegroundColor $col -NoNewLine
  }
  $script:colIndex++
}


$global:allSelected = $false

function Ask-User {
    param(
      [string]$Message,
      [int]$Pad = 37
    )

    Write-Typewriter $Message.PadRight($Pad) -NoNewline -Rainbow
    if ($global:allSelected) { Write-Host "[x]" -ForegroundColor Green; return $true }
    do {
        $key = [System.Console]::ReadKey($true).Key
        switch ($key) {
            "Y" { Write-Host "[x]" -ForegroundColor Green; return $true }
            "N" { Write-Host "[-]" -ForegroundColor Red; return $false }
            "A" { Write-Host "[x]" -ForegroundColor Green; $global:allSelected = $true; return $true }
        }
    } while ($true)
}
Write-Host @"

 /\_/\   mr cat says:
( o.o )      " welcome to lewis' 
 > ^ <         cool dotfile installer! "   
"@ -ForegroundColor Magenta

Write-Host "`n~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=`n" -ForegroundColor DarkGray
Write-Typewriter "this script will run you through a basic" -DelayMs 10
Write-Typewriter "set-up, by using scoop to install all of" -DelayMs 10
Write-Typewriter "the stuff in scoop/apps.txt`n" -DelayMs 10
Write-Typewriter "if you don't want some of the stuff in" -DelayMs 10
Write-Typewriter "there, just delete it from the txt file`n" -DelayMs 10
Write-Typewriter "if you want more stuff, https://scoop.sh" -DelayMs 10
Write-Typewriter "has a full list. just search there and u" -DelayMs 10
Write-Typewriter "can add any of the app names to apps.txt" -DelayMs 10
Write-Typewriter "and they'll get installed too`n" -DelayMs 10
Write-Typewriter "there's also a powershell profile, and a" -DelayMs 10
Write-Typewriter "couple optional extras" -DelayMs 10
Write-Host "`n~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=`n" -ForegroundColor DarkGray

Write-Host "[y]es  -  [n]o  -  [a]ccept all`n" -ForegroundColor Green
$config_wez = Ask-User "~ ctrl+alt+w to open wezterm?"
$config_zoxide = Ask-User "~ replace cd wth zoxide?"
$config_nvim = Ask-User "~ want my nvim config?"
$config_git  = Ask-User "~ configure git?"
$config_posh = Ask-User "~ what about posh-git?"
$config_games = Ask-User "~ my fave roguelikes?"

Write-Section "setting up scoop !"

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
  Write-Rainbow "~ getting scoop!"
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  iwr -useb get.scoop.sh | iex
} else {
  Write-Rainbow "~ found scoop, updating!"
  scoop update
}

Write-Section "fetching scoop buckets !"

$buckets = scoop bucket list | ForEach-Object { $_.Name }

Get-Content "$PSScriptRoot/scoop/buckets.txt" | ForEach-Object {
  $bucket = $_.Trim()
  if ($bucket -and -not ($buckets -contains $bucket)) {
    Write-Rainbow "~ adding bucket: $bucket"
    scoop bucket add $bucket
  } else {
    Write-Rainbow "~ found bucket: $bucket"
  }
}

Write-Section "getting scoop apps !"

$raw = & { scoop list *>&1 }
$apps = $raw | Where-Object { $_ -is [pscustomobject] } | ForEach-Object { $_.Name }

Get-Content "$PSScriptRoot/scoop/apps.txt" | ForEach-Object {
  $app = $_.Trim()
  if ($app -and -not ($apps -contains $app)) {
    Write-Rainbow "~ installing $app"
    scoop install $app
  } else {
    Write-Rainbow "~ found $app, updating"
    scoop update $app
  }
}

if ($config_games) {
  Write-Section "[optional] my fave games"
  if (-not ($buckets -contains "games")) {
    Write-Rainbow "~ adding bucket: games"
    scoop bucket add games
  } else {
    Write-Rainbow "~ found bucket: games"
  }
  Get-Content "$PSScriptRoot/scoop/games.txt" | ForEach-Object {
    $app = $_.Trim()
    if ($app -and -not ($apps -contains $app)) {
      Write-Rainbow "~ installing $app"
      scoop install $app
    } else {
      Write-Rainbow "~ found $app, updating"
      scoop update $app
    }
  }
}

Write-Rainbow "~ nearly done. some configs and extra bits"


if (-not (Test-Path $HOME/.config)) {
  New-Item -ItemType Directory -Path $HOME/.config | Out-Null
  Write-Rainbow "~ creating $HOME/.config dir"
}

if (-not (Test-Path $HOME/.config/wezterm)) {
  New-Item -ItemType Directory -Path $HOME/.config/wezterm | Out-Null
  Write-Rainbow "~ creating $HOME/.config/wezterm dir"
}

Write-Rainbow "~ copying .wezterm.lua to $HOME/.config/wezterm/"
Copy-Item $PSScriptRoot/wezterm/wezterm.lua $HOME/.config/wezterm/wezterm.lua -Force
Copy-Item $PSScriptRoot/wezterm/keys.lua $HOME/.config/wezterm/keys.lua -Force
if ($config_wez) {
  Write-Rainbow "~ running wezterm postinstall"
  Write-Rainbow "~ adding ahk script to startup"
  Write-Rainbow "~ running script as a one-off"
  Write-Rainbow "~ w00t! ctrl+alt+w to wezterm!"
  . $PSScriptRoot/wezterm/postinstall.ps1 
}

if ($config_posh) {
  Write-Section "[optional] posh-git"
  if (-not (Get-Module -ListAvailable posh-git)) {
    Write-Rainbow "~ updating nuget for current user"
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Scope CurrentUser -Force *>&1 | Out-Null
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Rainbow "~ installin posh-git module"
    Install-Module posh-git -Scope CurrentUser -Force
  } else {
    Write-Rainbow "~ you've already got posh-git available, nice !"
  }
}

Write-Section "lazygit config"

if (-not (Test-Path $env:LOCALAPPDATA/lazygit)) {
  New-Item -ItemType Directory -Path $env:LOCALAPPDATA/lazygit | Out-Null
  Write-Rainbow "~ creating dir"
}

Copy-Item $PSScriptRoot/lazygit/config.yml $env:LOCALAPPDATA/lazygit/config.yml -Force
Write-Rainbow "~ added custom commands"
Write-Rainbow "  'C'        ->     to conventional commits"
Write-Rainbow "  'b'        ->     to prune deleted remotes"

if ($config_nvim) {
  Write-Section "[optional] nvim config"
  Write-Host "~ cloning !" -ForegroundColor Green
  . $PSScriptRoot/nvim/config.ps1
}

if ($config_git) {
  Write-Section "[optional] global git config"
  . $PSScriptRoot/git/config.ps1
}

Write-Section "copying powershell profile !"

Copy-Item $PSScriptRoot/powershell/profile.ps1 $PROFILE -Force
Add-Content -Path $PROFILE -Value "`nfunction dotfiles { Set-Location '$PSScriptRoot' }"

if ($config_zoxide) {
  Write-Rainbow "~ adding zoxide"
  Write-Rainbow "    cd       ->     untouched"
  Add-Content -Path $PROFILE -Value "`nInvoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })"
} else {
  Write-Rainbow "    cd       ->     zoxide"
  Add-Content -Path $PROFILE -Value "`nInvoke-Expression (& { (zoxide init powershell | Out-String) })"
}

Write-Rainbow "~ setting up aliases for nav"
Write-Rainbow "    dotfiles ->     go to this dir"
Write-Rainbow "    docs     ->     go to documents"
Write-Rainbow "    dt       ->     go to desktop"
Write-Rainbow "    dl       ->     go to downloads"
Write-Rainbow "    nvimc    ->     go to nvim config"
Write-Rainbow "    ..       ->     go up a dir (..., etc. to go up multiple)"
Write-Rainbow "    ~        ->     go home"
Write-Rainbow "~ bash aliases"
Write-Rainbow "    time     ->     Measure-Command"
Write-Rainbow "    vi, vim  ->     nvim"
Write-Rainbow "    ls       ->     list contents (with colour)"
Write-Rainbow "    l        ->     list contents (long)"
Write-Rainbow "    la       ->     list contents (including hidden files)"
Write-Rainbow "    lsd      ->     list directories"

if ($config_posh) {
  Add-PoshGitToProfile
  Write-Rainbow "~ added posh-git import"
}

$dotsourced = $MyInvocation.InvocationName -eq '.'

if ($dotsourced) {
  . $PROFILE
  Write-Rainbow "~ reloaded profile"
} else {
  Write-Section "you need to do one more step!!!"
  Write-Host "write '. `$PROFILE' to reload your profile manually" -ForegroundColor Red
  Write-Host "write '. `$PROFILE' to reload your profile manually" -ForegroundColor DarkYellow
  Write-Host "write '. `$PROFILE' to reload your profile manually" -ForegroundColor Green
  Write-Host "write '. `$PROFILE' to reload your profile manually" -ForegroundColor Blue
  Write-Host "write '. `$PROFILE' to reload your profile manually" -ForegroundColor Magenta
}

Write-Host "~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=" -ForegroundColor DarkGray
Write-Host @"
                                   _________
  and we're all done    /\_/\     / bye for \
  say bye to cat       ( o.o )  <{   meow!~  }
                        > ^ <     \_________/
  2025. lewis wynne

"@ -ForegroundColor Magenta

Write-Typewriter "ps. i added 'dotfiles' as a shortcut to get back here`n" -DelayMs 60

Remove-Variable colIndex, allSelected -Scope Script -ErrorAction SilentlyContinue
Remove-Variable ans, dotsourced, raw, apps, buckets, cols -ErrorAction SilentlyContinue


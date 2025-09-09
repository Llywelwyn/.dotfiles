Write-Host @"

   /\_/\   mr cat says:
  ( o.o )      welcome to lewis' cool dotfile installer !
   > ^ <  
"@ -ForegroundColor Magenta

function Write-Section($text) {
  $width = 40 
  Write-Host ""
  Write-Host ("~=" * ($width/2)) -ForegroundColor DarkGray
  Write-Host ("= " + $text.PadRight($width - 4) + " =") -ForegroundColor Green
  Write-Host ("~=" * ($width/2)) -ForegroundColor DarkGray
  Write-Host ""
}

Write-Section "setting up scoop !"

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
  Write-Host "~ getting scoop!"
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  iwr -useb get.scoop.sh | iex
} else {
  Write-Host "~ found scoop, updating!"
  scoop update
}

Write-Section "fetching scoop buckets !"

$buckets = scoop bucket list | ForEach-Object { $_.Name }

Get-Content "./scoop/buckets.txt" | ForEach-Object {
  $bucket = $_.Trim()
  if ($bucket -and -not ($buckets -contains $bucket)) {
    Write-Host "~ adding bucket: $bucket"
    scoop bucket add $bucket
  } else {
    Write-Host "~ found bucket: $bucket"
  }
}

Write-Section "getting scoop apps !"

$raw = & { scoop list *>&1 }
$apps = $raw | Where-Object { $_ -is [pscustomobject] } | ForEach-Object { $_.Name }

Get-Content "./scoop/apps.txt" | ForEach-Object {
  $app = $_.Trim()
  if ($app -and -not ($apps -contains $app)) {
    Write-Host "~ installing app: $app"
    scoop install $app
  } else {
    Write-Host "~ found app: $app"
  }
}

Write-Host "~ all finished with scoop"

Write-Section "copying powershell profile !"

Copy-Item ./powershell/profile.ps1 $PROFILE -Force

$dotsourced = $MyInvocation.InvocationName -eq '.'

if ($dotsourced) {
  . $PROFILE
  Write-Host "~ reloaded profile"
}

Write-Section "nvim"

$ans = Read-Host "~ wanna use llywelwyn/.nvim config? (y/n)"
if ($ans -eq '' -or $ans -match '^(y|yes)$') {
  . ./nvim/config.ps1
}

Write-Section "git global config"

$ans = Read-Host "~ wanna set up git? (y/n)"
if ($ans -eq '' -or $ans -match '^(y|yes)$') {
  . ./git/config.ps1
}

if (-not $dotsourced) {
  Write-Section "you need to do one more step!!!"
  Write-Host "write '. `$PROFILE' to reload your profile manually"
}

Write-Host @"
                                   _________
  and we're all done    /\_/\     / bye for \
  say bye to cat       ( o.o )  <{   meow!~  }
                        > ^ <     \_________/
  2025. lewis wynne

"@ -ForegroundColor Magenta

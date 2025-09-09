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

$cols = @('Red', 'DarkYellow', 'Green', 'Blue', 'Magenta')
$script:colIndex = Get-Random -Minimum 0 -Maximum $cols.Count

function Write-Rainbow($text) {
  $col = $cols[$colIndex % $cols.Count]
  Write-Host $text -ForegroundColor $col  
  $script:colIndex++
}

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

Get-Content "./scoop/buckets.txt" | ForEach-Object {
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

Get-Content "./scoop/apps.txt" | ForEach-Object {
  $app = $_.Trim()
  if ($app -and -not ($apps -contains $app)) {
    Write-Rainbow "~ installing app: $app"
    scoop install $app
  } else {
    Write-Rainbow "~ found app: $app"
  }
}

Write-Rainbow "~ all finished with scoop"

if (-not (Get-Module -ListAvailable posh-git)) {
  Write-Section "adding posh-git"
  Write-Rainbow "~ updating nuget for current user"
  Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Scope CurrentUser -Force *>&1 | Out-Null
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  Write-Rainbow "~ installin posh-git module"
  Install-Module posh-git -Scope CurrentUser -Force
} else {
  Write-Rainbow "~ you've already got posh-git available, nice !"
}

Write-Section "copying powershell profile !"

Copy-Item ./powershell/profile.ps1 $PROFILE -Force

Write-Rainbow "~ setting up alises for nav"
Write-Rainbow "  ~, .., dt, docs, dl, nvimc"
Write-Rainbow "~ bash aliases"
Write-Rainbow "  time -> Measure-Command"
Write-Rainbow "  vi, vim -> nvim"
Write-Rainbow "  wget, curl, gurl"
Write-Rainbow "  ls, l, la, lsd"

Add-PoshGitToProfile

Write-Rainbow "~ added posh-git to profile"

$dotsourced = $MyInvocation.InvocationName -eq '.'

if ($dotsourced) {
  . $PROFILE
  Write-Rainbow "~ reloaded profile"
}

Write-Section "optional cool nvim config"

$ans = Read-Host "~ wanna use llywelwyn/.nvim config? (y/n)"
if ($ans -eq '' -or $ans -match '^(y|yes)$') {
  Write-Host "~ cloning !" -ForegroundColor Green
  . ./nvim/config.ps1
}

Write-Section "while im here lemme do ur git config"

$ans = Read-Host "~ wanna set up git? (y/n)"
if ($ans -eq '' -or $ans -match '^(y|yes)$') {
  . ./git/config.ps1
}

if (-not $dotsourced) {
  Write-Section "you need to do one more step!!!"
  Write-Host "write '. `$PROFILE' to reload your profile manually" -ForegroundColor Red
  Write-Host "write '. `$PROFILE' to reload your profile manually" -ForegroundColor DarkYellow
  Write-Host "write '. `$PROFILE' to reload your profile manually" -ForegroundColor Green
  Write-Host "write '. `$PROFILE' to reload your profile manually" -ForegroundColor Blue
  Write-Host "write '. `$PROFILE' to reload your profile manually" -ForegroundColor Magenta
}

Write-Host @"
                                   _________
  and we're all done    /\_/\     / bye for \
  say bye to cat       ( o.o )  <{   meow!~  }
                        > ^ <     \_________/
  2025. lewis wynne

"@ -ForegroundColor Magenta

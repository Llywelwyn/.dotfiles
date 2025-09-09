Write-Host "~ welcome to my cool dotfiles !"

. ./git/config.ps1

Write-Host "~ setting up scoop!"

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
  Write-Host "~ getting scoop!"
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  iwr -useb get.scoop.sh | iex
} else {
  Write-Host "~ found scoop, updating!"
  scoop update
}

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

Write-Host "~ copying powershell profile!"
Copy-Item ./powershell/profile.ps1 $PROFILE -Force

if ($MyInvocation.InvocationName -eq '.') {
  . $PROFILE
  Write-Host "~ reloaded profile"
} else {
  Write-Host "~ u didn't run this dot-sourced"
  Write-Host "~ that's okay"
  Write-Host "~ reload manually"
  Write-Host "             with this"
  Write-Host "                    command:"
  Write-Host "                            . `$PROFILE"
}

. $PROFILE

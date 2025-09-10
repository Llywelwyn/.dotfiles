$startup = [Environment]::GetFolderPath("Startup")
$ahkScriptPath = Join-Path $startup "WezTermHotkey.ahk"
$ahkScript = @'
^!w::Run EnvGet("UserProfile") "\scoop\apps\wezterm-nightly\current\wezterm-gui.exe"
'@
Set-Content -Path $ahkScriptPath -Value $ahkScript -Encoding UTF8
$ahk = "$Home\scoop\apps\autohotkey\current\v2\AutoHotkey64.exe"
Start-Process -FilePath $ahk -ArgumentList `"$ahkScriptPath`"

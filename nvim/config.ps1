$cfgdir = "$env:LOCALAPPDATA\nvim"

if (-not (Test-Path $cfgdir)) {
  git clone https://github.com/llywelwyn/.nvim $cfgdir
} else {
  Write-Host "~ nvim config already exists at $cfgdir"
  git -C $cfgdir pull
}

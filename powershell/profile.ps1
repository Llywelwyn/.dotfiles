${function:~} = { Set-Location ~ }
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

${function:dt} = { Set-Location ~\Desktop }
${function:docs} = { Set-Location ~\Documents }
${function:dl} = { Set-Location ~\Downloads }
${function:nvimc} = { Set-Location $env:LOCALAPPDATA\nvim }
${function:dotfiles} = { Set-Location $env:DOTFILES }

Set-Alias time Measure-Command
Set-Alias vi nvim
Set-Alias vim nvim

if (Get-Command wget.exe -ErrorAction SilentlyContinue | Test-Path) {
  rm alias:wget -ErrorAction SilentlyContinue
}

if (Get-Command ls.exe -ErrorAction SilentlyContinue | Test-Path) {
    rm alias:ls -ErrorAction SilentlyContinue
    ${function:ls} = { ls.exe --color @args }
    ${function:l} = { ls -lF @args }
    ${function:la} = { ls -laF @args }
    ${function:lsd} = { Get-ChildItem -Directory -Force @args }
} else {
    ${function:la} = { ls -Force @args }
    ${function:lsd} = { Get-ChildItem -Directory -Force @args }
}

if (Get-Command curl.exe -ErrorAction SilentlyContinue | Test-Path) {
    rm alias:curl -ErrorAction SilentlyContinue
    ${function:curl} = { curl.exe @args }
    ${function:gurl} = { curl --compressed @args }
} else {
    ${function:gurl} = { curl -TransferEncoding GZip }
}

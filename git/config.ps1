function GitConfig {
  Write-Host "~ setting up global git config !" -ForegroundColor Cyan

  function Prompt-Required($label) {
    while ($true) {
      $input = Read-Host $label
      if (-not [string]::IsNullOrWhiteSpace($input)) {
        return $input
      } else {
        Write-Host "~ this is required, try again !" -ForegroundColor Yellow
      }
    }
  }

  $name = Prompt-Required "~ enter your name"
  $email = Prompt-Required "~ enter your email"
  $editor = Prompt-Required "~ enter your editor (e.g. 'nvim' or 'code --wait')"

  git config --global user.name "$name"
  git config --global user.email "$email"
  git config --global core.editor "$editor"
  git config --global init.defaultBranch main
  git config --global core.autocrlf true
  git config --global credential.helper manager-core

  # Git aliases
  git config --global alias.st status
  git config --global alias.ci commit
  git config --global alias.co checkout
  git config --global alias.br branch
  git config --global alias.lg "log --oneline --graph --all"

  Write-Host "~ git configuration complete !" -ForegroundColor Green
}

GitConfig

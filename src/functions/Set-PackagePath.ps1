
function Set-PackagePath {
  param(
    [Parameter(Position=0,Mandatory=$true)]
    [string] $path = ""
  )
  Write-Output "Attempting to determine path: $path"
  if(![System.IO.Path]::IsPathRooted($path)) {
    $path = (Join-Path $pwd $path)
  }
  Write-Output "Setting path to: $path"
  $chewie.path = $path
}

New-Alias -Name install_to -Scope Script -Value Set-PackagePath

New-Alias -Name Path -Scope Script -Value Set-PackagePath

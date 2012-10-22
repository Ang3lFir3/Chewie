
function Set-PackagePath {
  param(
    [Parameter(Position=0,Mandatory=$true)]
    [string] $path = ""
  )
  Write-Debug "Attempting to determine path: $path"
  if(![System.IO.Path]::IsPathRooted($path)) {
    $path = (Join-Path $pwd $path)
  }
  Write-Debug "Setting path to: $path"
  $chewie.path = $path
}

Set-Alias -Name install_to -Value Set-PackagePath

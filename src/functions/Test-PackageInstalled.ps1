
function Test-PackageInstalled {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)] [string]$packageName
  )
  return (Get-PackageInstallationPaths $packageName).Length -gt 0
}

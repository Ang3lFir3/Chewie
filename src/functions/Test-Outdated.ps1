
function Test-Outdated {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)][string]$packageName,
    [Parameter(Position=1,Mandatory=$true)][AllowEmptyString()][string]$versionSpec
  )
  if(!(Test-PackageInstalled $packageName)) {
    Write-ColoredOutput "$packageName is not installed." -ForegroundColor Yellow
    return $true
  }
  $maxCompatibleVersion = Get-MaxCompatibleVersion $packageName $versionSpec
  $installedVersion = Get-InstalledPackageVersion $packageName
  $trueMaxVersion = Find-MaxVersion @($maxCompatibleVersion,$installedVersion)
  [bool]$upToDate = "$trueMaxVersion" -eq "$installedVersion"
  return !$upToDate
}

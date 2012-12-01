
function Get-MaxCompatibleVersion {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)][string]$packageName,
    [Parameter(Position=1,Mandatory=$true)][AllowEmptyString()][string]$versionSpec,
    [Parameter(Position=2,Mandatory=$false)][AllowEmptyString()][string]$source,
    [Parameter(Position=3,Mandatory=$false)][bool]$pre = $false
  )
  [xml]$targets = Get-PackageList $packageName $source
  Assert ($targets.feed.entry -ne $null) ($messages.error_package_not_found -f $packageName)
  $entries = $targets.feed.entry
  if(!$pre) {
    $entries = $entries | ? {$_.properties.IsPrerelease."#text" -eq $false}
  }
  $versions = $entries | %{ (Get-VersionFromString $_.properties.version) }
  $matchingVersions = $versions | ? { Test-VersionCompatibility $versionSpec $_.Version.ToString() }
  $maxCompatibleVersion = Find-MaxVersion $matchingVersions
  return $maxCompatibleVersion
}

function Get-VersionFromArchiveName {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)] [string]$dependencyName,
    [Parameter(Position=1,Mandatory=$true)] [string]$archiveFile
  )
  $file = Split-Path -Leaf $archiveFile
  $semver = '(\d+\.\d+\.\d+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?'
  if($file -imatch "^$dependencyName\.$semver\.nupkg$" -and $matches.Keys.Count -gt 1) {
    # $matches[0] is the full file name
    # $matches[1] has the major, minor, and patch version 1.2.3
    # $matches[2] is the pre-release version 
    # $matches[3] is the build version
    $versionString = $matches[1]
    if([Version]::TryParse($versionString, [ref] $targetVersion)) {
      $targetVersion
    } else {
      $null
    }
  } else {
    $null
  }
}


function Get-VersionFromFileName {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)] [string]$dependencyName,
    [Parameter(Position=1,Mandatory=$true)] [string]$fileName
  )
  $extension = [IO.Path]::GetExtension($fileName)
  $file = Split-Path -Leaf $fileName
  $pattern = $chewie.VersionPattern

  if($file -imatch "$pattern\$extension$" -and $matches.Keys.Count -gt 1) {
    # $matches[0] is the full file name
    # $matches[1] has the major, minor, and patch version 1.2[.3][.4]
    # $matches[2] is the pre-release version 
    # $matches[3] is the build version
    $versionString = $matches[1]
    $targetVersion = $null
    if([Version]::TryParse($versionString, [ref] $targetVersion)) {
      $targetVersion
    } else {
      $null
    }
  } else {
    $null
  }
}

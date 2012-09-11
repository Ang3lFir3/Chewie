
function Get-VersionFromString {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)][string]$text,
    [Parameter(Position=1,Mandatory=$false)][switch]$isFile
  )

  $pattern = $chewie.VersionPattern
  if($isFile) { 
    $extension = [IO.Path]::GetExtension($text)
    $text = Split-Path -Leaf $text
    $pattern = "$pattern\$extension$"
  }
  if($text -imatch "$pattern" -and $matches.ContainsKey(1)) {
    # $matches[0] is the full file name
    # $matches[1] has the major, minor, and patch version 1.2[.3][.4]
    # $matches[2] is the pre-release version 
    # $matches[3] is the build version
    $versionString = $matches[1]
    if($matches.ContainsKey(2)) { $pre = $matches[2] }
    if($matches.ContainsKey(3)) { $build = $matches[3] }
    $result = New-NuGetVersion $versionString $build $pre
    return $result
  } else {
    $null
  }
}

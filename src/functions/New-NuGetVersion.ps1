
function New-NuGetVersion {
  [CmdletBinding()]  
  param(
    [Parameter(Position=0,Mandatory=$true)][string]$versionString = $null,
    [Parameter(Position=1,Mandatory=$false)][string]$build = $null,
    [Parameter(Position=2,Mandatory=$false)][string]$prerelease = $null
  )
  $targetVersion = $null
  if([Version]::TryParse($versionString, [ref] $targetVersion)) {
    $result =  New-Object PSObject |
      Add-Member -PassThru NoteProperty Version $targetVersion |
      Add-Member -PassThru NoteProperty Pre $pre |
      Add-Member -PassThru NoteProperty Build $build
    $result
  } else {
    $null
  }
}

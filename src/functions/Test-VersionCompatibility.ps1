function Test-VersionCompatibility {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)][AllowEmptyString()][string]$versionSpec,
    [Parameter(Position=1,Mandatory=$true)][string]$versionString
  )
  if([string]::IsNullOrEmpty($versionSpec)) {return true}
  if($versionSpec.StartsWith('(')) {
   $exlusiveLowerBound = $true
  }
  if($versionSpec.EndsWith(')')) {
   $exlusiveUpperBound = $true
  }
  $exactMatch = $versionSpec.StartsWith('[') -and $versionSpec.EndsWith(']') -and ($versionSpec.Contains(',') -eq $false)
  $versionSpec = $versionSpec.Trim('[',']','(',')')
  $lower,$upper = $versionSpec.Split(',')
  
  Assert (!($exlusiveLowerBound -and $exlusiveUpperBound -and [string]::IsNullOrEmpty($upper) -and ($versionSpec.Contains(',') -eq $false))) ($messages.error_invalid_version_spec -f $versionSpec)
  $current = (Get-VersionFromString $versionString).Version
  if([string]::IsNullOrEmpty($lower)) {$lower = (New-NuGetVersion "0.0").Version}
  if([string]::IsNullOrEmpty($upper)) {
    if($exactMatch) {
      $upper = $lower
    } else {
      $upper = (New-NuGetVersion "$([int]::MaxValue).$([int]::MaxValue).$([int]::MaxValue).$([int]::MaxValue)").Version
    }
  }
  
  if($exlusiveLowerBound) {
    if($exlusiveUpperBound) {
      return $lower -lt $current -and $current -lt $upper
    } else {
      return $lower -lt $current -and $current -le $upper
    }
  } else {
    if($exlusiveUpperBound) {
      return $lower -le $current -and $current -lt $upper
    } else {
      return $lower -le $current -and $current -le $upper
    }
  }
}
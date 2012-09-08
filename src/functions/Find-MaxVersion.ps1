function Find-MaxVersion {
  param(
     [Parameter(Position=0,Mandatory=$true)] [PSObject[]]$versions
  )
  if($versions -eq $null -or $versions.Length -eq 0) {
    throw "A version string must be supplied"
  }
  $max = $versions[0]
  foreach($current in $versions) {
    if($max.Version -gt $current.Version) {
      continue
    }

    if($max.Version -lt $current.Version) {
      $max = $current
      continue
    }

    # else equal, must compare pre-release with lexicographic ASCII sort order
    # we only care if the new version's pre-release is higher as everything else is the same
    if($max.Pre -lt $current.Pre) {
      $max = $current
    }
  }
  return $max
}
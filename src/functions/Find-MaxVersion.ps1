function Find-MaxVersion {
  param(
     [Parameter(Position=0,Mandatory=$true)] [PSObject[]]$versions
  )
  $max = $null
  foreach($version in $versions) {
    if(($max -eq $null) -or ($max.Version -lt $version.Version)) {
      $max = $version
      continue
    }
    if($max.Version -gt $version.Version) {
      continue;
    }
    # else equal, must compare pre-release with lexicographic ASCII sort order)
    # we only care if the new version's pre-release is higher as everything else is the same
    if($max.Pre -lt $version.Pre) {
      $max = $version
    }
  }
}
function Get-InstalledPackageVersion {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)] [string]$dependencyName
  )
  # three cases
  # 1: we have version number in folder name
  # 2: we have no idea what version we are on, we can try to 
  #      parse files (not good) or try to reinterpret the version string
  #      in the nuget file (hard)
  # 3: parse the $path folder looking for $dependencyName*.nupkg and extract the version
  #    IF, the user skips version names per folder, the nupkg files have no version (facepalm)
  #    We have to extract the nuspec from the nugpk and extract
  #    ([xml] get-content $file).package.metadata.version
  $zips = Get-ChildItem $chewie.path "$dependencyName*.nupkg" -recurse
  $versions = $zips | % {Get-VersionFromString $_ -IsFile} | ? {$_ -ne $null}
  $greatest = Fine-MaxVersion $versions
  $greatest
}

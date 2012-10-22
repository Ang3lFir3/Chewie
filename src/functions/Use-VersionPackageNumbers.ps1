function Use-VersionPackageNumbers {
  param(
    [Parameter(Position=0,Mandatory=$false)]
    [string] $value = $true
  )
  $chewie.version_packages = $value
}

Set-Alias -Name Version_Packages -Value Use-VersionPackageNumbers

Set-Alias -Name VersionPackages -Value Use-VersionPackageNumbers

Set-Alias -Name IncludeVersion -Value Use-VersionPackageNumbers

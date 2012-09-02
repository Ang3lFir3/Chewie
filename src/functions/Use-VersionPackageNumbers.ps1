function Use-VersionPackageNumbers {
  param(
    [Parameter(Position=0,Mandatory=$false)]
    [string] $value = $true
  )
  $chewie.version_packages = $value
}

New-Alias -Name Version_Packages -Scope Script -Value Use-VersionPackageNumbers

New-Alias -Name VersionPackages -Scope Script -Value Use-VersionPackageNumbers

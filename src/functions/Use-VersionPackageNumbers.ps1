function Use-VersionPackageNumbers {
  param(
    [Parameter(Position=0,Mandatory=$false)]
    [string] $value = $true
  )
  $chewie.version_packages = $value
}

Set-Alias -Name Version_Packages -Scope Script -Value Use-VersionPackageNumbers

Set-Alias -Name VersionPackages -Scope Script -Value Use-VersionPackageNumbers

Set-Alias -Name IncludeVersion -Scope Script -Value Use-VersionPackageNumbers

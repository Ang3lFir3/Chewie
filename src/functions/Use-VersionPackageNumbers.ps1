function Use-VersionPackageNumbers {
  param(
    [Parameter(Position=0,Mandatory=$false)]
    [string] $value = $true
  )
  $chewie.version_packages = $value
}

if(@(Get-Alias Version_Packages -ErrorAction SilentlyContinue).Length -eq 0) {
  New-Alias -Name Version_Packages -Scope Script -Value Use-VersionPackageNumbers
}

if(@(Get-Alias VersionPackages -ErrorAction SilentlyContinue).Length -eq 0) {
  New-Alias -Name VersionPackages -Scope Script -Value Use-VersionPackageNumbers
}

if(@(Get-Alias IncludeVersion -ErrorAction SilentlyContinue).Length -eq 0) {
  New-Alias -Name IncludeVersion -Scope Script -Value Set-PackagePath
}

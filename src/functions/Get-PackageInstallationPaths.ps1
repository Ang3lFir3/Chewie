
function Get-PackageInstallationPaths {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)] [string]$packageName
  )
  $directoryNames = @(gci $chewie.path | ? { $_.PSIsContainer } | %{ $_.FullName })
  if($directoryNames.Length -eq 0) {return @()}
  $mapping = @{}

  $directoryNames | % {
    $path = $_
    $_ = [IO.Path]::GetFileName($_)
    $version = Get-VersionFromString $_
    if($version -ne $null) {
      $_ = $_.Replace($version.Version.ToString(),"")
      if(-not [string]::IsNullOrEmpty($version.Pre)) {
        $_ = $_.Replace($version.Pre,"")
      }
      if(-not [string]::IsNullOrEmpty($version.Build)) {
        $_ = $_.Replace($version.Build,"")
      }
      $_ = $_.Trim('.', '-', '+')
    }
    $mapping.$path = $_
  } | Out-Null
  
  return @($mapping.Keys | ? {$mapping[$_] -eq $packageName})
}
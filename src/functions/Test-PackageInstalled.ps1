
function Test-PackageInstalled {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)] [string]$packageName
  )
  $directoryNames = gci $chewie.default_source | ? { $_.PSIsContainer } | %{ $_.Name }
  if($chewie.version_packages) {
    $directoryNames = $directoryNames | % {
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
      $_
    }
  }
  return (@($directoryNames | ? {$_ -eq $packageName}).Length -gt 0)
}

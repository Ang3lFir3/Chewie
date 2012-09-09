# borrowed from psake https://github.com/psake/psake/blob/master/psake.psm1
DATA messages {
convertfrom-stringdata @'
    error_invalid_package_name = package name should not be null or empty string.
    error_package_name_does_not_exist = package {0} does not exist.
    error_bad_command = Error executing command {0}.
    error_duplicate_package_name = package {0} has already been defined.
    error_nugetfile_file_not_found = Could not find the NuGetFile {0}.
    Success = Chewie Succeeded!
'@
}

Import-LocalizedData -BindingVariable messages -ErrorAction SilentlyContinue

function Load-Configuration {
  param(
    [string] $configdir = $PSScriptRoot
  )
  if(!$chewie) {
    $script:chewie = @{}
  }
  $chewie.version = "2.0.0alpha"
  $chewie.originalErrorActionPreference = $global:ErrorActionPreference
  $chewie.default_group_name = "default"
  if($nugetFile) {
    $chewie.nugetFile = $nugetFile
  } else {
    $chewie.nugetFile = ".NugetFile"
  }
  $chewie.logo = "Chewie version {0}`nCopyright (c) 2012 Eric Ridgeway, Ian Davis`n" -f $chewie.version
  $chewie.verboseError = $true
  $chewie.coloredOutput = $true
  $chewie.version_packages = $false
  $chewie.sources = (Get-PackageSources)
  $chewie.DebugPreference = "SilentlyContinue"
  $chewie.success = $false

  # Many packages don't support semver
  #$semver = '(\d+\.\d+\.\d+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?'
  # So the patch and fourth are optional :/
  #$chewie.VersionPattern = '(\d+\.\d+(?:\.\d+)?(?:\.\d+)?)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?'
  # But as also have to support NuGet's choice to ignore the - with a pre-release
  $chewie.VersionPattern = '(\d+\.\d+(?:\.\d+)?(?:\.\d+)?)(?:-?([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?'
  
  $configFilePath = (join-path $configdir "chewie-config.ps1")

  if (test-path $configFilePath -pathType Leaf) {
    try {
      . $configFilePath
    } catch {
      throw "Error Loading Configuration from chewie-config.ps1: " + $_
    }
  }
}

function Get-PackageSources {
  $packageSources = ([xml] (type "$env:AppData\NuGet\NuGet.config")).configuration.packageSources
  $sources = $packageSources | % {$_.add} | % {$set = @{}} {$set[$_.Key]=$_.Value} {$set}
  $sources
}
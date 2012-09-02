
DATA messages {
convertfrom-stringdata @'
    error_invalid_dependency_name = dependency name should not be null or empty string.
    error_dependency_name_does_not_exist = dependency {0} does not exist.
    error_circular_reference = Circular reference found for dependency {0}.
    error_missing_action_parameter = Action parameter must be specified when using PreAction or PostAction parameters for dependency {0}.
    error_corrupt_callstack = Call stack was corrupt. Expected {0}, but got {1}.
    error_invalid_framework = Invalid .NET Framework version, {0} specified.
    error_unknown_framework = Unknown .NET Framework version, {0} specified in {1}.
    error_unknown_pointersize = Unknown pointer size ({0}) returned from System.IntPtr.
    error_unknown_bitnesspart = Unknown .NET Framework bitness, {0}, specified in {1}.
    error_no_framework_install_dir_found = No .NET Framework installation directory found at {0}.
    error_bad_command = Error executing command {0}.
    error_default_dependency_cannot_have_action = 'default' dependency cannot specify an action.
    error_duplicate_dependency_name = dependency {0} has already been defined.
    error_duplicate_alias_name = Alias {0} has already been defined.
    error_invalid_include_path = Unable to include {0}. File not found.
    error_build_file_not_found = Could not find the build file {0}.
    error_no_default_dependency = 'default' dependency required.
    error_loading_module = Error loading module {0}.
    warning_deprecated_framework_variable = Warning: Using global variable $framework to set .NET framework version used is deprecated. Instead use Framework function or configuration file psake-config.ps1.
    required_variable_not_set = Variable {0} must be set to run dependency {1}.
    postcondition_failed = Postcondition failed for dependency {0}.
    precondition_was_false = Precondition was false, not executing dependency {0}.
    continue_on_error = Error in dependency {0}. {1}
    Success = Chewie Succeeded!
'@
}

Import-LocalizedData -BindingVariable messages -ErrorAction SilentlyContinue


function Load-Configuration {
  param(
    [string] $configdir = $PSScriptRoot
  )
  Write-Output "Loading config"
  if(!$chewie) {
    Write-Output "Chewie wasn't defined"
    $script:chewie = @{}
  }
  $chewie.version = "2.0.0"
  $chewie.originalErrorActionPreference = $global:ErrorActionPreference;
  #$chewie.config = Create-ConfigurationForNewContext $nugetFile
  $chewie.default_group_name = "default"
  if($nugetFile) {
    $chewie.nugetFile = $nugetFile
  } else {
    $chewie.nugetFile = ".NugetFile"
  }
  $chewie.verboseError = $true;
  $chewie.coloredOutput = $true;
  $chewie.version_packages = $false;
  $chewie.sources = (Get-PackageSources)
  $chewie.DebugPreference = "SilentlyContinue"
  $chewie.success = $false

  # Many packages don't support semver
  #$semver = '(\d+\.\d+\.\d+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?'
  # So the patch and fourth are optional :/
  #$chewie.VersionPattern = '(\d+\.\d+(?:\.\d+)?(?:\.\d+)?)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?'
  # But as also have to support NuGets choice to ignore the - with a pre-release
  $chewie.VersionPattern = '(\d+\.\d+(?:\.\d+)?(?:\.\d+)?)(?:-?([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?'
  
  $configFilePath = (join-path $configdir "chewie-config.ps1")

  if (test-path $configFilePath -pathType Leaf) {
    try {
      . $psakeConfigFilePath
    } catch {
      throw "Error Loading Configuration from psake-config.ps1: " + $_
    }
  }
}

function Get-PackageSources {
  $packageSources = ([xml] (type "$env:AppData\NuGet\NuGet.config")).configuration.packageSources
  $sources = $packageSources | % {$_.add} | % {$set = @{}} {$set[$_.Key]=$_.Value} {$set}
  $sources
}
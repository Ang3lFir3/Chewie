
function Resolve-NugetCommand {
  [CmdletBinding()]  
  param(
    [Parameter(Position=0,Mandatory=$true)][Hashtable]$package = $null
  )
  $nuGetIsInPath = @(get-command nuget.bat*,nuget.exe*,nuget.cmd* -ErrorAction SilentlyContinue).Length -gt 0
  $command = ""
  $here = "$(Split-Path -parent $script:MyInvocation.MyCommand.path)"
  $localInstall = (Join-Path $here "NuGet.exe")
  if($nuGetIsInPath) {
    $command += "NuGet install" 
  } elseif(Test-Path $localInstall) {
    $command =  $localInstall + " install"
  } else {
    Assert (@(get-command install-package -ErrorAction SilentlyContinue).Length -eq 1) $messages.error_no_valid_nuget_command_found
    $command += "install-package"  
  }
  
  $command += " $($package.name)"
  if($chewie.version_packages -ne $true){$command += " -x"}
  if(!(Test-Path $chewie.path)) { mkdir $chewie.path | Out-Null }
  $command += " -o $(Get-SafeFilePath $chewie.path)"
  $maxVersion = Get-MaxCompatibleVersion $package.Name $package.Version $package.source $package.Prerelease
  $versionString = "$maxVersion".Trim()
  if(![string]::IsNullOrEmpty($versionString)) { $command += " -version $versionString" }
  $source = $package.source
  if(![string]::IsNullOrEmpty($source)) { $command += " -source $source" }
  $command
}

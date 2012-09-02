
function Resolve-NugetCommand {
  [CmdletBinding()]  
  param(
    [Parameter(Position=0,Mandatory=$true)][Hashtable]$dependency = $null
  )
  # TODO: This is far from finished. It is a copy from chewie 0.0.8 with variable updates.
  $nuGetIsInPath = @(get-command nuget.bat*,nuget.exe*,nuget.cmd*).Length -gt 0
  $command = ""
  if($nuGetIsInPath)  {
    $command += "NuGet install" 
    if($chewie.version_packages -ne $true){$command += " -x"}
  } else {
    $command += "install-package"
  }
  $command += " $($dependency.name)"

  if(![string]::IsNullOrEmpty($version)) { $command += " -v $($dependency.version)" }
  $source = $dependency.source
  if($source -ne "") { $command += " -s $source" }
  $command
}

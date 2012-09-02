
function Resolve-Chew {
  [CmdletBinding()]  
  param(
    [Parameter(Position=0,Mandatory=$true)][string]$name = $null,
    [Parameter(Position=1,Mandatory=$false)][alias("v")][string]$version = $null,
    [Parameter(Position=2,Mandatory=$false)][switch]$prerelease,
    [Parameter(Position=3,Mandatory=$false)][string[]]$group = $null,
    #[Parameter(Position=3,Mandatory=$false,ParameterSetName="group")][string]$group = $null,
    #[Parameter(Position=3,Mandatory=$false,ParameterSetName="groups")][string[]]$groups = $null,
    [Parameter(Position=4,Mandatory=$false)][alias("s")][string]$source = $null,
    [Parameter(Position=5,Mandatory=$false)][switch]$continueOnError = $false,
    [Parameter(Position=6,Mandatory=$false)][string]$description = $null
  )
  if($group) {
    $groups = @($group)
  }
  
  if(!$groups) {
    $groups = @($chewie.default_group_name)
  }
  if(!$source) {
    $source = $chewie.default_source
  }
  $newDependency = @{
    Name = $name
    Version = $version
    Prerelease = $prerelease
    Groups = $groups
    ContinueOnError = $continueOnError
    Description = $description
    Duration = [System.TimeSpan]::Zero
    Source = $source
  }
  Write-Output $newDependency
  $dependencyKey = $name.ToLower()  
  $chewie.Dependencies
  Assert (!$chewie.Dependencies.ContainsKey($dependencyKey)) ($messages.error_duplicate_dependency_name -f $name)

  $chewie.Dependencies.$dependencyKey = $newDependency
}

New-Alias -Name Chew -Scope Script -Value Resolve-Chew

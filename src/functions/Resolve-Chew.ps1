
function Resolve-Chew {
  [CmdletBinding()]  
  param(
    [Parameter(Position=0,Mandatory=$true)][string]$name = $null,
    [Parameter(Position=1,Mandatory=$false)][alias("v")][string]$version = $null,
    [Parameter(Position=2,Mandatory=$false)][alias("group")][string[]]$groups = $null,
    [Parameter(Position=3,Mandatory=$false)][alias("s")][string]$source = $null,
    [Parameter(Position=4,Mandatory=$false)][alias("p")][switch]$prerelease = $false
  )
  if($groups -eq $null) {
    $groups = @($chewie.default_group_name)
  }

  if(!$source) {
    $source = $chewie.default_source
  }
  
  $newpackage = @{
    Name = $name
    Version = $version
    Prerelease = $prerelease
    Groups = $groups
    Duration = [System.TimeSpan]::Zero
    Source = $source
  }
  
  $packageKey = $name.ToLower()  
  
  Assert (!$chewie.Packages.ContainsKey($packageKey)) ($messages.error_duplicate_package_name -f $name)

  $chewie.Packages.$packageKey = $newpackage
}

if(@(Get-Alias Chew -ErrorAction SilentlyContinue).Length -eq 0) {
  New-Alias -Name Chew -Scope Script -Value Resolve-Chew
}

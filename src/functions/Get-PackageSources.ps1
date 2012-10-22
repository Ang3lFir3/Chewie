
function Get-PackageSources {
  $nugetConfig = "$env:AppData\NuGet\NuGet.config"
  if(!(Test-Path $nugetConfig)) {
    return @{}
  }

  $packageSources = ([xml] (type $nugetConfig)).configuration.packageSources
  $sources = $packageSources | % {$_.add} | % {$set = @{}} {if($_ -ne $null){$set[$_.Key]=$_.Value}} {$set}
  $sources
}

param($rootPath, $toolsPath, $package, $project)

function Install-Module {
  param(
    [Parameter(Position=0,Mandatory=$true)][string]$name,
    [Parameter(Position=1,Mandatory=$true)][string]$directory
  )

  $path = New-Object System.IO.DirectoryInfo(Resolve-Path $directory)
  Assert-PathExists $path
  $modulesDirectory = Get-ModulesDirectoryForCurrentUser
  Install-ModuleToPath $name $path $modulesDirectory
}

function Install-ModuleToPath {
  param(
    [Parameter(Position=0,Mandatory=$true)][string]$name,
    [Parameter(Position=1,Mandatory=$true)][IO.DirectoryInfo]$path,
    [Parameter(Position=2,Mandatory=$true)][string]$modulesPath
  )
  $targetDirectory = Join-Path $modulesDirectory $name
  Create-DirectoryIfNeeded $modulesDirectory
  Create-DirectoryIfNeeded $targetDirectory
  Copy-Item $path\* $targetDirectory -Recurse -Force 
}

function Get-ModulesDirectoryForCurrentUser {
  $modulesDirectory = Join-Path ([Environment]::GetFolderPath("MyDocuments")) WindowsPowerShell\Modules
  $modulesDirectory
}

function Create-DirectoryIfNeeded {
  param($path)
  if(!(Test-Path $path)) {
    New-Item -path $path -ItemType Directory -Force
  }
}

function Assert-PathExists {
  param($path)
  if(!(Test-Path $path)) {
    throw ("The path does not exist: $path.")
  }
}

function Remove-ItemRecurseForce {
  param($path)
  Remove-Item -Recurse -Force "$path"
}

Install-Module "Chewie" (Join-Path $toolsPath src)

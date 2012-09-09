param(
  [Parameter(Position=0,Mandatory=$false)]
  [ValidateSet('install','update', 'uninstall', 'outdated')]
  [string] $task = "install",
  [Parameter(Position=1, Mandatory=$false)]
  [string[]] $packageList = @(),
  [Parameter(Position=2,Mandatory=$false)]
  [string[]] $without = @(),
  [Parameter(Position=3,Mandatory=$false)]
  [string] $nugetFile = $null,
  [Parameter(Position=4,Mandatory=$false)]
  [switch] $docs = $false,
  [Parameter(Position=5,Mandatory=$false)]
  [switch] $nologo = $false#,
  #[Parameter(Position=6,Mandatory=$false)]
  #[switch] $debug = $false
  )

$here = (Split-Path -parent $MyInvocation.MyCommand.Definition)

$script:chewie = @{}

if ($debug) {
  $chewie.DebugPreference = "Continue"
}
 
# grab functions from files

Resolve-Path $here\functions\*.ps1 | 
    ? { -not ($_.ProviderPath.Contains(".Tests.")) } |
    % { . $_.ProviderPath }

Load-Configuration

if (-not $nologo) {
  Write-Output $chewie.logo
}

if ($docs) {
  Write-Documentation
  return
}

Invoke-Chewie $task $packageList $without

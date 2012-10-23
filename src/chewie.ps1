function chewie {
[CmdletBinding(DefaultParameterSetName='default')]
param(
  [Parameter(Position=0,Mandatory=$false,HelpMessage="You must specify which task to execute.")]
  [ValidateSet('install','update', 'uninstall', 'outdated', 'init', 'help', '?', 'convert')]
  [string] $task = "install",
  [Parameter(Position=1, Mandatory=$false)]
  [Parameter(ParameterSetName='install')]
  [Parameter(ParameterSetName='update')]
  [Parameter(ParameterSetName='uninstall')]
  [Parameter(ParameterSetName='outdated')]
  [Parameter(ParameterSetName='default')]
  [string[]] $packageList = @(),
  [Parameter(Position=2,Mandatory=$false,ParameterSetName='default')]
  [string] $path,
  [Parameter(Position=3,Mandatory=$false,ParameterSetName='default')]
  [string] $source,
  [Parameter(Position=4,Mandatory=$false,ParameterSetName='default')]
  [string] $nugetFile = $null,
  [Parameter(Position=2,Mandatory=$false,ParameterSetName='update')]
  [switch] $self,
  [Parameter(Position=2,Mandatory=$false,ParameterSetName='outdated')]
  [switch] $pre,
  [Parameter(Position=2,Mandatory=$false,ParameterSetName='convert')]
  [switch] $applyChanges,
  [Parameter(Position=4,Mandatory=$false)]
  [switch][alias("?")] $help = $false,
  [Parameter(Position=5,Mandatory=$false)]
  [switch] $nologo = $false
  )
  try {
    $here = $(Split-Path -parent $script:MyInvocation.MyCommand.path)
    Resolve-Path $here\functions\*.ps1 | % { . $_.ProviderPath }

    Load-Configuration

    if ($debug) {
      $chewie.DebugPreference = "Continue"
    }

    if (-not $nologo) {
      Write-Output $chewie.logo
    }

    if ($help -or ($task -eq "?") -or ($task -eq "-?")) {
      Write-Documentation
      return
    }
    if($nugetFile) { $chewie.nugetFile = $nugetFile }

    if($task -eq "init") {
      if(!(Test-Path $chewie.nugetFile)) {
        Write-Output "Creating $($chewie.nugetFile)"
        New-Item $chewie.nugetFile -ItemType File | Out-Null
        Add-Content $chewie.nugetFile "install_to 'lib'"
      }

      $packageList | % { Add-Content $chewie.nugetFile "chew '$_'" }
      return
    }

    if($task -eq "convert") {
      if([string]::IsNullOrEmpty($path)) {
        $path = Resolve-Path .
      }
      ConvertTo-Chewie $path $applyChanges
      return
    }

    Invoke-Chewie $task $packageList $without
  } finally {
   if(Get-Module chewie) {Remove-Module chewie -Force}
   rm function:\chewie
 }
}
function chewie {
[CmdletBinding(DefaultParameterSetName='default')]
param(
  [Parameter(ParameterSetName='install')]
  [Parameter(ParameterSetName='update')]
  [Parameter(ParameterSetName='uninstall')]
  [Parameter(ParameterSetName='outdated')]
  [Parameter(ParameterSetName='convert')]
  [Parameter(ParameterSetName='help')]
  [Parameter(ParameterSetName='default')]
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
  [Parameter(Position=0,Mandatory=$false,ParameterSetName='getnuget')]
  [switch] $downloadNuGet,
  [Parameter(Position=0,Mandatory=$false,ParameterSetName='help')]
  [switch][alias("?")] $help = $false,
  [Parameter(Position=5,Mandatory=$false)]
  [switch] $nologo = $false
  )
  $here = (Split-Path -parent $script:MyInvocation.MyCommand.path)
  
  if(!$skipFileLoading) {
    Resolve-Path $here\functions\*.ps1 | % { Write-Host "Loading $_"; . $_.ProviderPath }
  }

  Load-Configuration
  Write-Debug "Parameter Set Chosen $($PSCmdlet.ParameterSetName)"

  if ($debug) {
    $chewie.DebugPreference = "Continue"
    $chewie.verboseError = $true
  }

  if (-not $nologo) {
    Write-Output $chewie.logo
  }

  if ($help -or ($task -eq "?") -or ($task -eq "-?") -or ($task -eq "help") -or ($task -eq "-help")) {
    Write-Documentation
    return
  }

  if($downloadNuGet) {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile("https://nuget.org/nuget.exe", "$here\NuGet.exe");
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
  Write-Debug "Invoke-Chewie $task $packageList $without"
  Invoke-Chewie $task $packageList $without
}

chewie @args
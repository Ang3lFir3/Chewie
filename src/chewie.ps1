function chewie {
  [CmdletBinding()]
  param(
  [Parameter(Position=0,Mandatory=$true,ParameterSetName='install')]
  [switch] $install = $false,
  [Parameter(Position=0,Mandatory=$true,ParameterSetName='update')]
  [switch] $update = $false,
  [Parameter(Position=0,Mandatory=$true,ParameterSetName='uninstall')]
  [switch] $uninstall = $false,
  [Parameter(Position=0,Mandatory=$true,ParameterSetName='outdated')]
  [switch] $outdated = $false,
  [Parameter(Position=0,Mandatory=$true,ParameterSetName='init')]
  [switch] $init = $false,
  [Parameter(Position=0,Mandatory=$true,ParameterSetName='convert')]
  [switch] $convert = $false,
  [Parameter(Position=0,Mandatory=$true,ParameterSetName='downloadNuGet')]
  [switch] $downloadNuGet = $false,
  [Parameter(ParameterSetName='install')]
  [Parameter(ParameterSetName='update')]
  [Parameter(ParameterSetName='uninstall')]
  [Parameter(ParameterSetName='outdated')]
  [Parameter(ParameterSetName='init')]
  [AllowEmptyString()]
  [AllowNull()]
  [Parameter(Position=1,Mandatory=$false)]
  [string] $path,
  [Parameter(ParameterSetName='install')]
  [Parameter(ParameterSetName='update')]
  [Parameter(ParameterSetName='uninstall')]
  [Parameter(ParameterSetName='outdated')]
  [Parameter(ParameterSetName='init')]
  [AllowEmptyString()]
  [AllowNull()]
  [Parameter(Position=2,Mandatory=$false)]
  [string] $source,
  [Parameter(ParameterSetName='install')]
  [Parameter(ParameterSetName='update')]
  [Parameter(ParameterSetName='uninstall')]
  [Parameter(ParameterSetName='outdated')]
  [Parameter(ParameterSetName='init')]
  [AllowEmptyString()]
  [AllowNull()]
  [Parameter(Position=3,Mandatory=$false)]
  [string] $nugetFile = $null,
  [Parameter(ParameterSetName='install')]
  [Parameter(ParameterSetName='update')]
  [Parameter(ParameterSetName='uninstall')]
  [Parameter(ParameterSetName='outdated')]
  [Parameter(Position=4, Mandatory=$false)]
  [AllowEmptyString()]
  [AllowNull()]
  [string]$package = "",
  [Parameter(Position=1,Mandatory=$false,ParameterSetName='update')]
  [switch] $self,
  [Parameter(Position=1,Mandatory=$false,ParameterSetName='outdated')]
  [switch] $pre,
  [Parameter(Position=1,Mandatory=$false,ParameterSetName='convert')]
  [switch] $applyChanges,
  [Parameter(ParameterSetName='install')]
  [Parameter(ParameterSetName='update')]
  [Parameter(ParameterSetName='uninstall')]
  [Parameter(ParameterSetName='outdated')]
  [Parameter(ParameterSetName='init')]
  [Parameter(ParameterSetName='convert')]
  [Parameter(ParameterSetName='downloadNuGet')]
  [Parameter(Mandatory=$false)]
  [switch] $nologo = $false
  )
  $task = $PSCmdlet.ParameterSetName
  $here = (Split-Path -parent $script:MyInvocation.MyCommand.path)

  if(!$skipFileLoading) {
    Resolve-Path $here\functions\*.ps1 | % { Write-Host "Loading $_"; . $_.ProviderPath }
  }

  Load-Configuration
  
  if ($PSBoundParameters['Debug']) {
    $chewie.DebugPreference = "Continue"
    $chewie.verboseError = $true
    $PSBoundParameters.Keys | % { Write-ColoredOutput "$_ $($PSBoundParameters[$_])" -foregroundcolor Yellow }
    Write-ColoredOutput "Parameter Set Chosen $($PSCmdlet.ParameterSetName)" -foregroundcolor Yellow
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
    $webClient.DownloadFile("https://nuget.org/nuget.exe", (Join-Path $here "NuGet.exe"));
    return
  }

  if($nugetFile) { $chewie.nugetFile = $nugetFile }

  if($task -eq "init") {
    if(!(Test-Path $chewie.nugetFile)) {
      Write-Output "Creating $($chewie.nugetFile)"
      New-Item $chewie.nugetFile -ItemType File | Out-Null
      if($source) {
        Add-Content $chewie.nugetFile "source '$source'"
      }
      if($path) {
        Add-Content $chewie.nugetFile "install_to '$path'"
      } else {
        Add-Content $chewie.nugetFile "install_to 'lib'"
      }
      if($package) {
        Add-Content $chewie.nugetFile "chew '$package'"
      }
    }
    return
  }

  if($task -eq "convert") {
    if([string]::IsNullOrEmpty($path)) {
      $path = Resolve-Path .
    }
    ConvertTo-Chewie $path $applyChanges
    return
  }
  Write-Debug "Invoke-Chewie $task $package $without"
  Invoke-Chewie $task $package $without
}

chewie @args

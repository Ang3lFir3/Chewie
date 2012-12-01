
function Invoke-Chewie {
  param(
    [Parameter(Position=0,Mandatory=$false)]
    [ValidateSet('install','update', 'uninstall', 'outdated')]
    [string] $task = "install",
    [Parameter(Position = 1,Mandatory=$false)]
    [string[]] $packageList = @(),
    [Parameter(Position=2,Mandatory=$false)]
    [string[]] $without = @()
  )
  
  try {
    if($packageList -eq $null -or $packageList.Length -eq 0) {
      # make sure we can execute the nugetfile to set up the dependencies
      Assert (test-path $chewie.nugetFile -pathType Leaf) ($messages.error_nugetfile_file_not_found -f $chewie.nugetFile)
    }

    $chewie.success = $false
  
    $chewie.Packages = @{}
    $chewie.ExecutedDependencies = new-object System.Collections.Stack
    $chewie.callStack = new-object System.Collections.Stack
    $chewie.originalEnvPath = $env:path
    $chewie.originalDirectory = get-location
    $chewie.chews = New-Object Collections.Queue
    
    if(Test-Path $chewie.nugetFile) {
      $chewie.build_script_file = Get-Item $chewie.nugetFile
      Write-Debug "Invoke-NugetFile $($chewie.build_script_file.FullName)"
      Invoke-NugetFile $chewie.build_script_file.FullName
    }

    # Override the .NuGetFile contents for the defaults.
    if($source) { Set-Source $source }
    if($path) { Set-PackagePath $path }

    if ($packageList) {
      foreach ($package in $packageList) {
        Invoke-Chew $task $package
      }
    } elseif ($chewie.Packages) {
      foreach ($package in $chewie.Packages.Keys) {
        Invoke-Chew $task $package
      }
    } else {
      throw $messages.error_no_dependencies
    }
    $chewie.success = $true
  } catch {
    if ($chewie.verboseError) {
      $error_message = "{0}: An Error Occurred. See Error Details Below: `n" -f (Get-Date) 
      $error_message += ("-" * 70) + "`n"
      $error_message += Resolve-Error $_
      $error_message += ("-" * 70) + "`n"
      $error_message += "Script Variables" + "`n"
      $error_message += ("-" * 70) + "`n"
      $error_message += get-variable -scope script | format-table | out-string 
    } else {
      # ($_ | Out-String) gets error messages with source information included. 
      $error_message = "{0}: An Error Occurred: `n{1}" -f (Get-Date), ($_ | Out-String)
    }

    $chewie.success = $false
    
    if (!$chewie.run_by_chewie_build_tester) {
      Write-ColoredOutput $error_message -foregroundcolor Red
    }
  }
}


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
    $nugetFile = $chewie.nugetFile
    if ($nugetFile -and !(test-path $nugetFile -pathType Leaf) -and (test-path $chewie.nugetFileName -pathType Leaf)) {
      $nugetFile = $chewie.nugetFileName
    }

    # Execute the build file to set up the dependencies and defaults
    Assert (test-path $nugetFile -pathType Leaf) ($messages.error_nugetfile_file_not_found -f $nugetFile)

    $chewie.build_script_file = Get-Item $nugetFile
    $chewie.build_script_dir = $chewie.build_script_file.DirectoryName
    $chewie.success = $false
  
    #Load-Configuration $chewie.build_script_dir
  
    $chewie.Packages = @{}
    $chewie.ExecutedDependencies = new-object System.Collections.Stack
    $chewie.callStack = new-object System.Collections.Stack
    $chewie.originalEnvPath = $env:path
    $chewie.originalDirectory = get-location
    $chewie.chews = New-Object Collections.Queue

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    Invoke-NugetFile    
    
    if ($packageList) {
      foreach ($package in $packageList) {
        Write-ColoredOutput "Invoke-Chew $task $package`n" -foregroundcolor DarkGreen
        Invoke-Chew $task $package
      }
    } elseif ($chewie.Packages) {
      foreach ($package in $chewie.Packages.Keys) {
        Write-ColoredOutput "Invoke-Chew $task $package`n" -foregroundcolor DarkGreen
        Invoke-Chew $task $package
      }
    } else {
      throw $messages.error_no_dependencies
    }
    
    Write-ColoredOutput ("`n" + $messages.Success + "`n") -foregroundcolor Green
    
    Write-TimeSummary $stopwatch.Elapsed
    
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

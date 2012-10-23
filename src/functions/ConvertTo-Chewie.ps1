
function ConvertTo-Chewie {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)]
    [string] $targetDirectory = $null,
    [Parameter(Position=1,Mandatory=$false)]
    [bool] $applyChanges = $false
  )
  if(Test-Path $chewie.nugetFile) {
    Write-ColoredOutput "A NuGetFile already exists. Skipping conversion."  -foregroundcolor DarkGreen
    return
  }

  $repoFileName = ls (Join-Path $targetDirectory *) -recurse -include repositories.config | % { $_.FullName } | Select -first 1
  if($repoFileName) {
    $repoDirectory = Split-Path -Parent $repoFileName
    [xml]$repoFile = Get-Content $repoFileName
    $respositoryFiles = $repoFile.repositories.repository.path | % {
      resolve-path (join-path $repoDirectory $_)
    } | ? { Test-Path $_ }
  }

  if(!$respositoryFiles) {
    # no repositories.config file, or corrupted/emtpy
    $respositoryFiles = ls (Join-Path $targetDirectory *) -recurse -include packages.config | % { $_.FullName }
  }

  if(!$respositoryFiles -or $respositoryFiles.Length -eq 0) {
    Write-ColoredOutput  "There were no packages in this project to convert." -foregroundcolor DarkGreen
    Write-ColoredOutput  "Please execute 'chewie init to generate a template .NuGetFile" -foregroundcolor DarkGreen
    return
  }

  $packages = $respositoryFiles | % { [xml] (Get-Content $_) } | % {$_.packages.package} | % {
    $instance = @{Id=$_.id; Version = $_.version; AllowedVersions = $_.allowedVersions}
    $instance
  } | % {$ids = @{}} {
    $current = $ids.($_.id)
    if($current) {
      if(!$current.allowedVersions -and $_.allowedVersions -ne $null) {
        $current.allowedVersions = $_.allowedVersions
      }
    } else {
      $ids.($_.id) = $_
    }
  } {$ids.Values}

  $packages | ? { $_.allowedVersions } | % { $_.version = $_.allowedVersions }

  Write-ColoredOutput "Creating $($chewie.nugetFile)"  -foregroundcolor DarkGreen
  New-Item $chewie.nugetFile -ItemType File | Out-Null
  Add-Content $chewie.nugetFile "install_to 'lib'"
  Add-Content $chewie.nugetFile "IncludeVersion"
    
  $packages | % { 
    $content = "chew '$($_.id)'"
    if($_.version) {
      $content += " '$($_.version)'"
    }
    Add-Content $chewie.nugetFile $content
  }

  $projectFiles = ls (Join-Path $targetDirectory *) -recurse -include *.csproj,*.vbproj,*.fsproj | % { $_.FullName }
  $projectFilesWithPackageRestore = $projectFiles | % {$restoreInfo = @{}} {
    $fileName = $_
    $content = Get-Content $fileName
    $matches = Select-String "nuget.targets" $fileName
    if($matches) {
      $restoreInfo.$fileName = $matches | Select LineNumber,Line | Add-Member -Type NoteProperty -Name "FileName" -Value $fileName -passthru
    }
  } {$restoreInfo}

  $nugetCommandlinePath = Join-Path $targetDirectory .nuget
  if(Test-Path $nugetCommandlinePath) {
    if($applyChanges){
      Write-ColoredOutput "Deleting .nuget folder: $nugetCommandlinePath" -foregroundcolor Magenta
      Remove-Item -Recurse -Force $nugetCommandlinePath -ErrorAction Continue
    } else{
      Write-ColoredOutput "Please delete the .nuget folder" -foregroundcolor Yellow
    }
  }
  if($repoFileName) {
    if($applyChanges){
      Write-ColoredOutput "Deleting the package repository file $repoFileName." -foregroundcolor Magenta
      Remove-Item -Force $repoFileName -ErrorAction Continue
    } else{
      Write-ColoredOutput "Please delete the package repository file $repoFileName." -foregroundcolor Yellow
    }
  }
  if($respositoryFiles) {
    $respositoryFiles | % {
      if($applyChanges){
        Write-ColoredOutput "Deleting the package config file: $_" -foregroundcolor Magenta
        Remove-Item -Force $_ -ErrorAction Continue
      } else{
        Write-ColoredOutput "Please delete the package config file: $_." -foregroundcolor Yellow
      }
    }
  }
  if($projectFilesWithPackageRestore -ne $null -and $projectFilesWithPackageRestore.Length -gt 0) {
    $projectFilesWithPackageRestore.Keys | % {
      $_ = $projectFilesWithPackageRestore.$_
      if($applyChanges){
        Write-ColoredOutput "Removing NuGet package restore import from project file $($_.FileName)" -foregroundcolor Magenta
        [xml]$xml = Get-Content $_.FileName
        $importNodes = $xml.SelectNodes('//*[local-name()="Import"]')
        $nugetNode = $importNodes | ? {$_.Project.contains("nuget.targets")} | Select -First 1
        $nugetNode.ParentNode.RemoveChild($nugetNode)
        $xml.Save($_.FileName)
      } else{
        Write-ColoredOutput "Please delete the nuget target in project file $($_.FileName)." -foregroundcolor Yellow
        Write-ColoredOutput "`tLine Number $($_.LineNumber): $($_.Line)." -foregroundcolor Yellow
      }
    }
  }
}

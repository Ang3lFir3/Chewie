properties {
  $rootDir = Resolve-Path .
  $binDir = "$rootDir\bin"
  $srcDir = "$rootDir\src"
  $toolsDir = "$binDir\tools"
  $testDir = "$rootDir\src\tests"
  $pesterModule = @(Get-ChildItem $rootDir\* -recurse -include pester.psm1)
}

Task Default -Depends Test
Task Package -Depends Clean,Coalesce,CreateNuGetPackage

Task Clean {
  if(Test-Path $binDir) {
    Remove-Item -Recurse -Force $binDir
  }
}

Task Test {
  try {
    Import-Module $pesterModule
    Invoke-Pester $testDir
    # To test a single set of specs
    #Invoke-Pester $rootDir\src\tests\CLI.Tests.ps1
  } finally {
    Remove-Module [p]ester -Force
  }
}

Task CreateNuGetPackage {
  #& $rootDir\NuGetPackageBuilder.cmd
  Copy-Item "$rootDir\nuget\*" $binDir
  Copy-Item "$rootDir\chocolateyInstall.ps1" $toolsDir
  & nuget pack $binDir\Chewie.nuspec
}

Task DeployLocal -depends Package,TestChocolatey

Task TestChocolatey {
  $target = Get-Item $env:ChocolateyInstall\lib\Chewie*
  if(Test-Path $target.FullName) {
    Remove-Item -Recurse -Force $target.FullName
  }
  cinst chewie -force -source "$pwd"
}

Task Coalesce {
  $items = Resolve-Path $srcDir\functions\*.ps1 | % { $_.ProviderPath }
  $items += Resolve-Path $srcDir\chewie.ps1
  if(!(Test-Path $toolsDir)) { 
    mkdir $toolsDir | Out-Null
  }
  $content = $items | Get-ChildItem | Get-Content
  $content = @('$script:skipFileLoading = $true',"`n") + $content
  $content | Out-File -FilePath "$toolsDir\chewie.ps1" -Encoding unicode
}

Task ? {
 Write-Documentation
}
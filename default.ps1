properties {
  $rootDir = Resolve-Path .
}

Task Default -Depends Test
Task Package -Depends CreateNuGetPackage

Task Test {
  $pesterModule = @(Get-ChildItem $rootDir\* -recurse -include pester.psm1)
  Import-Module $pesterModule
  Invoke-Pester $rootDir\src\tests
}

Task CreateNuGetPackage {
  & $rootDir\NuGetPackageBuilder.cmd
}

Task TestChocolateyPackageInstallation {
  cinst chewie -source "$pwd"
}

Task ? {
 Write-Documentation
}
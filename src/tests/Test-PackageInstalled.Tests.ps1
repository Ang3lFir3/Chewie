$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -ireplace ".tests.", "."
#. "$here\_Common.ps1"
. "$here\..\functions\$sut"
. "$here\..\functions\Assert-Condition.ps1"
. "$here\..\functions\Get-VersionFromString.ps1"
. "$here\..\functions\New-NuGetVersion.ps1"
. "$here\..\functions\Get-PackageInstallationPaths.ps1"

Describe "Ensure-InstalledPackagesCanBeFoundWhenNoVersionInformationIsGiven" {
  . "$here\_Common.ps1"
  $chewie.path = "TestDrive:"
  Setup -Dir "Ninject"
  It "should find the package" {
    (Test-PackageInstalled "Ninject").should.be("true")
  }
  Cleanup
}

Describe "Ensure-InstalledPackagesCanBeFoundWhenASimpleVersionIsGiven" {
  . "$here\_Common.ps1"
  $chewie.path = "TestDrive:\"
  Setup -Dir "Ninject.2.3"
  It "should find the package" {
    (Test-PackageInstalled "Ninject").should.be("true")
  }
  Cleanup
}

Describe "Ensure-InstalledPackagesCanBeFoundWhenVersionWithDashedPrereleaseIsGiven" {
  . "$here\_Common.ps1"
  $chewie.path = "TestDrive:\"
  Setup -Dir "Ninject.2.3-alpha"
  It "should find the package" {
    (Test-PackageInstalled "Ninject").should.be("true")
  }
  Cleanup
}

Describe "Ensure-InstalledPackagesCanBeFoundWhenVersionWithPrereleaseIsGiven" {
  . "$here\_Common.ps1"
  $chewie.path = "TestDrive:\"
  Setup -Dir "Ninject.2.3alpha"
  It "should find the package" {
    (Test-PackageInstalled "Ninject").should.be("true")
  }
  Cleanup
}

Describe "Ensure-InstalledPackagesCanBeFoundWhenVersionWithBuildIsGiven" {
  . "$here\_Common.ps1"
  $chewie.path = "TestDrive:\"
  Setup -Dir "Ninject.2.3+1.0"
  It "should find the package" {
    (Test-PackageInstalled "Ninject").should.be("true")
  }
  Cleanup
}
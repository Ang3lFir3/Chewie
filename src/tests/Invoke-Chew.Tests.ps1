$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -ireplace ".tests.", "."
#. "$here\_Common.ps1"
. "$here\..\functions\$sut"
. "$here\..\functions\Assert-Condition.ps1"

function Setup-LibFolder {
  Setup -Dir base\lib
  $chewie.path = "TestDrive:\base\lib"
}

function Setup-NuGetFile {
  param($content)
  Set-Content -Path "TestDrive:\base\.NuGetFile" $content
  
  Invoke-NuGetFile "TestDrive:\base\.NuGetFile"
}

function Install-Ninject {
  param($version = "[2.1.0.76]")
  Setup-LibFolder
  Setup-NugetFile "chew 'ninject' '$version'"
  Invoke-Chew install ninject 
  #clear that this was processed so that we can execute followup requests
  $chewie.ExecutedDependencies.Clear()
}

Describe "Ensure-PackagesInstallCorrectly" {
  . "$here\_Common.ps1"
  Install-Ninject
  It "should Install packages to the correct location" {
    (Test-Path "TestDrive:\base\lib\ninject").should.be($true)
  }
  Cleanup
}

Describe "Ensure-PackagesAreRemovedCorrectly" {
  . "$here\_Common.ps1"
  Install-Ninject
  Invoke-Chew uninstall ninject
  It "should uninstall package folders" {
    (Test-Path "TestDrive:\base\lib\ninject").should.be($false)
  }
  Cleanup
}

Describe "Ensure-PackagesAreUpdatedCorrectly" {
  . "$here\_Common.ps1"
  Install-Ninject
  . "$here\_Common.ps1"
  Setup-NuGetFile "chew 'ninject' '[2.1.0.76,2.2.1.4]'"
  Invoke-Chew update ninject
  It "should update package when compatible version is available" {
    (Get-InstalledPackageVersion ninject).Version.ToString().should.be("2.2.1.4")
  }
  Cleanup
}

Describe "Ensure-PackagesAreUpdatedCorrectly" {
  . "$here\_Common.ps1"
  Install-Ninject
  . "$here\_Common.ps1"
  Setup-NuGetFile "chew 'ninject' '[2.1.0.76]'"
  Invoke-Chew update ninject
  It "should not update package when no compatible version is available" {
    (Get-InstalledPackageVersion ninject).Version.ToString().should.be("2.1.0.76")
  }
  Cleanup
}

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -ireplace ".tests.", "."
#. "$here\_Common.ps1"
. "$here\..\functions\$sut"
. "$here\..\functions\Assert-Condition.ps1"


Describe "Ensure-PackageVersionNumbersCanBeEnabled" {
  . "$here\_Common.ps1"
  It "should be off by default" {
    $chewie.version_packages.should.be($false)
  }
  It "should be turned on with Use-VersionPackageNumbers" {
    $chewie.version_packages = $false
    Use-VersionPackageNumbers
    $chewie.version_packages.should.be($true)
  }
  It "should be turned on with Version_Packages" {
    $chewie.version_packages = $false
    Version_Packages
    $chewie.version_packages.should.be($true)
  }
  It "should be turned on with VersionPackages" {
    $chewie.version_packages = $false
    VersionPackages
    $chewie.version_packages.should.be($true)
  }
}

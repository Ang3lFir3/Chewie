$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -ireplace ".tests.", "."
#. "$here\_Common.ps1"
. "$here\..\functions\$sut"
. "$here\..\functions\Resolve-Chew.ps1"
. "$here\..\functions\Assert-Condition.ps1"
. "$here\..\functions\New-NuGetVersion.ps1"
. "$here\..\functions\Get-VersionFromString.ps1"


Describe "Ensure-PreReleaseBuildsSort" {
  . "$here\_Common.ps1"
  It "should match on version before prerelease" {
    (Find-MaxVersion @((Get-VersionFromString "1.2alpha1"),(Get-VersionFromString "1.1alpha2"),(Get-VersionFromString "1.0alpha3"))).Pre.should.be("alpha1")
  }
  It "should match on prerelease after version" {
    (Find-MaxVersion @((Get-VersionFromString "1.0alpha1"),(Get-VersionFromString "1.0alpha2"),(Get-VersionFromString "1.0alpha3"))).Pre.should.be("alpha3")
  }
  It "should match on prerelease after version" {
    (Find-MaxVersion @((Get-VersionFromString "1.0beta1"),(Get-VersionFromString "1.0alpha2"),(Get-VersionFromString "1.0alpha3"))).Pre.should.be("beta1")
  }
  It "should not be effected by extra version numbers" {
    (Find-MaxVersion @((Get-VersionFromString "1.0beta1"),(Get-VersionFromString "1.0alpha2"),(Get-VersionFromString "1.0alpha3"))).Pre.should.be("beta1")
  }
}

Describe "Ensure-Version number short on all digits" {
  . "$here\_Common.ps1"
  It "should match on version numbers" {
    (Find-MaxVersion @((Get-VersionFromString "1.2"),(Get-VersionFromString "1.5"),(Get-VersionFromString "1.0"))).Version.ToString().should.be("1.5")
  }
  It "should increase version number on adding specific" {
    (Find-MaxVersion @((Get-VersionFromString "1.0"),(Get-VersionFromString "1.0.0"),(Get-VersionFromString "1.0.0.0"))).Version.should.be("1.0.0.0")
  }
}


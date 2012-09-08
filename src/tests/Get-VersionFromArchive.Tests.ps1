$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -ireplace ".tests.", "."
#. "$here\_Common.ps1"
. "$here\..\functions\$sut"
. "$here\..\functions\Assert-Condition.ps1"
. "$here\..\functions\New-NuGetVersion.ps1"
. "$here\..\functions\Get-VersionFromString.ps1"

Describe "Ensure-VersionCanBeParsedFromArchiveFiles" {
  . "$here\_Common.ps1"
  It "should pull the version from the file name" {
    (Get-VersionFromArchive "Pester" (Resolve-Path "$here\packages\Pester.1.0.1.nupkg")).Version.ToString().should.be("1.0.1")
  }
  It "should pull the version from the spec file in the archive" {
    (Get-VersionFromArchive "Pester" (Resolve-Path "$here\packages\Pester.nupkg")).Version.ToString().should.be("1.0.1")
  }
}

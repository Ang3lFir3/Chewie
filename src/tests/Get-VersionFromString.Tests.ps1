$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -ireplace ".tests.", "."
. "$here\_Common.ps1"
. "$here\..\functions\$sut"


Describe "Ensure-VersionsAreParsedFromFileNames" {
  It "should return null if no version is present" {
    $result = Get-VersionFromString "ninject.zip" -IsFile
    ($result -eq $null).should.be($true)
  }
  It "should return versions with major and minor specified" {
    $result = Get-VersionFromString "ninject.1.2.zip" -IsFile
    $result.Version.should.be((new-object Version "1", "2"))
  }
  It "should return versions with major and minor and patch specified" {
    $result = Get-VersionFromString "ninject.1.2.3.zip" -IsFile
    $result.Version.should.be((new-object Version "1", "2", "3"))
  }
  It "should return versions with major and minor and patch, and build specified" {
    $result = Get-VersionFromString "ninject.1.2.3.4.zip" -IsFile
    $result.Version.should.be((new-object Version "1", "2", "3", "4"))
  }
  It "should return versions from pre-release files" {
    $files = @("ninject.1.0.0-alpha.zip", "ninject.1.0.0-alpha.1.zip", "ninject.1.0.0-0.3.7.zip", "ninject.1.0.0-x.7.z.92.zip")
    $results = $files | % { Get-VersionFromString $_ -IsFile}
    $results.Count.should.be(4)
    $results | % {$_.Version.should.be((new-object Version "1", "0", "0")) }
    $results[0].Pre.should.be("alpha")
    $results[1].Pre.should.be("alpha.1")
    $results[2].Pre.should.be("0.3.7")
    $results[3].Pre.should.be("x.7.z.92")
  }
  It "should return versions from build versioned files" {
    $files = @("ninject.1.3.7+build.1.zip", "ninject.1.3.7+build.11.e0f985a.zip")
    $results = $files | % { Get-VersionFromString $_ -IsFile}
    $results.Count.should.be(2)
    $results | % {$_.Version.should.be((new-object Version "1", "3", "7")) }
    $results[0].Build.should.be("build.1")
    $results[1].Build.should.be("build.11.e0f985a")
  }
  It "should return versions from nuget style pre-releases" {
    $files = @("ninject.1.3.7alpha1.zip", "ninject.1.3.7beta1.zip")
    $results = $files | % { Get-VersionFromString $_ -IsFile}
    $results.Count.should.be(2)
    $results | % {$_.Version.should.be((new-object Version "1", "3", "7")) }
    $results[0].Pre.should.be("alpha1")
    $results[1].Pre.should.be("beta1")
  }
}


$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -ireplace ".tests.", "."
. "$here\_Common.ps1"
. "$here\..\functions\$sut"

[xml]$ninject = Get-PackageList "Ninject"

Describe "Ensure-FeedIsQueriedProperlyForPackages" {

  It "should not be null" {
    ($ninject -eq $null).should.be($false)
  }
  It "should not have a null feed" {
    ($ninject.feed -eq $null).should.be($false)
  }
  It "should have many entries in the feed" {
    ($ninject.feed.entry.Length -gt 1).should.be($true)
  }
  It "should have all entries with the correct title" {
    ($ninject.feed.entry | %{ $_.title."#text" -eq "Ninject"}).should.be($true)
  }
}

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -ireplace ".tests.", "."
#. "$here\_Common.ps1"
. "$here\..\functions\$sut"
. "$here\..\functions\Assert-Condition.ps1"


Describe "Ensure-AssertionsAreInvoked" {
  . "$here\_Common.ps1"
  It "should have an alias for Assert" {
    @(get-alias Assert).Length.should.be(1)
  }
  It "should not throw when given a true value" {
    Assert $true ""
  }
  It "should not throw when given a false value" {
    try{$value = Assert $false "chew failed"}catch{$err = $_.Exception.Message}
    $err.should.be("Assert: chew failed")
  }
}

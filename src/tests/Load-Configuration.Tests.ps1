$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -ireplace ".tests.", "."
#. "$here\_Common.ps1"
. "$here\..\functions\$sut"
. "$here\..\functions\Assert-Condition.ps1"


#Describe "Ensure-" {
#  . "$here\_Common.ps1"
#  It "should " {
#    $pwd.should.be("default")
#  }
#}

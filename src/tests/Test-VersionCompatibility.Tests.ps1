$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -ireplace ".tests.", "."
. "$here\_Common.ps1"
. "$here\..\functions\$sut"
. "$here\..\functions\Assert-Condition.ps1"
. "$here\..\functions\New-NuGetVersion.ps1"
. "$here\..\functions\Get-VersionFromString.ps1"

Describe "Ensure-1.0 matches appropriately" {
  . "$here\_Common.ps1"
  $versionSpec = "1.0"
  It "should exclude versions less $versionSpec" {
    (Test-VersionCompatibility $versionSpec "0.9").should.be($false)
  }
  It "should include versions equal to $versionSpec" {
    (Test-VersionCompatibility $versionSpec "1.0").should.be($true)
  }
  It "should include versions greater than $versionSpec" {
    (Test-VersionCompatibility $versionSpec "1.1").should.be($true)
  }
}

Describe "Ensure-(,1.0] matches appropriately" {
  . "$here\_Common.ps1"
  $versionSpec = "(,1.0]"
  It "should include versions less than $versionSpec" {
    (Test-VersionCompatibility $versionSpec "0.9").should.be($true)
  }
  It "should include versions equal to $versionSpec" {
    (Test-VersionCompatibility $versionSpec "1.0").should.be($true)
  }
  It "should exclude versions greater than $versionSpec" {
    (Test-VersionCompatibility $versionSpec "1.1").should.be($false)
  }
}

Describe "Ensure-(,1.0) matches appropriately" {
  . "$here\_Common.ps1"
  $versionSpec = "(,1.0)"
  It "should include versions less than $versionSpec" {
    (Test-VersionCompatibility $versionSpec "0.9").should.be($true)
  }
  It "should exclude versions equal to $versionSpec" {
    (Test-VersionCompatibility $versionSpec "1.0").should.be($false)
  }
  It "should exclude versions greater than $versionSpec" {
    (Test-VersionCompatibility $versionSpec "1.1").should.be($false)
  }
}

Describe "Ensure-[1.0] matches appropriately" {
  . "$here\_Common.ps1"
  $versionSpec = "[1.0]"
  It "should exclude versions less than $versionSpec" {
    (Test-VersionCompatibility $versionSpec "0.9").should.be($false)
  }
  It "should include versions equal to $versionSpec" {
    (Test-VersionCompatibility $versionSpec "1.0").should.be($true)
  }
  It "should exclude versions greater than $versionSpec" {
    (Test-VersionCompatibility $versionSpec "1.1").should.be($false)
  }
}

Describe "Ensure-(1.0) matches appropriately" {
  . "$here\_Common.ps1"
  $versionSpec = "(1.0)"
  It "should include versions less than $versionSpec" {
    $error = $null
    try{(Test-VersionCompatibility $versionSpec "0.9")}catch{$error = $_}
    ($error -eq $null).should.be($false)
  }
}

Describe "Ensure-(1.0,) matches appropriately" {
  . "$here\_Common.ps1"
  $versionSpec = "(1.0,)"
  It "should exclude versions less than $versionSpec" {
    (Test-VersionCompatibility $versionSpec "0.9").should.be($false)
  }
  It "should exclude versions equal to $versionSpec" {
    (Test-VersionCompatibility $versionSpec "1.0").should.be($false)
  }
  It "should include versions greater than $versionSpec" {
    (Test-VersionCompatibility $versionSpec "1.1").should.be($true)
  }
}

Describe "Ensure-(1.0,2.0) matches appropriately" {
  . "$here\_Common.ps1"
  $versionSpec = "(1.0,2.0)"
  It "should exclude versions less than $versionSpec lower bound" {
    (Test-VersionCompatibility $versionSpec "0.9").should.be($false)
  }
  It "should exclude versions equal to $versionSpec lower bound" {
    (Test-VersionCompatibility $versionSpec "1.0").should.be($false)
  }
  It "should include versions greater than $versionSpec lower bound and less than $versionSpec upper bound" {
    (Test-VersionCompatibility $versionSpec "1.1").should.be($true)
  }
  It "should exclude versions equal to $versionSpec upper bound" {
    (Test-VersionCompatibility $versionSpec "2.0").should.be($false)
  }
  It "should exclude versions greater than upper bound" {
    (Test-VersionCompatibility $versionSpec "2.1").should.be($false)
  }
}

Describe "Ensure-(1.0,2.0] matches appropriately" {
  . "$here\_Common.ps1"
  $versionSpec = "(1.0,2.0]"
  It "should exclude versions less than $versionSpec lower bound" {
    (Test-VersionCompatibility $versionSpec "0.9").should.be($false)
  }
  It "should exclude versions equal to $versionSpec lower bound" {
    (Test-VersionCompatibility $versionSpec "1.0").should.be($false)
  }
  It "should include versions greater than $versionSpec lower bound and less than $versionSpec upper bound" {
    (Test-VersionCompatibility $versionSpec "1.1").should.be($true)
  }
  It "should include versions equal to $versionSpec upper bound" {
    (Test-VersionCompatibility $versionSpec "2.0").should.be($true)
  }
  It "should exclude versions greater than upper bound" {
    (Test-VersionCompatibility $versionSpec "2.1").should.be($false)
  }
}

Describe "Ensure-[1.0,2.0) matches appropriately" {
  . "$here\_Common.ps1"
  $versionSpec = "[1.0,2.0)"
  It "should exclude versions less than $versionSpec lower bound" {
    (Test-VersionCompatibility $versionSpec "0.9").should.be($false)
  }
  It "should include versions equal to $versionSpec lower bound" {
    (Test-VersionCompatibility $versionSpec "1.0").should.be($true)
  }
  It "should include versions greater than $versionSpec lower bound and less than $versionSpec upper bound" {
    (Test-VersionCompatibility $versionSpec "1.1").should.be($true)
  }
  It "should exclude versions equal to $versionSpec upper bound" {
    (Test-VersionCompatibility $versionSpec "2.0").should.be($false)
  }
  It "should exclude versions greater than upper bound" {
    (Test-VersionCompatibility $versionSpec "2.1").should.be($false)
  }
}

Describe "Ensure-[1.0,2.0] matches appropriately" {
  . "$here\_Common.ps1"
  $versionSpec = "[1.0,2.0]"
  It "should exclude versions less than $versionSpec lower bound" {
    (Test-VersionCompatibility $versionSpec "0.9").should.be($false)
  }
  It "should include versions equal to $versionSpec lower bound" {
    (Test-VersionCompatibility $versionSpec "1.0").should.be($true)
  }
  It "should include versions greater than $versionSpec lower bound and less than $versionSpec upper bound" {
    (Test-VersionCompatibility $versionSpec "1.1").should.be($true)
  }
  It "should include versions equal to $versionSpec upper bound" {
    (Test-VersionCompatibility $versionSpec "2.0").should.be($true)
  }
  It "should exclude versions greater than upper bound" {
    (Test-VersionCompatibility $versionSpec "2.1").should.be($false)
  }
}
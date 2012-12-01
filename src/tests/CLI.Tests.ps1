<#
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -ireplace ".tests.", "."
#. "$here\_Common.ps1"

function chewie {
  . $here\..\chewie.ps1 $args
}

function Invoke-TestInTempFolder {
  param([scriptblock] $block)
  $dirname = "temp." + [Guid]::NewGuid().ToString("B")
  Setup -Dir -Path $dirname
  try {
    In "TestDrive:\$dirname" {
      & $block
    }
  } finally {
    Cleanup
  }
}

Describe "Init" {
  It "should create a nugetfile" {
    Invoke-TestInTempFolder {
      chewie init
      (Test-Path .NuGetfile).should.be($true)
    }
  }
  It "should create a nugetfile2" {
    Invoke-TestInTempFolder {
      chewie init
      (Test-Path .NuGetfile).should.be($false)
    }
  }
  It "should create a nugetfile3" {
    Invoke-TestInTempFolder {
      chewie init
      (Test-Path .NuGetfile).should.be($false)
    }
  }
  It "should cleanup" {
    Cleanup
  }
}
#>
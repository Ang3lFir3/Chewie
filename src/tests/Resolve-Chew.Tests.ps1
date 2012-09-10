$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -ireplace ".tests.", "."
. "$here\..\functions\$sut"
. "$here\..\functions\Assert-Condition.ps1"
. "$here\..\functions\New-Group.ps1"

Describe "Ensure-PackagesDefaultsAreResolvedCorrectly" {
  . "$here\_Common.ps1"
  chew "ninject"
  It "should use the package name for the package key" {
    $chewie.Packages.ContainsKey("ninject").should.be($true)
  }
  It "should use the package name for the package name" {
    $chewie.Packages["ninject"].Name.should.be("ninject")
  }
  It "should use a null version if none is specified" {
    [string]::IsNullOrEmpty($chewie.Packages["ninject"].Version).should.be($true)
  }
  It "should use a false prerelease if none is specified" {
    $chewie.Packages["ninject"].Prerelease.should.be($false)
  }
  It "should assign a group if none is specified" {
    $chewie.Packages["ninject"].Groups.Count.should.be(1)
  }
  It "should use a default group if none is specified" {
    $chewie.Packages["ninject"].Groups[0].should.be("default")
  }
  It "should use a 0 timespan" {
    $chewie.Packages["ninject"].Duration.should.be([TimeSpan]::Zero)
  }
  It "should use the default source if none is specified" {
    [string]::IsNullOrEmpty($chewie.Packages["ninject"].Source).should.be($true)
  }
}

Describe "Ensure-PackagesAreVersionedWhenPassedTheParameter" {
  It "should use the version when specified normally" {
    . "$here\_Common.ps1"
    chew "ninject" "3.2.1"
    $chewie.Packages["ninject"].Version.should.be("3.2.1")
  }
  It "should use the version when passed as a named parameter" {
    . "$here\_Common.ps1"
    chew "ninject" -version "3.2.1"
    $chewie.Packages["ninject"].Version.should.be("3.2.1")
  }
  It "should use the version when passed as a named parameter alias" {
    . "$here\_Common.ps1"
    chew "ninject" -v "3.2.1"
    $chewie.Packages["ninject"].Version.should.be("3.2.1")
  }
}

Describe "Ensure-PackagesAreSourcedWhenPassedTheParameter" {
  $value = "http://my.nuget.server.org"
  It "should use the source when specified normally" {
    . "$here\_Common.ps1"  
    chew "ninject" "3.2.1" "default" $value
    $chewie.Packages["ninject"].Source.should.be($value)
  }
  It "should use the source when passed as a named parameter" {
    . "$here\_Common.ps1"
    chew "ninject" -source $value
    $chewie.Packages["ninject"].Source.should.be($value)
  }
  It "should use the source when passed as a named parameter alias" {
    . "$here\_Common.ps1"
    chew "ninject" -s $value
    $chewie.Packages["ninject"].Source.should.be($value)
  }
}

Describe "Ensure-PackagesAreSourcedWhenPassedTheParameter" {
  $value = "all"
  It "should use the group when specified normally" {
    . "$here\_Common.ps1"  
    chew "ninject" "3.2.1" $value
    $chewie.Packages["ninject"].Groups[0].should.be($value)
  }
  It "should use the group when passed normally with a collection of groups" {
    . "$here\_Common.ps1"
    chew "ninject" -groups $value,"another"
    $chewie.Packages["ninject"].Groups[0].should.be($value)
  }
  It "should use the second group when specified normally" {
    . "$here\_Common.ps1"
    chew "ninject" "3.2.1" $value,"another"
    $chewie.Packages["ninject"].Groups[1].should.be("another")
  }
  It "should use the group when passed as a named parameter" {
    . "$here\_Common.ps1"
    chew "ninject" -group $value
    $chewie.Packages["ninject"].Groups[0].should.be($value)
  }
  It "should use the group when passed as a named parameter" {
    . "$here\_Common.ps1"
    chew "ninject" -groups $value
    $chewie.Packages["ninject"].Groups[0].should.be($value)
  }
  It "should use the group when passed as a named parameter alias groups" {
    . "$here\_Common.ps1"
    chew "ninject" -groups $value,"another"
    $chewie.Packages["ninject"].Groups[0].should.be($value)
  }
  It "should use the second group when passed as a named parameter" {
    . "$here\_Common.ps1"
    chew "ninject" -groups $value,"another"
    $chewie.Packages["ninject"].Groups[1].should.be("another")
  }
  It "should use the source when passed as a named parameter alias g" {
    . "$here\_Common.ps1"
    chew "ninject" -g $value
    $chewie.Packages["ninject"].Groups[0].should.be($value)
  }
}


Describe "Ensure-PackagesAreMarkedToSupportPrereleasesWhenPassedTheParameter" {
  It "should use the Prerelease when specified normally" {
    . "$here\_Common.ps1"  
    chew "ninject" "3.2.1" "default" "someUrl" $true
    $chewie.Packages["ninject"].Prerelease.should.be($true)
  }
  It "should use the Prerelease when passed as a named parameter" {
    . "$here\_Common.ps1"
    chew "ninject" -prerelease
    $chewie.Packages["ninject"].Prerelease.should.be($true)
  }
  It "should use the Prerelease when passed as a named parameter alias" {
    . "$here\_Common.ps1"
    chew "ninject" -p
    $chewie.Packages["ninject"].Prerelease.should.be($true)
  }
}

Describe "Ensure-PackagesCanOnlyBeSpecifiedOnce" {
  It "should throw when chewed twice" {
    . "$here\_Common.ps1"  
    chew "ninject"
    $error = $null
    try{chew "ninject"}catch{$error = $_}
    ($error -eq $null).should.be($false)
  }
  It "should throw when chewed and grouped" {
    . "$here\_Common.ps1"  
    New-Group "foo" { chew "ninject" }
    $error = $null
    try{chew "ninject"}catch{$error = $_}
    ($error -eq $null).should.be($false)
  }
}

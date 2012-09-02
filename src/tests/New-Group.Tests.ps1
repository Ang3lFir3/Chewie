$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -ireplace ".tests.", "."
#. "$here\_Common.ps1"
. "$here\..\functions\$sut"
. "$here\..\functions\Resolve-Chew.ps1"
. "$here\..\functions\Assert-Condition.ps1"


Describe "Ensure-UngroupedItemsAreGrouped" {
  . "$here\_Common.ps1"
  It "should add add items to its group instead of default" {
    chew "ninject"
    $chewie.Dependencies["ninject"].Groups[0].should.be("default")
  }
}


Describe "Ensure-SingleGroupsAreProcessedCorrectly" {
  . "$here\_Common.ps1"
  It "should add add items to its group instead of default" {
    New-Group name {
      chew "ninject"
    }
    $chewie.Dependencies["ninject"].Groups[0].should.be("name")
  }
}

Describe "Ensure-SingleGroupsAreProcessedCorrectly" {
  . "$here\_Common.ps1"
  It "should add add items to all specified groups" {
    chew "ninject" -groups "foo", "bar"
    $groups = $chewie.Dependencies["ninject"].Groups
    $groups[0].should.be("foo")
    $groups[1].should.be("bar")
  }
}

Describe "Ensure-SingleGroupsAreProcessedCorrectly" {
  . "$here\_Common.ps1"
  It "should add add items to all specified groups with group alias" {
    chew "ninject" -group "foo", "bar"
    $groups = $chewie.Dependencies["ninject"].Groups
    $groups[0].should.be("foo")
    $groups[1].should.be("bar")
  }
}

Describe "Ensure-SingleGroupsAreProcessedCorrectly" {
  . "$here\_Common.ps1"
  It "should not leak group scope to subsequent calls when used as a parameter" {
    chew "ninject" -group "foo", "bar"
    chew "xunit"
    $chewie.Dependencies["xunit"].Groups[0].should.be("default")
  }
}

Describe "Ensure-SingleGroupsAreProcessedCorrectly" {
  . "$here\_Common.ps1"
  It "should not leak group scope to subsequent calls when used as a block" {
    New-Group foo {
      chew "ninject"
    }
    chew "xunit"
    $chewie.Dependencies["xunit"].Groups[0].should.be("default")
  }
}

Describe "Ensure-SingleGroupsAreProcessedCorrectly" {
  . "$here\_Common.ps1"
  It "should use parameter overrides for groups when in group blocks" {
    New-Group baz {
      chew "ninject" -groups "foo", "bar"
    }
    
    $groups = $chewie.Dependencies["ninject"].Groups
    $groups.Count.should.be(2)
    $groups[0].should.be("foo")
    $groups[1].should.be("bar")
  }
}
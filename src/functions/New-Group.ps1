
function New-Group {
  [CmdletBinding()]  
  param(
    [Parameter(Position=0,Mandatory=$true)][string]$name = $null,
    [Parameter(Position=1,Mandatory=$true)][scriptblock]$action = $null
  )
  $groupKey = $name.ToLower()    

  $defaultGroupName = $chewie.default_group_name
  try {
    $chewie.default_group_name = $name
    & $action
  } finally {
    $chewie.default_group_name = $defaultGroupName
  }
}

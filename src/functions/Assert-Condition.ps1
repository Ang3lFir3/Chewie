# borrowed from psake https://github.com/psake/psake/blob/master/psake.psm1
function Assert-Condition {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)]$conditionToCheck,
    [Parameter(Position=1,Mandatory=$true)]$failureMessage
  )
  if (!$conditionToCheck) { 
    throw ("Assert: " + $failureMessage) 
  }
}

if(@(Get-Alias Assert -ErrorAction SilentlyContinue).Length -eq 0) {
  New-Alias -Name Assert -Scope Script -Value Assert-Condition
}

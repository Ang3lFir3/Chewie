
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
New-Alias -Name Assert -Scope Script -Value Assert-Condition


function Invoke-CommandWithThrow {
    [CmdletBinding()]
    param(
      [Parameter(Position=0,Mandatory=$true)]
      [scriptblock]$cmd,
      [Parameter(Position=1,Mandatory=$false)]
      [string]$errorMessage = ($messages.error_bad_command -f $cmd)
    )
    & $cmd
    if ($LastExitCode -ne 0) {
      throw ("Exec: " + $errorMessage)
    }
}

New-Alias -Name Exec -Scope Script -Value Invoke-CommandWithThrow

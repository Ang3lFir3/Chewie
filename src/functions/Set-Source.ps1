function Set-Source {
  param(
    [Parameter(Position=0,Mandatory=$true)]
    [string] $source = $null
  )
  if($chewie.sources[$source]) {
    $chewie.default_source = $chewie.sources[$source]
  }
  else {
    $chewie.default_source = $source
  }
}

New-Alias -Name Source -Scope Script -Value Set-Source

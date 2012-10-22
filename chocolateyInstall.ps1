try {
  $here = $(Split-Path -parent $MyInvocation.MyCommand.path)
  .\init.ps1 $here\.. $here
  Write-ChocolateySuccess 'chewie'
} catch {
  Write-ChocolateyFailure 'chewie' $($_.Exception.Message)
  throw 
}
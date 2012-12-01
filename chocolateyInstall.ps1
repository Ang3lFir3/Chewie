try {
  $psFile = Join-Path $(Split-Path -parent $MyInvocation.MyCommand.path) "chewie.ps1"
  Install-ChocolateyPowershellCommand 'chewie' $psFile
  Write-ChocolateySuccess 'chewie'
} catch {
  Write-ChocolateyFailure 'chewie' $($_.Exception.Message)
  throw 
}

function Invoke-NuGetFile {
  param([string]$nugetFile)
  $nugetFile = (Get-SafeFilePath $nugetFile)
  [string]$content = Get-Content $nugetFile -Delimiter ([Environment]::NewLine)
  Invoke-Expression $content
}

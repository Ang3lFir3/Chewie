
function Get-SafeFilePath {
  param([string]$filePath)
  return (Get-Item $filePath).FullName
}

function Get-VersionFromArchive {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)] [string]$packageName,
    [Parameter(Position=1,Mandatory=$true)] [string]$archiveFile
  )
  $versionFromFileName = Get-VersionFromString $archiveFile -IsFile
  if($versionFromFileName) {return $versionFromFileName}
  $shell= new-object -com shell.application
  $targetDir = Split-Path "$archiveFile"
  $zipFileName = "$targetDir\$packageName.zip"
  cp "archiveFile" "$zipFileName"
  $zip = $shell.NameSpace("$archiveFile")
  $specName = "$packageName*.nuspec"
  $targetFolder = $shell.NameSpace($targetDir)
  $target = $zip.Items() | ? {$_.Name -ilike $specName}
  $specName = $target.Name
  $specPath = (Join-Path $targetDir $specName)
  $targetDir.CopyHere($target)
  [Runtime.Interopservices.Marshal]::ReleaseComObject($shell)
  Remove-Variable "shell"
  [Runtime.Interopservices.Marshal]::ReleaseComObject($zip)
  Remove-Variable "zip"
  [Runtime.Interopservices.Marshal]::ReleaseComObject($targetFolder)
  Remove-Variable "targetFolder"
  [Runtime.Interopservices.Marshal]::ReleaseComObject($target)
  Remove-Variable "target"
  
  rm $zipFileName
  
  if(!(Test-Path $specPath)){ return $null }
  $versionString = ([xml] (get-content )).package.metadata.version
  rm $specPath
  $targetVersion = Get-VersionFromString $versionString
  $targetVersion
}

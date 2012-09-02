
function Invoke-NugetFile {
  #$content = (Get-Content $chewie.build_script_file.FullName) | ? {![string]::IsNullOrEmpty($_)} | % { [scriptblock]::Create($_.ToString()) }
  #foreach ($command in $content) {
  #  Write-ColoredOutput "$command`n" -foregroundcolor Green
  #  & $command
  #}
  [string]$content = [Io.File]::ReadAllText($chewie.build_script_file.FullName)
  Invoke-Expression $content
}

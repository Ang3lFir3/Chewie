
function Get-PackageList {
  param([string]$packageName, [string]$source)
  if([string]::IsNullOrEmpty($source)) { $source = $chewie.feed_uri }
  $url = $source + ($chewie.feed_package_filter -f $packageName)
  $wc = $null
  try {
    $wc = New-Object Net.WebClient
    $wc.UseDefaultCredentials = $true
    [xml]$result = $wc.DownloadString($url)
    return $result
  } finally {
    $wc.Dispose()
  }
}

function Get-PackageList {
  param([string]$packageName)
  $url = $chewie.feed_uri + ($chewie.feed_package_filter -f $packageName)
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
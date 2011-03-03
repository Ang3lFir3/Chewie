param($rootPath, $toolsPath, $package, $project)

$chewieModule = "$rootPath\chewie.psm1"
Write-Host "Importing $chewieModule"
import-module -Force -Global $chewieModule
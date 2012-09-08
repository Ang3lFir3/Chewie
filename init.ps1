param($rootPath, $toolsPath, $package, $project)

$chewieModule = "$rootPath\chewie.psm1"
Write-Host "Importing $chewieModule"
import-module -Force -Global $chewieModule


# remove everything as we have copied it over.
Uninstall-Package Chewie
## Getting started  
To work on Chewie:
1. Clone the repo
2. execute .\build to have chewie bootstrap itself and run tests.

## To package Chewie
.\build -T Package

## Trying out chewie during 2.0.0 prerelease

Add your directory with the nupkg to a custom feed.

### To install Chewie inside of VS
install-package chewie -version 2.0.0

### To install Chewie outside of VS
nuget install chewie -x -v 2.0.0;.\Chewie\tools\init.ps1 "" $pwd\Chewie\tools  

##License  
This software is released under the MIT License
## Getting Started
Watch this [video](https://vimeo.com/54695717).  
See the Wiki.

## Contributing to Chewie  
To work on Chewie:

1. Clone the repo
2. execute .\build -bootstrap to have chewie bootstrap itself (download dependencies) and run tests. If you try to just run build, it will fail as chewie won't download unless you are executing it on purpose.
3. execute .\build after bootstrapping in order to run tests automatically.
4. execute .\build -t package to create the NuGet/Chocolatey package
5. execute .\build -t TestChocolatey in order to deploy the package you created locally. When you install Chewie via Chocolatey or Visual Studio, the initialization script will load it into the current user's PowerShell Modules folder. This makes the chewie command available in any PowerShell session.

##License  
This software is released under the MIT License
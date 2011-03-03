The intent of Chewie is to bring some of the niceties of gems bundler to nuget.
 Chewie uses a file named .Nugetfile to find all the nugets and you want installed along with how and from where you would like to install them. Chewie is delivered as a set of powershell scripts and a powershell module.

## Getting started  
[Getting Started Video](http://vimeo.com/19931794) from my friend and Co-Worker [Bobby Johnson](https://github.com/Notmyself) he also gets credit for the name.  
you can either grab the files from here or use nuget to get them. The package name is Chewie (amazing I know!).  
Chewie makes the assumption that you have nuget.exe located somewhere in your path. This means that you will need to download it from [here](http://ci.nuget.org:8080/guestAuth/repository/download/bt4/.lastSuccessful/Console/NuGet.exe)  


PS>chewie-init.ps1  
This will create the sample .NugetFile you can use to begin working with Chewie.  

Below are some examples of the features in Chewie and how to use them.  

### source 
usage =>  source <some_nuget_feed_url>  
example => source 'http://nuget.random.org/'  

This will set the default source for all of you nugets. Use this if you plan to use some of feed other than the one defined in nuget.exe. 

### install_to
usage => install_to <some_folder_name>  
example => install_to 'lib'  

This will tell nuget to install the following nugets to the specified folder. Install_To will create the folder if it does not already exist.

### chew
usage => chew <name> [-v/-version <version_to_install>] [-s/-source <some_nuget_feed_url>]  
example => chew 'ninject'  
example => chew 'ninject' '2.0.1.0'  
example => chew 'ninject' -v '2.0.1.0'  
example => chew 'ninject' '2.0.1.0' 'http://somethingrandom.feed.org'  
example => chew 'ninject  -source 'http://somethingrandom.feed.org' -v '2.0.1.0'   
I think you get the idea....  

## Using the PowerShell module
using the module is not much different than the script itself except for a couple of changes.  

To init a Chewie file once the module is imported you can :  
PS>Chewie-Init

Once you import the module you can get can get chewie doing its thing by calling :  
PS>Invoke-Chewie

## Projects using Chewie
https://github.com/codereflection/Giles  

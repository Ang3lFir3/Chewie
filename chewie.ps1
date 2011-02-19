$default_source = ""

function source
{
	param(
		[Parameter(Position=0,Mandatory=$true)]
		[string] $source = $null
	)
		$script:default_source = $source
}

function FileExistsInPath
{
	param (
		[Parameter(Position=0,Mandatory=$true)]
		[string] $fileName = $null
	)

	$path = Get-Childitem Env:Path
	$found = $false
	foreach ($folder in $path.Value.Split(";"))
	{
		if (Test-Path "$folder\$fileName")
		{
			$found = $true;
			break
		}
	}
	Write-Output $found
}

function install_to
{
	param(
		[Parameter(Position=0,Mandatory=$true)]
		[string] $path = $null
		)
	if(!(test-path $path)){new-item -path . -name $path -itemtype directory}
	push-location $path -stackname 'chewie_nuget'
}

function chew 
{
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=$true)]
		[string] $name = $null,
		
		[Parameter(Position=1,Mandatory=$false)]
		[alias("v")]
		[string] $version = "",
		
		[Parameter(Position=2,Mandatory=$false)]
		[alias("s")]
		[string] $source = ""
		)
				
		$nuGetIsInPath = FileExistsInPath "NuGet.exe"
		$command = ""
		if($nuGetIsInPath){$command += "NuGet.exe install $name"} else {$command += "install-package $name"}
		if($version -ne ""){$command += " -v $version"}
		if($source -eq "" -and $script:default_source -ne ""){$source = $script:default_source}
		if($source -ne ""){$command += " -s $source"}
		
	invoke-expression $command

}

gc $pwd\.NugetFile | Foreach-Object { $block = [scriptblock]::Create($_.ToString()); % $block;}
if((get-location -stackname 'chewie_nuget').count -gt 0) {pop-location -stackname 'chewie_nuget'}
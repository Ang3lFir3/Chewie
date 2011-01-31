function nuget 
{
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=1)]
		[string] $name = $null,
		
		[Parameter(Position=1,Mandatory=0)]
		[string] $version = ""
		)
		
		$command = "nuget.exe install $name"
		if($version -ne ""){$command += " -v $version"}
		
	invoke-expression $command

}

function noms 
{
	gc $pwd\.NugetFile | Foreach-Object { $block = [scriptblock]::Create($_.ToString()); % $block;}
}
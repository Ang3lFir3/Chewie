$here = Split-Path -Parent $MyInvocation.MyCommand.Definition
$functions = Resolve-Path $here\..\functions
. $functions\Load-Configuration.ps1
Load-Configuration
$chewie.Packages = @{}
$chewie.ExecutedDependencies = new-object System.Collections.Stack
$chewie.callStack = new-object System.Collections.Stack
$chewie.originalEnvPath = $env:path
$chewie.originalDirectory = get-location
$chewie.chews = New-Object Collections.Queue
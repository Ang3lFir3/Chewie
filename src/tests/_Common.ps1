$here = Split-Path -Parent $MyInvocation.MyCommand.Definition
Resolve-Path $here\..\functions\*.ps1 | 
    ? { -not ($_.ProviderPath.Contains(".Tests.")) } |
    % { . $_.ProviderPath }
    
Load-Configuration
$chewie.Packages = @{}
$chewie.ExecutedDependencies = new-object System.Collections.Stack
$chewie.callStack = new-object System.Collections.Stack
$chewie.originalEnvPath = $env:path
$chewie.originalDirectory = get-location
$chewie.chews = New-Object Collections.Queue
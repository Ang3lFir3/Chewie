# borrowed from psake https://github.com/psake/psake/blob/master/psake.psm1
function Write-TimeSummary($invokePsakeDuration) {
    "-" * 70 
    "Build Time Report"
    "-" * 70
    $list = @()
    while ($chewie.ExecutedDependencies.Count -gt 0) {
        $taskKey = $chewie.ExecutedDependencies.Pop()
        $task = $chewie.Packages.$taskKey
        $list += new-object PSObject -property @{
            Name = $task.Name;
            Duration = $task.Duration
        }
    }
    [Array]::Reverse($list)
    $list += new-object PSObject -property @{
        Name = "Total:";
        Duration = $invokePsakeDuration
    }
    # using "out-string | where-object" to filter out the blank line that format-table prepends
    $list | format-table -autoSize -property Name,Duration | out-string -stream | where-object { $_ }
}

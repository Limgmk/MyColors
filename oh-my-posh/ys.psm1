#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    # write # and space
    $prompt = Write-Prompt -Object $sl.PromptSymbols.StartSymbol -ForegroundColor $sl.Colors.PromptSymbolColor
    # write user
    $user = $sl.CurrentUser
    if (Test-NotDefaultUser($user)) {
        $prompt += Write-Prompt -Object " $user" -ForegroundColor $sl.Colors.PromptHighlightColor
        # write at (devicename)
        $computer = $sl.CurrentHostname
        $prompt += Write-Prompt -Object " @" -ForegroundColor $sl.Colors.PromptForegroundColor
        $prompt += Write-Prompt -Object " $computer" -ForegroundColor $sl.Colors.GitDefaultColor
        # write in for folder
        $prompt += Write-Prompt -Object " in" -ForegroundColor $sl.Colors.PromptForegroundColor
    }
    # write folder
    $dir = Get-FullPath -dir $pwd
    $prompt += Write-Prompt -Object " $dir " -ForegroundColor $sl.Colors.AdminIconForegroundColor
    # write on (git:branchname status)
    $status = Get-VCSStatus
    if ($status) {
        $sl.GitSymbols.BranchSymbol = ''
        $themeInfo = Get-VcsInfo -status ($status)
        $prompt += Write-Prompt -Object 'on git:' -ForegroundColor $sl.Colors.PromptForegroundColor
        $prompt += Write-Prompt -Object "$($themeInfo.VcInfo) " -ForegroundColor $themeInfo.BackgroundColor
    }
    # write virtualenv
    if (Test-VirtualEnv) {
        $prompt += Write-Prompt -Object 'inside env:' -ForegroundColor $sl.Colors.PromptForegroundColor
        $prompt += Write-Prompt -Object "$(Get-VirtualEnvName) " -ForegroundColor $themeInfo.VirtualEnvForegroundColor
    }
    # write [time]
    $timeStamp = Get-Date -Format T
    $prompt += Write-Prompt "[$timeStamp]" -ForegroundColor $sl.Colors.PromptForegroundColor
    # check for elevated prompt
    If (Test-Administrator) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.ElevatedSymbol) " -ForegroundColor $sl.Colors.AdminIconForegroundColor
    }
		
    # check the last command state and indicate if failed
    # $foregroundColor = $sl.Colors.PromptHighlightColor
		
		$foregroundColor = $sl.Colors.CommandFailedIconForegroundColor
    #If ($lastCommandFailed) {
    #    $foregroundColor = $sl.Colors.CommandFailedIconForegroundColor
    #}
		
    if ($with) {
        $prompt += Write-Prompt -Object "$($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
    }

    $prompt += Set-Newline
    $prompt += Write-Prompt -Object $sl.PromptSymbols.PromptIndicator -ForegroundColor $foregroundColor
    $prompt += ' '
    $prompt
}

function Get-TimeSinceLastCommit {
    return (git log --pretty=format:'%cr' -1)
}

$sl = $global:ThemeSettings #local settings
$sl.PromptSymbols.StartSymbol = '#'
$sl.PromptSymbols.PromptIndicator = '$'
$sl.Colors.PromptSymbolColor = [ConsoleColor]::Blue
$sl.Colors.PromptForegroundColor = [ConsoleColor]::DarkWhite
$sl.Colors.PromptHighlightColor = [ConsoleColor]::Cyan
$sl.Colors.WithForegroundColor = [ConsoleColor]::DarkRed
$sl.Colors.WithBackgroundColor = [ConsoleColor]::Magenta
$sl.Colors.VirtualEnvForegroundColor = [ConsoleColor]::Red
$sl.Colors.AdminIconForegroundColor = [ConsoleColor]::Yellow

#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )
		
		$prompt += Set-Newline

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
    $prompt += Write-Prompt -Object " $dir " -ForegroundColor $sl.Colors.DriveForegroundColor
    # write on (git:branchname status)
    $status = Get-VCSStatus
    if ($status) {
        $sl.GitSymbols.BranchSymbol = ''
        $prompt += Write-Prompt -Object 'on git:' -ForegroundColor $sl.Colors.PromptForegroundColor
				$prompt += Write-Prompt -Object "$($status.Branch)" -ForegroundColor $sl.Colors.PromptHighlightColor
				# check if HasWorking
				if ($status.HasWorking -eq "True") {
						$prompt += Write-Prompt -Object " x " -ForegroundColor $sl.Colors.GitNoLocalChangesAndBehindColor
				} else {
						$prompt += Write-Prompt -Object " o " -ForegroundColor $sl.Colors.GitDefaultColor
				}
				
    }
    # write virtualenv
    if (Test-VirtualEnv) {
        $prompt += Write-Prompt -Object 'inside env:' -ForegroundColor $sl.Colors.PromptForegroundColor
        $prompt += Write-Prompt -Object "$(Get-VirtualEnvName) " -ForegroundColor $themeInfo.VirtualEnvForegroundColor
    }
    # write [time]
    $timeStamp = Get-Date -Format "HH:mm:ss"
    $prompt += Write-Prompt "[$timeStamp]" -ForegroundColor $sl.Colors.PromptForegroundColor
		
    if ($with) {
        $prompt += Write-Prompt -Object "$($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
    }

    $prompt += Set-Newline
    $prompt += Write-Prompt -Object $sl.PromptSymbols.PromptIndicator -ForegroundColor $sl.Colors.CommandFailedIconForegroundColor
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
$sl.Colors.PromptForegroundColor = [ConsoleColor]::ForegroundColor
$sl.Colors.PromptHighlightColor = [ConsoleColor]::DarkCyan
$sl.Colors.WithBackgroundColor = [ConsoleColor]::Magenta
$sl.Colors.VirtualEnvForegroundColor = [ConsoleColor]::Red
$sl.Colors.DriveForegroundColor = [ConsoleColor]::DarkYellow
$sl.Colors.CommandFailedIconForegroundColor = [ConsoleColor]::Red
$sl.Colors.GitDefaultColor = [ConsoleColor]::DarkGreen
$sl.Colors.GitNoLocalChangesAndBehindColor = [ConsoleColor]::DarkRed
<#
.SYNOPSIS 
Put this function in your powershell profile to easily start antigravity cli sandbox for a specific folder/repo

#>
function Start-Antigravity {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    # Identifiera repots rot oavsett aktuell underkatalog
    $gitRoot = git rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($gitRoot)) {
        $workspacePath = [System.IO.Path]::GetFullPath($gitRoot.Trim())
    } else {
        $workspacePath = $PWD.Path
    }

    $containerName = "antigravity-session-$PID"

    $dockerArgs = @(
        "run", "-it", "--rm",
        "--name", $containerName,
        "-w", "/workspace",
        "-v", "${workspacePath}:/workspace",
        "-v", "antigravity-auth:/home/developer/.gemini",
        "antigravity-sandbox",
        "--dangerously-skip-permissions",
        "--mode=accept-edits"
    )

    if ($Arguments) {
        $dockerArgs += $Arguments
    }

    & docker @dockerArgs
}
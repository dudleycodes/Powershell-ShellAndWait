Function shellAndWait ($description, $executableItem, $arguments) {
    $consoleMode = [boolean]($Host.UI.RawUI.BufferSize.Height);
    $finishedMsg = "";
    $index = 0;
    $procRef = $Null;

    try {
        $procRef = [System.Diagnostics.Process]::Start($executableItem, $arguments)
    } catch {
        if (-not (Get-Item $executableItem -EA SilentlyContinue)) {
            Write-Error "Could not access excutable: '$executableItem'";
        } else {
            Write-Error $_
        }
        break;
    }
    Write-Host -NoNewLine "$description..";
    
    do {
        if ($consoleMode) {
            write-host -NoNewLine `b`b @('\', '|', '/', '-', '\', '|', '/', '-')[$index % 7];
            Start-Sleep -m 100;
        } else {
            write-host -NoNewLine '.';
            Start-Sleep -m (700 + ($index * 15));
        }
        $index++;
    } while (-not $procRef.HasExited)
    
    if ($consoleMode) { Write-Host -NoNewLine "`b-=> " }

    if ($procRef.ExitCode -eq 0) {
        Write-Host "ok";
    } else {
        Write-Host "failed! Exit code:" + $procRef.ExitCode;
    }
}

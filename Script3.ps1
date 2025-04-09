# Script3.ps1 (Rickroll)
$rickrollURL = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

# Stealthy method (minimized browser window)
Start-Process "chrome.exe" "-app=$rickrollURL --start-minimized" -WindowStyle Hidden

# Alternative (works for any browser):
Start-Process "$rickrollURL" -WindowStyle Minimized

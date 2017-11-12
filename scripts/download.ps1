$DownloadCollection = New-Object -com "Microsoft.Update.UpdateColl"
$AvailableUpdates | ForEach-Object { 
        if ($_.InstallationBehavior.CanRequestUserInput -ne $TRUE) { 
            $DownloadCollection.Add($_) | Out-Null 
            } 
        }
Write-Host "Downloading updates..."
$Downloader = $Session.CreateUpdateDownloader() 
$Downloader.Updates = $DownloadCollection 
$Downloader.Download()
Write-Host "Download complete."

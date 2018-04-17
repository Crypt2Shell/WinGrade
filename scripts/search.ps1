# ---------- ---------- ---------- --------- --------- #
 # --- --- --- --- --- GET-UPDATE --- --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function get-update {
    Write-Host "searching for Updates ..."
    $session = New-Object -ComObject Microsoft.Update.Session
    $searcher = $session.CreateUpdateSearcher()
    $result = $searcher.Search("IsInstalled=0 and Type='Software'" )

    $result.Updates | select Title, IsHidden
    get-update2
}

# ---------- ---------- ---------- --------- --------- #
 # --- --- --- --- --- GET-UPDATE --- --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function get-update2 {
    [CmdletBinding()]
    param ( 
         [switch]$hidden 
    ) 
    PROCESS{
        $session = New-Object -ComObject Microsoft.Update.Session
        $searcher = $session.CreateUpdateSearcher()

        # 0 = false & 1 = true
        if ($hidden){
             $result = $searcher.Search("IsInstalled=0 and Type='Software' and ISHidden=1" )
        }
        else {
             $result = $searcher.Search("IsInstalled=0 and Type='Software' and ISHidden=0" )
        }

        if ($result.Updates.Count -gt 0){
             $result.Updates | 
             select Title, IsHidden, IsDownloaded, IsMandatory, 
             IsUninstallable, RebootRequired, Description | ForEach-Object {Write-Host "     "$_.Name.ToString() -ForegroundColor Cyan} 

             get-installedupdate

        }
        else {
             Write-Host "No updates available"
        } 

    }
}
# ---------- ---------- ---------- --------- --------- #
 # -- --- --- --- GET-INSTALLEDUPDATE --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function get-installedupdate {
    $session = New-Object -ComObject Microsoft.Update.Session
    $searcher = $session.CreateUpdateSearcher()
    $result = $searcher.Search("IsInstalled=1 and Type='Software'" )

    $result.Updates | select Title, LastDeploymentChangeTime | Foreach-Object { Write-Host $_ -ForegroundColor Green}

    install-update
}

# ---------- ---------- ---------- --------- --------- #
 # --- --- --- --- INSTALL-UPDATE --- --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function install-update {
    $session = New-Object -ComObject Microsoft.Update.Session
    $searcher = $session.CreateUpdateSearcher()

    $result = $searcher.Search("IsInstalled=0 and Type='Software' and ISHidden=0")
    
    if ($result.Updates.Count -eq 0) {
         Write-Host "No updates to install"
    }
    else {
        $result.Updates | select Title
    }

    $downloads = New-Object -ComObject Microsoft.Update.UpdateColl

    foreach ($update in $result.Updates){
         $downloads.Add($update)
    }
     
    $downloader = $session.CreateUpdateDownLoader()
    $downloader.Updates = $downloads
    $downloader.Download()

    $installs = New-Object -ComObject Microsoft.Update.UpdateColl
    foreach ($update in $result.Updates){
         if ($update.IsDownloaded){
               $installs.Add($update)
         }
    }

    $installer = $session.CreateUpdateInstaller()
    $installer.Updates = $installs
    $installresult = $installer.Install()
    $installresult

    # Reboot if needed 
    if ($installresult.RebootRequired) { 
	    if ($Reboot) { 
            Write-Host "Rebooting..."
	        schtasks /Create /tn WinGrade /tr "powershell.exe -nop -c 'iex(New-Object Net.WebClient).DownloadString(''https://raw.githubusercontent.com/Crypt2Shell/WinGrade/blob/master/scripts/search.ps1'''))'" /sc onstart /ru System
            Restart-Computer
            
        } 
        else { 
            Write-Host "Please reboot and start the Program again."
	        schtasks /Delete /tn WinGrade
        } 
    }
    else { 
        Write-Host "No reboot required."
        schtasks /Delete /tn WinGrade
    }
}

get-update

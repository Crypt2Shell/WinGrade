# ---------- ---------- ---------- --------- --------- #
 # --- --- --- --- Elevate-Privileges --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function elevate-privileges {
    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
            Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "iex(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/Crypt2Shell/WinGrade/master/scripts/search.ps1')"
	    Exit
        }
        else {
        Write-Host -ForegroundColor Red "This script must be run as Administrator!"
        }
    }
    else {
    Write-Host -ForegroundColor Green "whoami: Administrator"
    get-update
    }
}
# ---------- ---------- ---------- --------- --------- #
 # --- --- --- --- --- GET-UPDATE --- --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function get-update {
    Write-Host "searching for Updates ..."
    $session = New-Object -ComObject Microsoft.Update.Session
    $searcher = $session.CreateUpdateSearcher()
    $result = $searcher.Search("IsInstalled=0 and Type='Software'" )

    $result.Updates | select Title, IsHidden
    get-updateStage2
}

# ---------- ---------- ---------- --------- --------- #
 # --- --- --- --- --- GET-UPDATE --- --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function get-updateStage2 {
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
            IsUninstallable, RebootRequired, Description
	     
	        install-update

        }
        else {
             Write-Host "No updates available"
             control.exe /name Microsoft.WindowsUpdate
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

    $result.Updates | select Title, LastDeploymentChangeTime
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
         control.exe /name Microsoft.WindowsUpdate
    }
    else {
        $result.Updates | select Title
	Write-Host "downloading Updates..."
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

    Write-Host "installing Updates..."
    $installer = $session.CreateUpdateInstaller()
    $installer.Updates = $installs
    $installresult = $installer.Install()
    $installresult

    # Reboot if needed 
    if ($installresult.RebootRequired) { 
	    if ($Reboot) { 
            Write-Host "Rebooting..."
	        schtasks /Create /tn WinGrade /tr "powershell.exe -nop -c 'iex(New-Object Net.WebClient).DownloadString(''https://raw.githubusercontent.com/Crypt2Shell/WinGrade/master/scripts/search.ps1'''))'" /sc onstart /ru System
            Restart-Computer
        } 
        else { 
            Write-Host "Please reboot and start the Program again."
	        schtasks /Delete /tn WinGrade
        } 
    }
    else { 
        Write-Host "No reboot required."
	    get-installedupdate
        schtasks /Delete /tn WinGrade
        control.exe /name Microsoft.WindowsUpdate
    }
}

elevate-privileges

# ---------- ---------- ---------- --------- --------- #
 # --- --- --- --- Elevate-Privileges --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function elevate-privileges {
    try {
        if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
            if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
                Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "`$down=New-Object Net.WebClient;`$down.Headers['User-Agent']='Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.19 (KHTML, like Gecko) Chrome/1.0.154.53 Safari/525.19';`$down.DownloadString('https://raw.githubusercontent.com/Crypt2Shell/WinGrade/master/scripts/search.ps1')|iex"
                Exit
            }
        }
        else {
            whoami /priv | Foreach-Object {Write-Host $_}
            whoami /user | Foreach-Object {Write-Host -ForegroundColor Green $_}
            get-update
        }
    }
    Catch {
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "`$down=New-Object Net.WebClient;`$down.Headers['User-Agent']='Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.19 (KHTML, like Gecko) Chrome/1.0.154.53 Safari/525.19';`$down.DownloadString('https://raw.githubusercontent.com/Crypt2Shell/WinGrade/master/scripts/search.ps1')|iex"
        Exit
    }
}
# ---------- ---------- ---------- --------- --------- #
 # --- --- --- --- --- GET-UPDATE --- --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function get-update {
    Write-Host "`nsearching for Updates ...[Stage 1]"
    $session = New-Object -ComObject Microsoft.Update.Session
    $searcher = $session.CreateUpdateSearcher()
    $result = $searcher.Search("IsInstalled=0 and Type='Software'" )

    $result.Updates | select Title, IsHidden, IsInstalled | Out-String | Write-Host -ForegroundColor Magenta
    get-updateStage2
}
# ---------- ---------- ---------- --------- --------- #
 # --- --- --- --- --- GET-UPDATE --- --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function get-updateStage2 {
    PROCESS{
        Write-Host "`nsearching for Updates ...[Stage 2]"
        $session = New-Object -ComObject Microsoft.Update.Session
        $searcher = $session.CreateUpdateSearcher()

        $result = $searcher.Search("IsInstalled=0 and Type='Software' and ISHidden=1" )

        if ($result.Updates.Count -gt 0){
            $result.Updates | select Title, IsHidden, IsDownloaded, IsMandatory,
                                     IsUninstallable, RebootRequired, Description | Out-String | Write-Host -ForegroundColor DarkMagenta
	        install-update

        }
        else {
             Write-Host -ForegroundColor Cyan "`tNo updates available."
        } 
    }
}
# ---------- ---------- ---------- --------- --------- #
 # --- --- --- --- INSTALL-UPDATE --- --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function install-update {
    $session = New-Object -ComObject Microsoft.Update.Session
    $searcher = $session.CreateUpdateSearcher()

    $result = $searcher.Search("IsInstalled=0 and Type='Software' and ISHidden=0")
    
    if ($result.Updates.Count -eq 0) {
         Write-Host -ForegroundColor Cyan "`tNo updates available."
    }
    else {
        $result.Updates | select Title | Out-String | Write-Host -ForegroundColor Magenta
    }
    Write-Host "`ndownloading Updates..."
    $NumUp=0
    foreach ($update in $result.Updates){
        Write-Progress -Activity "Downloading Updates ..." -Status ($update.title) -PercentComplete ([int]($NumUp/$result.Updates.count*100)) -CurrentOperation [$NumUp/$result.Updates.count]
        
	    $downloads = New-Object -ComObject Microsoft.Update.UpdateColl
        $downloads.Add($update)|out-null
        $downloader = $session.CreateUpdateDownLoader()
        $downloader.Updates = $downloads
        $downloader.Download()
	
	$NumUp++
    }
    Write-Host "`ninstalling Updates..."
    $NumUp=0
    foreach ($update in $result.Updates){
        Write-Progress -Activity "Installing Updates ..." -Status ($update.title) -PercentComplete([int]($NumUp/$result.Updates.count*100)) -CurrentOperation [$NumUp/$result.Updates.count]
	
	    $installs = New-Object -ComObject Microsoft.Update.UpdateColl
        if ($update.IsDownloaded){
            $installs.Add($update)|out-null
        }
        $installer = $session.CreateUpdateInstaller()
        $installer.Updates = $installs
        $installresult = $installer.Install()
        $installresult
	
	$NumUp++
    }
    get-installedupdate
}
# ---------- ---------- ---------- --------- --------- #
 # -- --- --- --- GET-INSTALLEDUPDATE --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function get-installedupdate {
    $session = New-Object -ComObject Microsoft.Update.Session
    $searcher = $session.CreateUpdateSearcher()
    $result = $searcher.Search("IsInstalled=1 and Type='Software'" )

    $result.Updates | select Title, IsInstalled, LastDeploymentChangeTime | Out-String | Write-Host -ForegroundColor DarkCyan
    Write-Host -ForegroundColor Yellow "[!] Waiting ...[15s]"; sleep -s 15
    get-reboot
}
# ---------- ---------- ---------- --------- --------- #
 # --- --- --- --- --- GET-REBOOT --- --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function get-reboot {
    #if ($installresult.RebootRequired) { 
        Write-Host -ForegroundColor Cyan "`nRebooting..."
	schtasks /create /tn WinGrade /tr "powershell.exe 'iex((new-object net.webclient).DownloadString(''https://raw.githubusercontent.com/Crypt2Shell/WinGrade/master/scripts/search.ps1'''))'" /sc onstart /ru System
        Restart-Computer -Force
    #}
    #else { 
        #Write-Host -ForegroundColor Green "`nNo reboot required."
        #schtasks /Delete /tn WinGrade
        #get-update
    #}
}
elevate-privileges

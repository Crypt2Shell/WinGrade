# ---------- ---------- ---------- --------- --------- #
 # --- --- --- --- Elevate-Privileges --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function elevate-privileges {
    try {
    	$exitproc = 0
        if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
            if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
                Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-encodedCommand JABkAG8AdwBuAD0ATgBlAHcALQBPAGIAagBlAGMAdAAgAE4AZQB0AC4AVwBlAGIAQwBsAGkAZQBuAHQAOwAkAGQAbwB3AG4ALgBIAGUAYQBkAGUAcgBzAFsAJwBVAHMAZQByAC0AQQBnAGUAbgB0ACcAXQA9ACcATQBvAHoAaQBsAGwAYQAvADUALgAwACAAKABXAGkAbgBkAG8AdwBzADsAIABVADsAIABXAGkAbgBkAG8AdwBzACAATgBUACAANQAuADEAOwAgAGUAbgAtAFUAUwApACAAQQBwAHAAbABlAFcAZQBiAEsAaQB0AC8ANQAyADUALgAxADkAIAAoAEsASABUAE0ATAAsACAAbABpAGsAZQAgAEcAZQBjAGsAbwApACAAQwBoAHIAbwBtAGUALwAxAC4AMAAuADEANQA0AC4ANQAzACAAUwBhAGYAYQByAGkALwA1ADIANQAuADEAOQAnADsAJABkAG8AdwBuAC4AUAByAG8AeAB5AC4AQwByAGUAZABlAG4AdABpAGEAbABzAD0AWwBTAHkAcwB0AGUAbQAuAE4AZQB0AC4AQwByAGUAZABlAG4AdABpAGEAbABDAGEAYwBoAGUAXQA6ADoARABlAGYAYQB1AGwAdABOAGUAdAB3AG8AcgBrAEMAcgBlAGQAZQBuAHQAaQBhAGwAcwA7ACQAZABvAHcAbgAuAEQAbwB3AG4AbABvAGEAZABTAHQAcgBpAG4AZwAoACcAaAB0AHQAcABzADoALwAvAHIAYQB3AC4AZwBpAHQAaAB1AGIAdQBzAGUAcgBjAG8AbgB0AGUAbgB0AC4AYwBvAG0ALwBDAHIAeQBwAHQAMgBTAGgAZQBsAGwALwBXAGkAbgBHAHIAYQBkAGUALwBtAGEAcwB0AGUAcgAvAHMAYwByAGkAcAB0AHMALwBzAGUAYQByAGMAaAAuAHAAcwAxACcAKQB8AGkAZQB4AA=="
                Exit
            }
        }
        else {
            #whoami /priv | Foreach-Object {Write-Host $_}
            banner
        }
    }
    Catch {
        $exitproc = 0
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-encodedCommand JABkAG8AdwBuAD0ATgBlAHcALQBPAGIAagBlAGMAdAAgAE4AZQB0AC4AVwBlAGIAQwBsAGkAZQBuAHQAOwAkAGQAbwB3AG4ALgBIAGUAYQBkAGUAcgBzAFsAJwBVAHMAZQByAC0AQQBnAGUAbgB0ACcAXQA9ACcATQBvAHoAaQBsAGwAYQAvADUALgAwACAAKABXAGkAbgBkAG8AdwBzADsAIABVADsAIABXAGkAbgBkAG8AdwBzACAATgBUACAANQAuADEAOwAgAGUAbgAtAFUAUwApACAAQQBwAHAAbABlAFcAZQBiAEsAaQB0AC8ANQAyADUALgAxADkAIAAoAEsASABUAE0ATAAsACAAbABpAGsAZQAgAEcAZQBjAGsAbwApACAAQwBoAHIAbwBtAGUALwAxAC4AMAAuADEANQA0AC4ANQAzACAAUwBhAGYAYQByAGkALwA1ADIANQAuADEAOQAnADsAJABkAG8AdwBuAC4AUAByAG8AeAB5AC4AQwByAGUAZABlAG4AdABpAGEAbABzAD0AWwBTAHkAcwB0AGUAbQAuAE4AZQB0AC4AQwByAGUAZABlAG4AdABpAGEAbABDAGEAYwBoAGUAXQA6ADoARABlAGYAYQB1AGwAdABOAGUAdAB3AG8AcgBrAEMAcgBlAGQAZQBuAHQAaQBhAGwAcwA7ACQAZABvAHcAbgAuAEQAbwB3AG4AbABvAGEAZABTAHQAcgBpAG4AZwAoACcAaAB0AHQAcABzADoALwAvAHIAYQB3AC4AZwBpAHQAaAB1AGIAdQBzAGUAcgBjAG8AbgB0AGUAbgB0AC4AYwBvAG0ALwBDAHIAeQBwAHQAMgBTAGgAZQBsAGwALwBXAGkAbgBHAHIAYQBkAGUALwBtAGEAcwB0AGUAcgAvAHMAYwByAGkAcAB0AHMALwBzAGUAYQByAGMAaAAuAHAAcwAxACcAKQB8AGkAZQB4AA=="
        Exit
    }
}
# ---------- ---------- ---------- --------- --------- #
 # --- --- --- --- --- Banner --- --- --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function banner {
    $processor   = gwmi Win32_Processor
    $display     = gwmi Win32_DisplayConfiguration
    $os          = gwmi Win32_OperatingSystem
    $uptime      = $os.ConvertToDateTime($os.LocalDateTime) - $os.ConvertToDateTime($os.LastBootUpTime)
    $gsid        = Add-Type -AssemblyName System.DirectoryServices.AccountManagement;
    $sid         = ([System.DirectoryServices.AccountManagement.UserPrincipal]::Current).SID
    $guser       = New-Object System.Security.Principal.SecurityIdentifier($sid)
    $user        = $sid.Translate([System.Security.Principal.NTAccount])
    $computer    = gwmi Win32_ComputerSystem
    $network     = gwmi Win32_NetworkAdapterConfiguration
    try{$ipAddresses = ($network | where IPAddress |% { $_.IPAddress[0] }) -join ", "}Catch{}
                                        
         write-host "`n         ...::::::..." -ForegroundColor Red
        write-host "        :::::::::::::::" -ForegroundColor Red -NoNewline;write-host "                     Uptime:            " -ForegroundColor Gray -NoNewline;write-host "$($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m $($uptime.Seconds)s" -ForegroundColor White;                 
       write-host "       .::::::::::::::." -ForegroundColor Red -NoNewline;write-host "  :.            ." -ForegroundColor Green
      write-host "      .:::::::::::::::" -ForegroundColor Red -NoNewline;write-host "  .:::::.....:::::" -ForegroundColor Green -NoNewline;write-host "    Operating system:  " -ForegroundColor Gray -NoNewline;write-host "$($os.Caption) $($os.OSArchitecture)" -ForegroundColor White;
      write-host "      :::::::::::::::." -ForegroundColor Red -NoNewline;write-host " .:::::::::::::::" -ForegroundColor Green -NoNewline;write-host "     Kernel:            " -ForegroundColor Gray -NoNewline;write-host "Version: $(try{(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId}Catch{}) (Build: $($os.Version))" -ForegroundColor White -ErrorAction SilentlyContinue
     write-host "     .:::::::::::::::" -ForegroundColor Red -NoNewline;write-host "  :::::::::::::::." -ForegroundColor Green 
     write-host "     ::::::'':::::::." -ForegroundColor Red -NoNewline;write-host " .:::::::::::::::" -ForegroundColor Green -NoNewline;write-host "      Computer:          " -ForegroundColor Gray -NoNewline;write-host "$($env:computername) - $($computer.Model), $($computer.Manufacturer)" -ForegroundColor White;
    write-host "    .''         '':." -ForegroundColor Red -NoNewline;write-host "  :::::::::::::::." -ForegroundColor Green -NoNewline;write-host "      Benutzer:          " -ForegroundColor Gray -NoNewline;write-host "$($user.Value)" -ForegroundColor White;
    write-host "    ...::::::::.." -ForegroundColor Cyan -NoNewline;Write-Host "    .::::::::::::::." -ForegroundColor Green -NoNewline;write-host "       SID:               " -ForegroundColor Gray -NoNewline;write-host "$($sid.Value)" -ForegroundColor White;
   write-host "   .::::::::::::::." -ForegroundColor Cyan -NoNewline;Write-Host "    ''::::::::''" -ForegroundColor Green 
  write-host "  .:::::::::::::::" -ForegroundColor Cyan -NoNewline;write-host "  ':..         ..'" -ForegroundColor Yellow -NoNewline;write-host "        CPU:               " -ForegroundColor Gray -NoNewline;write-host "$($processor.Name)" -ForegroundColor White;
  write-host "  :::::::::::::::." -ForegroundColor Cyan -NoNewline;Write-Host " .:::::::::::::::" -ForegroundColor Yellow -NoNewline;write-host "         GPU:               " -ForegroundColor Gray -NoNewline;write-host "$($display.DeviceName)" -ForegroundColor White;
 write-host " .:::::::::::::::" -ForegroundColor Cyan -NoNewline;Write-Host "  :::::::::::::::." -ForegroundColor Yellow -NoNewline;write-host "         Memory:            " -ForegroundColor Gray -NoNewline;write-host "$([math]::Truncate($os.FreePhysicalMemory / 1KB)) MB / $([math]::Truncate($computer.TotalPhysicalMemory / 1MB)) MB" -ForegroundColor White;
 write-host " :::::::::::::::." -ForegroundColor Cyan -NoNewline;Write-Host " .:::::::::::::::" -ForegroundColor Yellow 
write-host ".:::::'''::::::." -ForegroundColor Cyan -NoNewline;Write-Host "  :::::::::::::::" -ForegroundColor Yellow -NoNewline;try{write-host "           Network:           " -ForegroundColor Gray -NoNewline;write-host "$ipAddresses" -ForegroundColor White -ErrorAction SilentlyContinue}Catch{}
write-host ".           ':." -ForegroundColor Cyan -NoNewline;write-host "  .::::::::::::::." -ForegroundColor Yellow 
                                               write-host "                 .::::::::::::::" -ForegroundColor Yellow
                                              write-host "                   ''':::::'''" -ForegroundColor Yellow -NoNewline;write-host "              Shell:             " -ForegroundColor Gray -NoNewline;write-host "PowerShell v$($Host.Version)" -ForegroundColor White;
get-update
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

        if ($result.Updates.Count -gt 0) {
            $result.Updates | select Title, IsHidden, IsDownloaded, IsMandatory,
                                     IsUninstallable, RebootRequired, Description | Out-String | Write-Host -ForegroundColor Magenta
	        install-update

        }
        else {
             Write-Host -ForegroundColor Cyan "`tNo [Hidden] updates available."
	     install-update
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
	    if ($exitproc -eq 5) {
	        Exit
	    }
        $exitproc++
	    get-installedupdate
    }
    else {
        $result.Updates | select Title | Out-String | Write-Host -ForegroundColor Magenta
    }
    Write-Host "`ndownloading Updates..."
    $NumUp=0
    foreach ($update in $result.Updates){
        Write-Progress -Activity "Downloading Updates ..." -Status ($update.title) -PercentComplete ([int]($NumUp/$result.Updates.count*100)) -CurrentOperation "| [ $($NumUp)/$($result.Updates.count) ] | [ $([int]($NumUp/$result.Updates.count*100))% ] |"
        
	    $downloads = New-Object -ComObject Microsoft.Update.UpdateColl
        $downloads.Add($update)|out-null
        $downloader = $session.CreateUpdateDownLoader()
        $downloader.Updates = $downloads
        $downloader.Download() #| Foreach-Object {$_ -replace "2", "."} | Write-Host -ForegroundColor Green -NoNewline|Format-Wide
	
	$NumUp++
    }
    Write-Host "`ninstalling Updates..."
    $NumUp=0
    foreach ($update in $result.Updates){ 
        Write-Progress -Activity "Installing Updates ..." -Status ($update.title) -PercentComplete([int]($NumUp/$result.Updates.count*100)) -CurrentOperation "| [ $($NumUp)/$($result.Updates.count) ] | [ $([int]($NumUp/$result.Updates.count*100))% ] |"
	
	    $installs = New-Object -ComObject Microsoft.Update.UpdateColl
        if ($update.IsDownloaded){
            $installs.Add($update)|out-null
        }
        $installer = $session.CreateUpdateInstaller()
        $installer.Updates = $installs
        $installresult = $installer.Install()
        $installresult #| Foreach-Object {$_ -replace "2", "."} | Write-Host -ForegroundColor Green -NoNewline|Format-Wide
	
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
    write-host "["-nonewline; write-host "!" -ForegroundColor Yellow -nonewline; write-host "]"-nonewline; Write-Host " Waiting ...[15s]" -NoNewline; sleep -s 15
    get-reboot
}
# ---------- ---------- ---------- --------- --------- #
 # --- --- --- --- --- GET-REBOOT --- --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function get-reboot {
    $key = Get-Item "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue
    if($key -ne $null) {
        Write-Host -ForegroundColor Cyan "`nRebooting..."
        echo "powershell -encodedCommand JABkAG8AdwBuAD0ATgBlAHcALQBPAGIAagBlAGMAdAAgAE4AZQB0AC4AVwBlAGIAQwBsAGkAZQBuAHQAOwAkAGQAbwB3AG4ALgBIAGUAYQBkAGUAcgBzAFsAJwBVAHMAZQByAC0AQQBnAGUAbgB0ACcAXQA9ACcATQBvAHoAaQBsAGwAYQAvADUALgAwACAAKABXAGkAbgBkAG8AdwBzADsAIABVADsAIABXAGkAbgBkAG8AdwBzACAATgBUACAANQAuADEAOwAgAGUAbgAtAFUAUwApACAAQQBwAHAAbABlAFcAZQBiAEsAaQB0AC8ANQAyADUALgAxADkAIAAoAEsASABUAE0ATAAsACAAbABpAGsAZQAgAEcAZQBjAGsAbwApACAAQwBoAHIAbwBtAGUALwAxAC4AMAAuADEANQA0AC4ANQAzACAAUwBhAGYAYQByAGkALwA1ADIANQAuADEAOQAnADsAJABkAG8AdwBuAC4AUAByAG8AeAB5AC4AQwByAGUAZABlAG4AdABpAGEAbABzAD0AWwBTAHkAcwB0AGUAbQAuAE4AZQB0AC4AQwByAGUAZABlAG4AdABpAGEAbABDAGEAYwBoAGUAXQA6ADoARABlAGYAYQB1AGwAdABOAGUAdAB3AG8AcgBrAEMAcgBlAGQAZQBuAHQAaQBhAGwAcwA7ACQAZABvAHcAbgAuAEQAbwB3AG4AbABvAGEAZABTAHQAcgBpAG4AZwAoACcAaAB0AHQAcABzADoALwAvAHIAYQB3AC4AZwBpAHQAaAB1AGIAdQBzAGUAcgBjAG8AbgB0AGUAbgB0AC4AYwBvAG0ALwBDAHIAeQBwAHQAMgBTAGgAZQBsAGwALwBXAGkAbgBHAHIAYQBkAGUALwBtAGEAcwB0AGUAcgAvAHMAYwByAGkAcAB0AHMALwBzAGUAYQByAGMAaAAuAHAAcwAxACcAKQB8AGkAZQB4AA==" > "%temp%\WinGrade.bat"
	move "%temp%\WinGrade.bat" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\WinGrade.bat"
	Restart-Computer -Force
    }
    else { 
        Write-Host -ForegroundColor Green "`nNo reboot required."
        del "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\WinGrade.bat" -ErrorAction SilentlyContinue
        elevate-privileges
    }
}
elevate-privileges

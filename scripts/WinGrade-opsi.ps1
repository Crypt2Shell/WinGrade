# ---------- ---------- ---------- --------- --------- #
 # -- --- --- --- SET-FOREGROUNDWINDOW --- --- --- -- #
# ---------- ---------- ---------- --------- --------- #
function set-foregroundwindow {
$signature = @’ 
[DllImport("user32.dll")] 
public static extern bool SetWindowPos( 
    IntPtr hWnd, 
    IntPtr hWndInsertAfter, 
    int X, 
    int Y, 
    int cx, 
    int cy, 
    uint uFlags); 
‘@ 
$type = Add-Type -MemberDefinition $signature -Name SetWindowPosition -Namespace SetWindowPos -Using System.Text -PassThru
$handle = (Get-Process -id $Global:PID).MainWindowHandle 
$alwaysOnTop = New-Object -TypeName System.IntPtr -ArgumentList (-1) 
$type::SetWindowPos($handle, $alwaysOnTop, 0, 0, 0, 0, 0x0003)
Sleep -s 20
disable-window
}
# ---------- ---------- ---------- --------- --------- #
 # -- --- --- --- DISABLE-WINDOW --- --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function disable-window {
# Calling user32.dll methods for Windows and Menus
$MethodsCall = '
[DllImport("user32.dll")] public static extern long GetSystemMenu(IntPtr hWnd, bool bRevert);
[DllImport("user32.dll")] public static extern bool EnableMenuItem(long hMenuItem, long wIDEnableItem, long wEnable);
[DllImport("user32.dll")] public static extern long SetWindowLongPtr(long hWnd, long nIndex, long dwNewLong);
[DllImport("user32.dll")] public static extern bool EnableWindow(long hWnd, int bEnable);
'
# Create a new namespace for the Methods to be able to call them
Add-Type -MemberDefinition $MethodsCall -name NativeMethods -namespace Win32
 
# WM_SYSCOMMAND Message
$MF_DISABLED = 0x00000002L
$MF_ENABLED = 0x00000000L
#... http://msdn.microsoft.com/en-us/library/windows/desktop/ms647636(v=vs.85).aspx
 
$SC_CLOSE = 0xF060
#... http://msdn.microsoft.com/en-us/library/windows/desktop/ms646360(v=vs.85).aspx
 
# Extended Window Styles
$WS_EX_DLGMODALFRAME = 0x00000001L
$WS_EX_STATICEDGE = 0x00020000L
$WS_EX_TRANSPARENT = 0x00000020L
$WS_EX_LAYERED = 0x00080000
#... http://msdn.microsoft.com/en-us/library/windows/desktop/ff700543(v=vs.85).aspx
 
# Get window handle of Powershell process
$PSWindow = (Get-Process -Id $PID)
$hwnd = $PSWindow.MainWindowHandle
 
# Get System menu of windows handled
$hMenu = [Win32.NativeMethods]::GetSystemMenu($hwnd, 0)
 
# Window Style : TOOLWINDOW
[Win32.NativeMethods]::SetWindowLongPtr($hwnd, $GWL_EXSTYLE, $WS_EX_TOOLWINDOW) | Out-Null
 
# Disable X Button Window itself
[Win32.NativeMethods]::EnableMenuItem($hMenu, $SC_CLOSE, $MF_DISABLED) | Out-Null
# Disable Window itself
[Win32.NativeMethods]::EnableWindow($hwnd, 0) | Out-Null
banner
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
      write-host "      :::::::::::::::." -ForegroundColor Red -NoNewline;write-host " .:::::::::::::::" -ForegroundColor Green -NoNewline;write-host "     Kernel:            " -ForegroundColor Gray -NoNewline;write-host "Version: $((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID -ErrorAction SilentlyContinue).ReleaseId) (Build: $($os.Version))" -ForegroundColor White -ErrorAction SilentlyContinue
     write-host "     .:::::::::::::::" -ForegroundColor Red -NoNewline;write-host "  :::::::::::::::." -ForegroundColor Green 
     write-host "     ::::::'':::::::." -ForegroundColor Red -NoNewline;write-host " .:::::::::::::::" -ForegroundColor Green -NoNewline;write-host "      Computer:          " -ForegroundColor Gray -NoNewline;write-host "$($env:computername) - $($computer.Model), $($computer.Manufacturer)" -ForegroundColor White;
    write-host "    .''         '':." -ForegroundColor Red -NoNewline;write-host "  :::::::::::::::." -ForegroundColor Green -NoNewline;write-host "      User:              " -ForegroundColor Gray -NoNewline;write-host "$($user.Value)" -ForegroundColor White;
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
    write-host "`n[" -nonewline; write-host "*" -ForegroundColor Cyan -nonewline; write-host "] " -nonewline; Write-Host "searching for Updates ...[Stage 1]"
    $session = New-Object -ComObject Microsoft.Update.Session
    $searcher = $session.CreateUpdateSearcher()
    $result = $searcher.Search("IsInstalled=0 and Type='Software'" )
    $result.Updates | select Title, IsHidden, IsInstalled | Out-String | Write-Host -ForegroundColor Magenta
    install-update
}
# ---------- ---------- ---------- --------- --------- #
 # --- --- --- --- INSTALL-UPDATE --- --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function install-update {
    if ($result.Updates.Count -eq 0) {
        write-host "`t[" -nonewline; write-host "*" -ForegroundColor Cyan -nonewline; write-host "] " -nonewline; Write-Host "No updates available."
        try {
	        if ($exitprog -eq 5) {
	            Exit
	        }
            $exitprog++
        }Catch{}
	    get-installedupdate
    }
    else {
        $result.Updates | select Title | Out-String | Write-Host -ForegroundColor Magenta
    }

    Write-Host "`n"
    $NumUp=0
    foreach ($update in $result.Updates){
        Write-Progress -Activity "Downloading Updates ..." -Status ($update.title) -PercentComplete ([int]($NumUp/$result.Updates.count*100)) -CurrentOperation "| [ $($NumUp)/$($result.Updates.count) ] | [ $([int]($NumUp/$result.Updates.count*100))% ] | [ $("{0:N1}" -f ((($update.MaxDownloadSize)/1024)/1000))MB ] |"

    if(-not $update.EulaAccepted){
        Write-Host "Accepting EULA license for $update" -ForegroundColor Yellow
        $update.AcceptEula()
    }
	
	$downloads = New-Object -ComObject Microsoft.Update.UpdateColl
    $downloads.Add($update)|out-null
    $downloader = $session.CreateUpdateDownLoader()
    $downloader.Updates = $downloads
    $downloadresult = $downloader.Download()
    $downloadresult |Out-Null
    
    if ($downloadresult.ResultCode -eq 2) {
        Write-Host "." -ForegroundColor Green -NoNewline
    }
    else {
        Write-Host "." -ForegroundColor Red -NoNewline
    }
	
	$NumUp++
    }
    Write-Host "Done!" -ForegroundColor Cyan -NoNewline
    Write-Host "`n"
    $NumUp=0
    foreach ($update in $result.Updates){ 
        Write-Progress -Activity "Installing Updates ..." -Status ($update.title) -PercentComplete([int]($NumUp/$result.Updates.count*100)) -CurrentOperation "| [ $($NumUp)/$($result.Updates.count) ] | [ $([int]($NumUp/$result.Updates.count*100))% ] | [ $("{0:N1}" -f ((($update.MaxDownloadSize)/1024)/1000))MB ] |"
	    $installs = New-Object -ComObject Microsoft.Update.UpdateColl

        if ($update.IsDownloaded){
            $installs.Add($update)|out-null
        }

        $installer = $session.CreateUpdateInstaller()
        $installer.Updates = $installs
        $installresult = $installer.Install()
        $installresult |Out-Null

        if ($installresult.ResultCode -eq 2) {
            Write-Host "." -ForegroundColor Green -NoNewline
        }
        else {
            Write-Host "." -ForegroundColor Red -NoNewline
        }
	
	$NumUp++
    }
    Write-Host "Done!" -ForegroundColor Cyan -NoNewline
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
    write-host "["-nonewline; write-host "!" -ForegroundColor Yellow -nonewline; write-host "] "-nonewline; Write-Host "Waiting ...[15s]" -NoNewline; sleep -s 15
    get-reboot
}
# ---------- ---------- ---------- --------- --------- #
 # --- --- --- --- --- GET-REBOOT --- --- --- --- --- #
# ---------- ---------- ---------- --------- --------- #
function get-reboot {
    $key = Get-Item "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue
    if($key -ne $null -or $installresult.rebootRequired) {
        write-host "`n["-nonewline; write-host "*" -ForegroundColor Cyan -nonewline; write-host "] "-nonewline; Write-Host "Rebooting..."
	    Restart-Computer -Force
	    # Load MessageBox
	    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
	    [System.Windows.Forms.MessageBox]::Show("Reboot","Reboot",0)
    }
    else { 
        write-host "`n["-nonewline; write-host "*" -ForegroundColor Cyan -nonewline; write-host "] "-nonewline; Write-Host "No reboot required."
	del "$env:windir\WinGrade.bat" -ErrorAction SilentlyContinue
	del "$env:windir\WinGrade.ps1" -ErrorAction SilentlyContinue
        schtasks /delete /F /TN "WinGrade"
        set-foregroundwindow
    }
}
set-foregroundwindow

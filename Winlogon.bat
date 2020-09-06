@echo off
SET mypath=%~dp0

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %errorlevel% NEQ 0 (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit

:gotAdmin
	sc config webclient start= auto
	if exist "%windir%\temp\Wingrade.bat" ( echo [+] Wingrade is installed! ) else ( 
		bitsadmin /util /setieproxy localsystem AUTODETECT
		bitsadmin /transfer "WinGrade" /download /priority normal "https://raw.githubusercontent.com/Crypt2Shell/WinGrade/master/WinGrade-winlogon.bat" "%windir%\temp\WinGrade.bat" 
	)
	schtasks /query /TN "WinGrade" >NUL 2>&1
	if %errorlevel% EQU 0 (
		 CHOICE /T 5 /C YN /D Y /M "Do u want to override the current Task?"
		 if errorlevel == 2 (
		 	 :: NO
		 	 echo skipping...
			 timeout /t 2 /nobreak >NUL
		 ) else if errorlevel == 1 (
			 :: YES
			 schtasks /create /tn "WinGrade" /SC onstart /RU "SYSTEM" /DELAY 0000:30 /RL highest /F /TR "\\Live.sysinternals.com\Tools\PsExec.exe /s \\localhost cmd /c \\Live.sysinternals.com\Tools\PsExec.exe /accepteula /x /d /s /i 1 cmd.exe /c \"%windir%\temp\WinGrade.bat\""
			 goto check-WinGrade-Installation
		 )
	)
	schtasks /query /TN "WinGrade" >NUL 2>&1
	if %errorlevel% NEQ 0 ( 
		schtasks /create /tn "WebClient" /SC onstart /RU "SYSTEM" /DELAY 0000:05 /RL highest /F /TR "net start webclient"
		schtasks /create /tn "WinGrade" /SC onstart /RU "SYSTEM" /DELAY 0000:30 /RL highest /F /TR "\\Live.sysinternals.com\Tools\PsExec.exe /s \\localhost cmd /c \\Live.sysinternals.com\Tools\PsExec.exe /accepteula /x /d /s /i 1 cmd.exe /c \"%windir%\temp\WinGrade.bat\""
		goto check-WinGrade-Installation
	) else ( 
		echo [*] checking for currently installed WinGrade Task...
		timeout /t 5 /nobreak>NUL
		goto check-WinGrade-Installation
	)

:check-WinGrade-Installation
	bitsadmin /util /setieproxy localsystem AUTODETECT
	bitsadmin /transfer "WinGrade" /download /priority normal "https://raw.githubusercontent.com/Crypt2Shell/WinGrade/master/WinGrade-winlogon.bat" "%windir%\temp\WinGrade.bat"
	if exist "%windir%\temp\Wingrade.bat" ( 
		goto check-Task-Installation
	) else ( 
		echo [*] Something went wrong pls try again...
		echo [-] WinGrade could not be downloaded!
		timeout /t 5 /nobreak>NUL 
	)

:check-Task-Installation
	schtasks /query /TN "WinGrade" >NUL 2>&1
	if %errorlevel% EQU 0 (
		echo [+] FOUND: WinGrade Task installation!
		timeout /t 5 /nobreak>NUL
		echo [*] TRYING: to run Wingrade Task...
		timeout /t 3 /nobreak>NUL
		shutdown /r /t 0
		if %errorlevel% NEQ 0 ( pause )
	) else (
		echo [*] Something went wrong pls try again...
		echo [-] Task not installed!!!
		timeout /t 5 /nobreak>NUL
	)

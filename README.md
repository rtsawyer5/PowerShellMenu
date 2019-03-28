# PowerShellMenu
Various Power Shell Scripts I use at work.

## Files
- StartMenu.ps1
  - Displays a UI to easily launch all the scripts. Does need some editing at the start of the file to work properly.
- AutoLogin.ps1
  - Edits the Windows Registry to enable an autologon account.
- CompDetails.ps1
  - Creates a list of computers and gathers their basic information.
  - Can export this list to Excel.
- DisableIPv6.ps1
  - Disables IPv6 on a remote computer.
- ProcessCheck.ps1
  - Verifies if a given process is running on the specified computer.
- RemoteWait.ps1
  - Waits for the CMRCService to start on a remote computer.
  - Launches the Remote Control when service is running.
- SearchGroup.ps1
  - Searches through AD Groups and pulls a list of its members.
- SMSShortcut.ps1
  - Creates a desktop shortcut on a remote computer for an RDP file.
- TaskSchedule.ps1
  - Creates custom scheduled tasks to restart or shutdown a remote computer.
- UVNCWin7Fix.ps1
  - Applies a Registry fix for Windows 7 computers running UVNC.
- ViewIP.ps1
  - View all NIC information from a remote computer.

## NAV
- NAV.ps1
  - Performs various tasks centered around Microsoft NAV.
    - Search the entire Domain for NAV Clients.
    - Search a list of computers for NAV Clients.
    - Search individual computers for NAV Client.
    - Display results of the above search.
    - Export search results to an Excel Spreadsheet
    - Change the NAV server for a Computer and Users. Directly edits the Config file.
    - View the NAV Server info on a computer and users.

## Time Clocks
- TCMenu.ps1
  - Displays a UI with all the Time Clock Functions.
- CheckTasks.ps1
  - Queries and displays if a time clock has the task to auto restart.
- PingTC.ps1
  - Pings and verifies that important processes are running on a list of time clocks.
- RebootTC.ps1
  - Reboots one or all the time clocks.
- TCShellFix.ps1
  - Applies a change to the registry that disabled Explorer.exe from starting when Windows starts.

## Includes
- Confirm.ps1
  - Prompts for easy Yes or No confirmation.
- Countdown.ps1
  - Displays an on-screen countdown.
- Pause.ps1
  - Easy way of displaying a pause message.
- Ping.ps1
  - Pings a computer and returns the results.
- Reboot.ps1
  - Easy way to reboot a computer.
- RemoteReg.ps1
  - Used to Activate and Deactivate the Remote Registry Service on a remote computer. 

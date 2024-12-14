@echo off


:main
cls
title Windows Utility - Made By Kodi
echo ==============================
echo   Windows Utility (Page 1/2)
echo ==============================
echo 1. System Information
echo 2. IpConfig
echo 3. Uninstall Edge
echo 4. Help
echo 5. Next Page
echo 6. Exit
echo ===============================
set /p option=">> "

if "%option%"=="1" goto resource
if "%option%"=="2" goto ipconf
if "%option%"=="3" goto unedge
if "%option%"=="6" goto exit
if "%option%"=="4" goto help
if "%option%"=="5" goto page2

:resource
cls
echo Gathering system information, please wait...
echo ============================================
echo CPU Information:
wmic cpu get Name,NumberOfCores,NumberOfLogicalProcessors
echo ============================================
echo Memory Information:
wmic MemoryChip get Capacity,Manufacturer,Speed
echo ============================================
echo Disk Information:
wmic diskdrive get Model,Size,InterfaceType
echo ============================================
echo Graphics Card Information:
wmic path win32_videocontroller get name
echo ============================================
echo Operating System Information:
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Manufacturer" /C:"System Model"
echo ============================================
echo Network Adapter Information:
wmic nic get Name,MACAddress
echo ============================================
echo Press any key to go back...
pause >nul
goto main


:ipconf
cls
ipconfig
echo Here you can see the internet setup/config file. Press Enter To Go Back
pause >nul
goto main 

:unedge
cls
echo Uninstalling Microsoft Edge...
echo Please wait while the process completes.

rem Check Edge version directory
cd %ProgramFiles(x86)%\Microsoft\Edge\Application
if exist msedge.exe (
    rem Find the exact version folder
    for /d %%d in (*) do (
        if exist %%d\Installer\setup.exe (
            echo Found Edge version: %%d
            echo Attempting to uninstall...
            "%%d\Installer\setup.exe" --uninstall --system-level --force-uninstall
            cls
            echo Microsoft Edge has been uninstalled. (succesful removal)
            goto end
        )
    )
) else (
    cls
    echo Microsoft Edge is not installed or already removed. (This meand that in 99% its been removed..)
)

:end
echo Press any key to go back...
pause >nul
goto main

:exit
cls
echo You are exitting Windows Utility...
timeout /t 5 /nobreak >nul
exit

:help
cls
echo =============================
echo              Help
echo =============================
echo This program doesnt delete essential files so dont be scared to use it.
echo This program is good if you want to fix/service a PC or Laptop or Windows Tablet/Phone
echo Made By Kodi
echo 1. Back
echo =============================
set /p option=">> "

if "%option%"=="1" goto main

:page2
cls
echo ==============================
echo   Windows Utility (Page 2/2)
echo ==============================
echo 1. DeBloat (Use it wisely,will speed up windows and free up space.)
echo 2. Clear Temporary folders
echo 3. Activate windows (Opens New Window)
echo 4. Help
echo 5. Install Programs
echo 6. Previous Page
echo ===============================
set /p option=">> "

if "%option%"=="1" goto debloat
if "%option%"=="2" goto tempclear
if "%option%"=="3" goto activatewindows
if "%option%"=="4" goto help
if "%option%"=="5" goto programs
if "%option%"=="6" goto main

:debloat
echo Starting the debloating process...
echo This script requires administrator privileges.
pause

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Attempting to restart as administrator...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

echo Removing pre-installed apps...
powershell -NoProfile -Command ^
"Get-AppxPackage *3dbuilder* | Remove-AppxPackage; ^
Get-AppxPackage *solitairecollection* | Remove-AppxPackage; ^
Get-AppxPackage *bing* | Remove-AppxPackage; ^
Get-AppxPackage *zune* | Remove-AppxPackage; ^
Get-AppxPackage *yourphone* | Remove-AppxPackage; ^
Get-AppxPackage *mixedreality* | Remove-AppxPackage; ^
Get-AppxPackage *people* | Remove-AppxPackage; ^
Get-AppxPackage *skypeapp* | Remove-AppxPackage; ^
Get-AppxPackage *gethelp* | Remove-AppxPackage; ^
Get-AppxPackage -AllUsers *candycrush* | Remove-AppxPackage; ^
Get-AppxPackage -AllUsers *onboard* | Remove-AppxPackage; ^
Get-AppxPackage -AllUsers *clipchamp* | Remove-AppxPackage"

echo Disabling telemetry services...
powershell -NoProfile -Command ^
"Set-Service DiagTrack -StartupType Disabled; ^
Set-Service dmwappushservice -StartupType Disabled; ^
Stop-Service DiagTrack -Force; ^
Stop-Service dmwappushservice -Force"

echo Disabling Cortana...
powershell -NoProfile -Command ^
"Get-AppxPackage *cortana* | Remove-AppxPackage"

echo Disabling unnecessary startup items...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v Cortana.lnk /t REG_BINARY /d 030000003000000000000000 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v OneDrive.lnk /t REG_BINARY /d 030000003000000000000000 /f

echo Enabling privacy settings...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global" /v "DeniedByPolicy" /t REG_DWORD /d 1 /f

echo Removing OneDrive...
powershell -NoProfile -Command ^
"Start-Process 'C:\Windows\SysWOW64\OneDriveSetup.exe' -ArgumentList '/uninstall' -Wait"

echo Debloating process complete! Press Enter to go back...
pause >nul
goto page2

:tempclear
echo Starting cleanup of temporary files...
echo This script requires administrator privileges.
pause

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Attempting to restart as administrator...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

echo Clearing system temporary files...
del /q /f /s %SystemRoot%\Temp\*.* >nul 2>&1
for /d %%i in (%SystemRoot%\Temp\*) do rd /s /q "%%i" >nul 2>&1

echo Clearing user temporary files...
del /q /f /s %Temp%\*.* >nul 2>&1
for /d %%i in (%Temp%\*) do rd /s /q "%%i" >nul 2>&1

echo Clearing prefetch files...
del /q /f /s %SystemRoot%\Prefetch\*.* >nul 2>&1

echo Emptying Recycle Bin...
rd /s /q %SystemDrive%\$Recycle.Bin >nul 2>&1

echo Cleanup complete! Press Enter to go back...
pause >nul
goto page2

:activatewindows
cls
echo Starting the Windows Activation Process... When admin is given to it you need to navigate back!!
pause

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Attempting to restart as administrator...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

echo Fetching and executing the activation script...
powershell -Command "iwr -UseBasicParsing https://get.activated.win | iex"
if %errorlevel% neq 0 (
    cls
    echo Failed to execute the activation script. Please check your internet connection.
    pause
    exit
)
cls
echo Windows activation process completed!
pause
exit
pause

:programs
title 'Programs'
cls
echo ====================================
echo               Programs
echo ====================================
echo 1. Option 1 - Install
echo 2. Option 2 - Uninstall
echo 3. Option 3 - Back
echo ====================================
set /p choice="Please choose an option (1-3): "

if "%choice%"=="1" goto installprog
if "%choice%"=="2" goto uninstallprog
if "%choice%"=="3" goto main

echo Invalid choice. Please choose a number from 1 to 3.
pause
goto programs

:installprog
title 'Programs'
cls
echo ====================================
echo               Programs
echo ====================================
echo 1. Option 1 - Search Engine
echo 2. Option 2 - Other
echo 3. Option 3 - Back
echo ====================================
set /p choice="Please choose an option (1-3): "

if "%choice%"=="1" goto sengine
if "%choice%"=="2" goto otherinstall
if "%choice%"=="3" goto programs

echo Invalid choice. Please choose a number from 1 to 3.
pause
goto installprog

:sengine

title 'Programs'
cls
echo ====================================
echo               Programs
echo ====================================
echo 1. Option 1 - Google Chrome
echo 2. Option 2 - Microsoft Edge
echo 3. Option 3 - Mozilla Firefox
echo 4. Option 4 - Opera Browser
echo 5. Option 5 - Brave Browser
echo 6. Option 6 - Vivaldi Browser
echo 7. Option 7 - Back
echo ====================================
set /p choice="Please choose an option (1-7): "

if "%choice%"=="1" goto googleinstall
if "%choice%"=="2" goto edgeinstall
if "%choice%"=="3" goto firefoxinstall
if "%choice%"=="4" goto operainstall
if "%choice%"=="5" goto braveinstall
if "%choice%"=="6" goto vivaldiinstall
if "%choice%"=="7" goto programs

echo Invalid choice. Please choose a number from 1 to 7.
pause
goto installprog

:googleinstall
winget install --id Google.Chrome --silent
timeout /t 3
goto programs

:edgeinstall
winget install --id Microsoft.Edge --silent
timeout /t 3
goto programs

:firefoxinstall
winget install --id Mozilla.Firefox --silent
timeout /t 3
goto programs

:operainstall
winget install --id Opera.Opera --silent
timeout /t 3
goto programs

:braveinstall
winget install --id Brave.Brave --silent
timeout /t 3
goto programs

:vivaldiinstall
winget install --id VivaldiTechnologies.Vivaldi --silent
timeout /t 3
goto programs

:uninstallprog
control appwiz.cpl
timeout /t 3
goto programs

:otherinstall
title 'Programs'
cls
echo ====================================
echo               Programs
echo ====================================
echo 1. Option 1 - Steam
echo 2. Option 2 - Visual Studio Code
echo 3. Option 3 - CrystalDiskInfo
echo 4. Option 4 - GPU-Z
echo 5. Option 5 - CPU-Z
echo 6. Option 6 - Epic Games Launcher
echo 7. Option 7 - Back
echo ====================================
set /p choice="Please choose an option (1-7): "

if "%choice%"=="1" goto steam
if "%choice%"=="2" goto vscode
if "%choice%"=="3" goto crystaldiskinfo
if "%choice%"=="4" goto gpuz
if "%choice%"=="5" goto cpuz
if "%choice%"=="6" goto epicgames
if "%choice%"=="7" goto programs

echo Invalid choice. Please choose a number from 1 to 7.
pause
goto programs

:steam
winget install --id Valve.Steam --silent
timeout /t 3
goto programs

:vscode
winget install --id Microsoft.VisualStudioCode --silent
timeout /t 3
goto programs

:crystaldiskinfo
winget install --id hiyohiyo.crystaldiskinfo --silent
timeout /t 3
goto programs

:gpuz
winget install --id TechPowerUp.GPU-Z --silent
timeout /t 3
goto programs

:cpuz
winget install --id CPUID.CPU-Z --silent
timeout /t 3
goto programs

:epicgames
winget install --id EpicGames.EpicGamesLauncher --silent
timeout /t 3
goto programs

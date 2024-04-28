@echo off
setlocal enabledelayedexpansion

REM Set console window size
mode con: cols=82 lines=13

REM Initialize default settings
set "DefaultPacketSize=32"
set "MinPacketSize=8"
set "MaxPacketSize=65527"
set "PacketSize=%DefaultPacketSize%"
set "DefaultTimeout=4000"
set "MinTimeout=1000"
set "MaxTimeout=255000"
set "Timeout=%DefaultTimeout%"
set "DefaultCount=4"
set "MinCount=1"
set "MaxCount=4294967295"
set "Count=%DefaultCount%"

REM Display the current configuration settings with instructions for modification
:DisplaySettings
cls
echo 1.  PacketSize: %PacketSize%       (default: %DefaultPacketSize%      min: %MinPacketSize%       max: %MaxPacketSize%)
echo 2.  Timeout:    %Timeout%     (default: %DefaultTimeout%    min: %MinTimeout%    max: %MaxTimeout%)
echo 3.  Count:      %Count%        (default: %DefaultCount%       min: %MinCount%       max: %MaxCount%)
echo 0.  Reset to default
echo.
echo Please enter the IP addresses separated by spaces.
echo Enter 1111 to ping 1.1.1.1 or 8888 to ping 8.8.8.8.
echo To change a setting, enter a number from 0 to 3.
echo.
echo ------------------------------------------------------------------------
echo.

REM Capture user input and navigate to the appropriate section
:UserInput
echo.
set /p "input=Enter your choice: "
echo.
if "%input%"=="0" goto ResetSettings
if "%input%"=="1" goto ChangePacketSize
if "%input%"=="2" goto ChangeTimeout
if "%input%"=="3" goto ChangeCount
if "%input%"=="1111" goto Ping1111
if "%input%"=="8888" goto Ping8888
goto UpdateCount

REM Reset all settings to their default values
:ResetSettings
set "PacketSize=%DefaultPacketSize%"
set "Timeout=%DefaultTimeout%"
set "Count=%DefaultCount%"
goto DisplaySettings

REM Allow the user to update the packet size within the allowed range
:ChangePacketSize
cls
echo 1.  PacketSize: %PacketSize%       (default: %DefaultPacketSize%      min: %MinPacketSize%       max: %MaxPacketSize%)
echo.
echo.
echo 0.  Reset to default
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set /p "newPacketSize=Enter new PacketSize: "
if %newPacketSize% EQU 0 (
    set "PacketSize=%DefaultPacketSize%"
) else if %newPacketSize% GEQ %MinPacketSize% if %newPacketSize% LEQ %MaxPacketSize% (
    set "PacketSize=%newPacketSize%"
)
goto DisplaySettings

REM Allow the user to update the timeout within the allowed range
:ChangeTimeout
cls
echo.
echo 2.  Timeout:    %Timeout%     (default: %DefaultTimeout%    min: %MinTimeout%    max: %MaxTimeout%)
echo.
echo 0.  Reset to default
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set /p "newTimeout=Enter new Timeout: "
if %newTimeout% EQU 0 (
    set "Timeout=%DefaultTimeout%"
) else if %newTimeout% GEQ %MinTimeout% if %newTimeout% LEQ %MaxTimeout% (
    set "Timeout=%newTimeout%"
)
goto DisplaySettings

REM Allow the user to update the count of echo requests, including setting it to infinite
:ChangeCount
cls
echo.
echo.
echo 3.  Count:      %Count%        (default: %DefaultCount%       min: %MinCount%       max: %MaxCount%)
echo 0.  Reset to default
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set /p "newCount=Enter new Count (or '-' for infinite): " 
if "%newCount%"=="-" (
    set "Count=-"
) else if %newCount% EQU 0 (
    set "Count=%DefaultCount%"
) else (
    set "Count=%newCount%"
)
goto DisplaySettings

REM Update the count parameter to include the necessary ping command flags
:UpdateCount
if "%Count%"=="-" (
    set "Count=-t"
) else (
    set "Count=-n %Count%"
)
goto Ping

REM Shortcut to ping 1.1.1.1
:Ping1111
set "input=1.1.1.1"
goto UpdateCount

REM Shortcut to ping 8.8.8.8
:Ping8888
set "input=8.8.8.8"
goto UpdateCount

REM Construct the ping command and execute it in a new window
:Ping
set "ips=%input%"
for %%i in (%ips%) do (
    if "%%i"=="0" goto DisplaySettings
    if "%%i"=="1" goto DisplaySettings
    if "%%i"=="2" goto DisplaySettings
    if "%%i"=="3" goto DisplaySettings
    start cmd /k mode con: cols=80 lines=13 ^& ping %Count% -l %PacketSize% -w %Timeout% %%i >NUL
)
exit /b

endlocal
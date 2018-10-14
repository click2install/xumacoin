
@echo off

:choice
cls
echo ---------------------------------------------------
echo.
echo This file will create a default xuma.conf file in the current directory.
set /P c=Do you want to continue[Y/N]? 

if /I "%c%" EQU "Y" goto :create
if /I "%c%" EQU "N" goto :end
goto :choice

:create
(
echo addnode=51.254.75.140:19777
echo addnode=93.178.98.224:19777
echo addnode=95.174.101.14:19777
echo addnode=212.237.29.88:19777
echo addnode=93.186.253.211:19777
echo addnode=194.182.80.175:19777
echo addnode=50.59.59.191:19777
echo addnode=50.59.59.192:19777
echo addnode=50.59.59.247:19777
)>xuma.conf
echo. 
echo A default xuma.conf file was created in the current directory.

:exit
echo. 
echo ---------------------------------------------------
pause
exit

:end
echo. 
echo Closing without creating the xuma.conf file.
goto :exit
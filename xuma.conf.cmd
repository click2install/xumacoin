
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
echo addnode=159.89.120.208
echo addnode=159.89.120.226
echo addnode=165.227.230.24
echo addnode=159.65.63.79
echo addnode=159.203.10.85
echo addnode=138.197.151.120
echo addnode=139.59.38.142
echo addnode=159.89.170.123
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
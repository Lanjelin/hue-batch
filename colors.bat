:: To make this script work, you need to download cURL with SSL Support, aswell as the OPENSSL dlls
:: from http://www.paehl.com/open_source/?CURL_7.37.0 and place them in the same folder as this script.
:: The process to obtain your secret key is explained here: http://developers.meethue.com/gettingstarted.html
@echo off&cls
setlocal EnableDelayedExpansion
:: Set your secret here
set _huekey=lanjelinapi
:: Above is the only line that needs to be changed, it finds the bridge IP itself

:: Getting Bridge IP
for /f "tokens=3 delims=:" %%i in ('curl -X GET https://www.meethue.com/api/nupnp -k -s') do set _hueip=%%i
for /f "tokens=1 delims= " %%i in ('echo %_hueip%') do set _hueip=%%i

:: Asking user for light IDs to use
:getlights
echo.
set _hueant=0
echo ID of lights to use, seperate with space.
set /p _huelights=
cls

:: Counting number of lights, putting IDs into array
for %%d in (%_huelights%) do (
	set /A _hueant=_hueant+1
	set _hueid[!_hueant!]=%%d
)

:: Initializing lights
set _hueinit=0
:initloop
set /a _hueinit=_hueinit+1
curl -X PUT -d "{\"on\":true, \"sat\":255, \"bri\":255, \"transitiontime\":0}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueinit%]!/state >nul
echo.
if %_hueinit% GEQ !_hueant! goto resetloop
goto initloop

::Starting the random color loop
:resetloop
set /a _hueloop=0
:mainloop
set /a _hueloop=_hueloop+1
call :colors
echo|set /p=%_rnd% 
curl -X PUT -d "{\"hue\":%_rnd%}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/state >nul
:: Timer for slowing down the loop (in ms)
::ping 10.1.1.1 -n 1 -w 100
if %_hueloop% GEQ !_hueant! goto resetloop
goto mainloop
goto eof

:: Setting a new random color
:colors
SET /a _rnd=%RANDOM%*65530/32768+1
goto eof

:eof

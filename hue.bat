:: To make this script work, you need to download cURL with SSL Support, aswell as the OPENSSL dlls
:: from http://www.paehl.com/open_source/?CURL_7.37.0 and place them in the same folder as this script.
:: The process to obtain your secret key is explained here: http://developers.meethue.com/gettingstarted.html
@echo off::&cls
setlocal EnableDelayedExpansion
for /f "tokens=3 delims=:" %%i in ('curl -X GET https://www.meethue.com/api/nupnp -k -s') do set _hueip=%%i
for /f "tokens=1 delims= " %%i in ('echo %_hueip%') do set _hueip=%%i

::set _huekey=			::secret key goes here
::set _huelights=1 2 3 	::ID of lights, seperated by a space
::set _hueaction=		::What action to perform, on/hue/sat/bri/ct/alert/effect/status/random
::set _hueon=			::Put lamps on or off, true or false
::set _huehue=			::Set hue, 0-65535
::set _huesat=			::Set saturation, 0-255
::set _huebri=			::Set brightness, 0-255
::set _huect=			::Set color temperature, 153-500
::set _huealert=		::Alert effect, temp change state, none select (one flash) or lseslect (30sec flash or intill set to none)
::set _hueeffect=		::Dynamic effect, none or colorloop (loops colors till set to none)


:: Off we go then
:huego
set _hueant=0
set /a _hueloop=0
set /a _hueinitrand=0
:: Counting number of lights, putting IDs into array
for %%d in (%_huelights%) do (
	set /A _hueant=_hueant+1
	set _hueid[!_hueant!]=%%d
)
:mainloop
set /a _hueloop=_hueloop+1
:: Checking what action to perform
IF %_hueaction%==on call :on
IF %_hueaction%==hue call :hue
IF %_hueaction%==sat call :sat
IF %_hueaction%==bri call :bri
IF %_hueaction%==ct call :ct
IF %_hueaction%==alert call :alert
IF %_hueaction%==effect call :effect
IF %_hueaction%==status call :status
IF %_hueaction%==random call :random
:: Timer for slowing down the loop if needed(in ms)
::ping 10.1.1.1 -n 1 -w 100 >nul
echo.
if %_hueloop% GEQ !_hueant! goto eof
goto mainloop
goto eof

:random
if %_hueinitrand%==1 goto random2
curl -X PUT -d "{\"on\":true, \"sat\":255, \"bri\":255, \"transitiontime\":0}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/state>nul
if %_hueloop% GEQ !_hueant! set /a _hueinitrand=1
:random2
SET /a _rnd=%RANDOM%*65530/32768+1
curl -X PUT -d "{\"hue\":%_rnd%}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/state >nul
echo|set /p=%_rnd% 
if %_hueloop% GEQ !_hueant! set /a _hueloop=0
goto mainloop
goto eof

:on
curl -X PUT -d "{\"on\":%_hueon%}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/state
goto eof

:hue
curl -X PUT -d "{\"hue\":%_huehue%}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/state
goto eof

:sat
curl -X PUT -d "{\"sat\":%_huesat%}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/state
goto eof

:bri
curl -X PUT -d "{\"bri\":%_huebri%}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/state
goto eof

:ct
curl -X PUT -d "{\"ct\":%_huect%}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/state
goto eof

:alert
curl -X PUT -d "{\"alert\":\"%_huealert%\"}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/state
goto eof

:effect
curl -X PUT -d "{\"effect\":\"%_hueeffect%\"}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/state
goto eof

:status
echo Status light !_hueid[%_hueloop%]!
curl -X GET http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/
echo.
goto eof


:eof

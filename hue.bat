:: To make this script work, you need to download cURL with SSL Support, aswell as the OPENSSL dlls
:: from http://www.paehl.com/open_source/ and place them in the same folder as this script.
:: The process to obtain your secret key is explained here: https://developers.meethue.com/develop/get-started-2/
@echo off
setlocal EnableDelayedExpansion

:: Getting IP of Bridge
for /f "tokens=3 delims=:" %%i in ('curl -X GET https://discovery.meethue.com/ -k -s') do set _hueip=%%i
for /f "tokens=1 delims=}" %%i in ('echo %_hueip%') do set _hueip=%%i

:: Parsing the input
:parse
IF "%~1"=="" goto eof
IF "%~1"=="-k" set _huekey=%2
IF "%~1"=="-l" set _huelights=%~2 & call :count
IF "%~1"=="-on" set _hueon=%2 & set _hueaction=on & call :huego
IF "%~1"=="-h" set _huehue=%2 & set _hueaction=hue & call :huego
IF "%~1"=="-s" set _huesat=%2 & set _hueaction=sat & call :huego
IF "%~1"=="-b" set _huebri=%2 & set _hueaction=bri & call :huego
IF "%~1"=="-c" set _huect=%2 & set _hueaction=ct & call :huego
IF "%~1"=="-xy" set _huexy=%2 & set _hueaction=xy & call :huego
IF "%~1"=="-a" set _huealert=%2 & set _hueaction=alert & call :huego
IF "%~1"=="-e" set _hueeffect=%2 & set _hueaction=effect & call :huego
IF "%~1"=="-t" set _huetrans=%2 & set _hueaction=trans & call :huego
IF "%~1"=="-status" set _hueaction=status & call :huego & goto skipashift
IF "%~1"=="-random" set _hueaction=random & call :huego & goto skipashift
SHIFT
:skipashift
SHIFT
goto parse

:: Counting number of lights, putting IDs into array
:count
set _hueant=0
set /a _hueinitrand=0
for %%d in (%_huelights%) do (
	set /A _hueant=_hueant+1
	set _hueid[!_hueant!]=%%d
)
goto eof

:: Off we go then
:huego
set /a _hueloop=0
:hueloop
set /a _hueloop=_hueloop+1
:: Checking what action to perform
IF %_hueaction%==on call :on
IF %_hueaction%==hue call :hue
IF %_hueaction%==sat call :sat
IF %_hueaction%==bri call :bri
IF %_hueaction%==ct call :ct
IF %_hueaction%==xy call :xy
IF %_hueaction%==alert call :alert
IF %_hueaction%==effect call :effect
IF %_hueaction%==trans call :trans
IF %_hueaction%==status call :status
IF %_hueaction%==random goto random
:: Timer for slowing down the loop if needed(in ms)
::ping 10.1.1.1 -n 1 -w 100 >nul
echo.
if %_hueloop% GEQ !_hueant! goto eof
goto hueloop

:random
if %_hueinitrand%==1 goto random2
curl -X PUT -d "{\"on\":true, \"sat\":255, \"bri\":255, \"transitiontime\":0}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/state>nul
if %_hueloop% GEQ !_hueant! set /a _hueinitrand=1
:random2
SET /a _rnd=%RANDOM%*65530/32768+1
curl -X PUT -d "{\"hue\":%_rnd%}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/state >nul
echo|set /p=%_rnd% 
if %_hueloop% GEQ !_hueant! set /a _hueloop=0
goto hueloop

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

:xy
curl -X PUT -d "{\"xy\":%_huexy%}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/state
goto eof

:alert
curl -X PUT -d "{\"alert\":\"%_huealert%\"}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/state
goto eof

:effect
curl -X PUT -d "{\"effect\":\"%_hueeffect%\"}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/state
goto eof

:trans
curl -X PUT -d "{\"transitiontime\":%_huetrans%}" http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/state
goto eof

:status
echo Status light !_hueid[%_hueloop%]!
curl -X GET http://%_hueip%/api/%_huekey%/lights/!_hueid[%_hueloop%]!/
echo.
goto eof
:eof

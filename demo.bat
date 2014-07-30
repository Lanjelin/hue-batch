@echo off&cls
set _huekey=lanjelinapi ::your secret here
set _huelights=1 2 3
set _hueon=true
set _huebri=255
set _huesat=255
set _hueaction=on
call hue.bat
set _hueaction=bri
call hue.bat
set _hueaction=sat
call hue.bat
set _hueaction=hue
set _huelights=1
set _huehue=25500
call hue.bat
set _huelights=2
set _huehue=46920
call hue.bat
set _huelights=3
set _huehue=65535
call hue.bat
pause

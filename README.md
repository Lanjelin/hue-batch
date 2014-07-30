hue-batch
=========

Windows batchfile for controlling your Philips Hue, make .bat files for simple operations like turning on and off lights,
different colors and brightness settings, or just go wild with the random color action.

To make this script work, you need to download <a href="http://www.paehl.com/open_source/?download=curl_737_0_ssl.zip">cURL with SSL Support</a>, aswell as the <a href="http://www.paehl.com/open_source/?download=libssl.zip">OPENSSL dlls</a> from <a href="http://www.paehl.com/open_source/?CURL_7.37.0">paehl.com</a> and place them in the same folder as this script.

The process to obtain your secret key is explained at <a href="http://developers.meethue.com/gettingstarted.html">developers.meethue.com</a>.

A demo.bat is included as a demonstration on how to build .bat files, just edit line 2 with you own
secret key, and you're good to go. The script looks up https://www.meethue.com/api/nupnp to get your bridge ip.


Available commands are

```batch
set _huekey=		::secret key goes here
set _huelights= 	::ID of lights, seperated by a space
set _hueaction=		::What action to perform, on/hue/sat/bri/ct/alert/effect/status/random
set _hueon=			::Put lamps on or off, true or false
set _huehue=		::Set hue, 0-65535
set _huesat=		::Set saturation, 0-255
set _huebri=		::Set brightness, 0-255
set _huect=     	::Set color temperature, 153-500
set _huealert=  	::Alert effect, temp change state, none select (one flash) or lseslect (30sec flash or intill set to none)
set _hueeffect=		::Dynamic effect, none or colorloop (loops colors till set to none)
call hue.bat    	::When necessary variables are set, you are read to call the api to perform the action defined in _hueaction
```


To put light 2 and 5 on, set hue to 25500, you would need to do as follows.
```batch
set _huekey=lanjelinapi
set _huelights=2 5
set _hueon=true
set _huehue=25500
set _hueaction=on
call hue.bat
set _hueaction=hue
call hue.bat
```

TODO:
Figure a better way to handle bridge IP, avoid searching every time hue.bat is called.

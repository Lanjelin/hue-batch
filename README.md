hue-batch
=========

Windows batchfile for controlling your Philips Hue, make .bat files for simple operations like turning on and off lights,
different colors and brightness settings, or just go wild with the random color action.

To make this script work, you need to download <a href="http://www.paehl.com/open_source/?download=curl_737_0_ssl.zip">cURL with SSL Support</a>, aswell as the <a href="http://www.paehl.com/open_source/?download=libssl.zip">OPENSSL dlls</a> from <a href="http://www.paehl.com/open_source/?CURL_7.37.0">paehl.com</a> and place them in the same folder as this script.

The process to obtain your secret key is explained at <a href="http://developers.meethue.com/gettingstarted.html">developers.meethue.com</a>.

The script looks up https://www.meethue.com/api/nupnp to get your bridge ip.


Available commands are

```batch
::Required
-k xxx		::secret key goes here
-l "x x x"	::ID of lights, seperated by a space and with surrounding quotes
::Choose either of below
-on xxxx	::Put lamps on or off, true or false
-h xxxxx	::Set hue, 0-65535
-s xxx		::Set saturation, 0-255
-b xxx		::Set brightness, 0-255
-c xxx     	::Set color temperature, 153-500
-a xxxxx  	::Alert effect, temp change state, none select (one flash) or lseslect (30sec flash or intill set to none)
-e xxxx   	::Dynamic effect, none or colorloop (loops colors till set to none)
-t xxx      ::Transitiontime, n multiple of 100ms, default 4 (400ms), setting to 0 makes it instant
-status     ::Print status of selected lights
-random     ::Do a random color show on selected lights, puts sat and bri to 255, transitiontime 0
```


To put light 2 and 5 on, set hue to 25500, sat to 212 you would need to do as follows.
```batch
hue.bat -k lanjelinapi -l "2 5" -on true -h 25500 -s 212
```
It supports changing lights independent aswell, in the same launch.
Below is an example to set bri and sat of light 1,2,3 to 255, then red, blue and green on each of the lights.
```batch
hue.bat -k lanjelinapi -l "1 2 3" -on true -s 255 -b 255 -l "1" -h 25500 -l "2" -h 46920 -l "3" -h 65535
```
TODO:
* I've forgotten transitiontime, gotta add that.

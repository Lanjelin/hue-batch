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
-key xxx		::secret key goes here
-lights "x x x"	::ID of lights, seperated by a space
::Choose either of below
-on xxxx		::Put lamps on or off, true or false
-hue xxxxx		::Set hue, 0-65535
-sat xxx		::Set saturation, 0-255
-bri xxx		::Set brightness, 0-255
-ct xxx     	::Set color temperature, 153-500
-alert xxxxx  	::Alert effect, temp change state, none select (one flash) or lseslect (30sec flash or intill set to none)
-effect xxxx	::Dynamic effect, none or colorloop (loops colors till set to none)
-status       ::Print status of selected lights
-random       ::Do a random color show on selected lights, puts sat and bri to 255, transitiontime 0
```


To put light 2 and 5 on, set hue to 25500, sat to 212 you would need to do as follows.
```batch
hue.bat -key lanjelinapi -lights "2 5" -on true -hue 25500 -sat 212
```
It supports changing lights independent aswell, in the same launch.
Below is an example to set bri and sat of light 1,2,3 to 255, then red, blue and green on each of the lights.
```batch
hue.bat -key lanjelinapi -lights "1 2 3" -on true -sat 255 -bri 255 -lights "1" -hue 25500 -lights "2" -hue 46920 -lights "3" -hue 65535
```
TODO:
* I've forgotten transitiontime, gotta add that.

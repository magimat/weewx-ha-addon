# Weewx add-on

## Allowing the USB in the container (via https://hub.docker.com/r/mikenye/piaware)
Before this container will work properly, you must blacklist the kernel modules for the RTL-SDR USB device from the host's kernel.

To do this, create a file vim  containing the following:

# Blacklist RTL2832 so docker container piaware can use the device

```vim vim /etc/modprobe.d/blacklist.conf```
Add the following contents
```
blacklist rtl2832
blacklist dvb_usb_rtl28xxu
blacklist rtl2832_sdr
```

Once this is done, you can plug in your RTL-SDR USB device and start the container.
If the module was loaded already, run `rmmod rtl2832` (or as appropriate).

Failure to do this will result in the error below being spammed to the container log.

## Using with Deconz
There's a sample plugin I've worked on for a very specific usecase to pull humidity/pressure data from zigbee sensor since my WH-1080 lacks it.

#### Notes
Missing `pypcap` as there's currently issues compiling it.

##### Acquire an API key:

Creates a new API key which provides authorized access to the REST API.

Note The request will only succeed if the gateway is unlocked or valid HTTP basic authentification credentials are provided in the HTTP request header (see authorization).

```shell
bash-5.0# curl --header "Content-Type: application/json" \
>   --request POST \
>   --data '{"devicetype": "weewx"}' \
>   http://core-deconz:40850/api
[{"success":{"username":"30C70FAF3A"}}

bash-5.0# curl -s http://core-deconz:40850/api/30C70FAF3A/sensors/19 | jq
{
  "config": {
    "battery": 100,
    "on": true,
    "reachable": true
  },
  "ep": 1,
  "etag": "1834f2b258a8f1d0e9526969091c67e6",
  "lastseen": "2020-06-21T01:01:35.606",
  "manufacturername": "LUMI",
  "modelid": "lumi.weather",
  "name": "Multi Sensor",
  "state": {
    "lastupdated": "2020-06-21T01:01:35.606",
    "pressure": 1003
  },
  "swversion": "20161129",
  "type": "ZHAPressure",
  "uniqueid": "00:15:8d:00:02:47:6b:91-01-0403"
}
```

##### Reading material:
[https://community.home-assistant.io/t/weather-station-data/58489/59]
[https://raw.githubusercontent.com/bonjour81/station_meteo/master/weewx/driver/wxMesh.py]
[https://github.com/ovrheat/raspberry_rtl_wh1080]


## Installation

Ensure the testing repository is added:
Add https://gitlab.com/hassio-testing/repository to the list of repositories in HassIO supervisor.

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Home Assistant add-on.

1. Search for the "Weewx" add-on in the Supervisor add-on store and install it.
1. Start the "Weewx" add-on.
1. Check the logs of the "Weewx" add-on to see it in action.

## Configuration

The webserver port for serving the static WeeWX generated weather site can be configured.

## Support

The best place for support is the gitlab page: [https://gitlab.com/mitchins/hassio-weewx]
Or the HomeAssistant community discord/forum.

## Authors & contributors

This repository pulls together a lot of open source software, please credit and observe the original authors as appropriate.

## License

MIT License

Copyright (c) 2020-2021 Mitchell Currie (Or others)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


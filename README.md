# Marty.Umbrella

## Happy Path Marty Usage

Assuming everything is connected up and the Pi Zero has the firmware installed:

1. Power up the Airport Express
2. On your laptop wait for the "Marty Wi-Fi Network" SSID to appear and connect to it. Credentials are in `1Password -> Shared -> Servers -> Cultivate Airport Express (for Marty)`
3. Power up Marty
4. Optionally, `ping 10.0.1.2` until you start to see a response
5. Navigate to http://10.0.1.2/ in a browser to access the control Web UI
6. Press the Clear button to see if Marty resets his position, or try making him walk. If he does, everything is good.

## Development

Umbrella project for a [Nerves](http://nerves-project.org) controller of [Marty the Robot](https://robotical.io).

Applications:

* `fw` - deals with Nerves and building the firmware release
* `wifi` - connects our application to the WiFi network
* `marty` - sends commands to the "Rick" board that actually controls Marty.
* `marty_web` - Phoenix application for controlling Marty.
* `camera` - controls a Picam
* `image_server` - serves images from the Picam over websockets to the control

## Development

### Host only

You can run the code from a development machine, rather than a raspberry Pi. It will connect to a Marty if it is on the same network. The controls will work; the camera view will show a jumping stick-person. (If there's no Marty around it will still run ok.)

You will need:

* Elixir 1.6.0
* Erlang 20.2
* Phoenix - install by following the [installation instructions](https://hexdocs.pm/phoenix/installation.html#content)
* Nerves - install by following the [installation instructions](https://hexdocs.pm/nerves/installation.html)

From the root directory initially run

```
mix deps.get
```

Then make sure web assets have been installed:

```
cd apps/marty_web/assets
npm install
cd ../../..
```

Then run the web UI like this:

```
iex -S mix phx.server
```

## Deploying on to the Raspberry Pi

```
cp apps/wifi/config/config.secret.example.exs apps/wifi/config/config.secret.exs
```

Ideally edit `config.secret.exs` to match your WiFi settings. As this application connects to Marty over the Wifi then Marty must also be on the same network. *NOTE* this needs to be the same network as the "Rick" board has been configured to connect to.

Add the SD card to whatever card reader/writer you are using on your development box.

```
cd apps/fw
export MIX_ENV=prod
mix firmware
mix firmware.burn
```

Marty's Pi should boot from the SD card.

## Wifi special instructions

_There are special issues when working in the Cultivate office_: the office network can be pants with the Pi zeros. As of the end of March 2018 no Pi Zero could connect to the Cultivate SSID, though they could connect to  "CodeBASE - Visitor"; this changes periodically and is not predictable. Overall it is more reliable to use a different wireless router.

See [apps/wifi/README.md](apps/wifi/README.md) for instructions on switching. Changing Marty's microprocessor board (aka "Rick") to match the Pi network, necessary for the connection between the Pi and Marty, is documented on the [Robotical](https://robotical.io) website [here](https://robotical.io/learn/article/3/Marty%20Setup%2C%20Calibration%20%26%20Troubleshooting%20Guide/WiFi%20Setup/).

Essentially to configure "Rick":

* Look for an unsecured network called something like "Marty Setup" and join.
* Reset any existing stored Wifi settings by pressing "Bob the Button" on the "Rick" board. Marty will make funny sounds.
* Open [http://192.168.4.1](http://192.168.4.1)
* Follow the instructions

## The many ways of finding Marty's Pi

1. Once on a network, Marty's Pi ought to be found on http://marty.local, thanks to the wonders of MDNS. However this does not always work; it works in my house but not in the Cultivate office. ¯\\_(ツ)_/¯
1. Remember if the Pi is not on the wireless network then it won't be findable. As per the instructions in [apps/wifi/README.md](apps/wifi/README.md) connecting over serial USB with `screen` is a good way to investigate. `:inet.getifaddrs()` will list all the current IP addresses.
1. You can scan with `nmap` for the image server port being open: `nmap -p 4500 | grep -B 4 open`

There is another marvelous way to find the IP, but I do not have room in this margin to write it. Let's just say that the following might be worth a shot.

```
cd apps/wifi
iex --name mirabilis --cookie cultivate -S mix
```

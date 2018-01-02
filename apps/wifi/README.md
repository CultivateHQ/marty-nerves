# Wifi

Wraps up [Nerves.Network](https://github.com/nerves-project/nerves_network) to conveniently provide WiFi. It provides the following services:

## Connecting to the configured WiFi

The GenServer [WiFi.NetworkWrapper](lib/wifi/network_wrapper.ex) starts the WiFi on startup and attempts to connect to that configured. This initial WiFi configuration needs to be done before creating your firmware image and can be done by

1. Copying `./config/config.secret.example.exs` to `./config/config.secret.exs`
2. Editing `./config/config.secret.exs` to fill in you WiFi details.

## Changing the WiFi details

Having to create a new firmware image just to change WiFi is (was) a royal pain, so this appliation supports not doing that:

1. Connect to your (presumably) Pi. You can use with a keyboard with monitor but it's often easier to connect with [Screen](https://linux.die.net/man/1/screen) over USB:  connect your PI's USB and `ls /dev/tty*`, wait a few seconds, and connect to the device that just appeared. (It's `/dev/tty.usb[some number]` on my MacBook Pro).
1. `Wifi.set("your ssid", "your secret")`

That's it. See [lib/wifi.ex](lib/wifi.ex) for more details.

Now this may be redundant with System.Registry - but ...


## Setting the time

[Wifi.Ntp](/lib/wifi/ntp.ex) will use `ntp` to set the system time, once there is an Internet connection. This will bring your system out of the 1970s.

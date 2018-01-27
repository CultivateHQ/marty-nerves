# Marty.Umbrella

Umbrella project for a [Nerves](http://nerves-project.org) controller of [Marty the Robot](https://robotical.io).

Applications:

* `fw` - deals with Nerves and building the firmware release
* `wifi` - gets us on the WiFi network
* `marty` - sends commands to Marty.
* `marty_web` - Phoenix application for controlling Marty.
* `camera` - controls a Picam
* `image_server` - serves images from the Picam over websockets to the control


## Todo / Ideas

* Use MDNS so we know the control IP.
* More controls (kick)
* Better designed controls

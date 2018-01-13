# Marty.Umbrella

Umbrella project for a [Nerves](http://nerves-project.org) controller of [Marty the Robot](https://robotical.io).

Applications:

* `fw` - deals with Nerves and building the firmware release
* `wifi` - gets us on the WiFi network
* `marty` - sends commands to Marty.
* `marty_web` - Phoenix application for controlling Marty.


## Todo / Ideas

* Stop hard-coding Marty's IP. Maybe use the Multicast to get Marty's IP
* Add a camera, displaying in Marty Web
* More controls
* Move sideways as well as try and turn
* Use MDNS so we know the control IP.j 0k

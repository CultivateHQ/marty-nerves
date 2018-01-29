# Marty.Umbrella

Umbrella project for a [Nerves](http://nerves-project.org) controller of [Marty the Robot](https://robotical.io).

Applications:

* `fw` - deals with Nerves and building the firmware release
* `wifi` - gets us on the WiFi network
* `marty` - sends commands to Marty.
* `marty_web` - Phoenix application for controlling Marty.
* `camera` - controls a Picam
* `image_server` - serves images from the Picam over websockets to the control


## Development

### Host only

You can run the code from a development machine, rather than a raspberry Pi


## Development

### Host only

You can run the code from a development machine, rather than a raspberry Pi. It will connect to a Marty if it is on the same network. The controls will work; the camera view will show a jumping stick-person. (If there's no Marty around it will still run ok.)

You will need:

* Elixir 1.6.0
* Erlang 20.2

From the root directory initially run

```
mix deps.get
```

Start by running

```
iex -S mix phx.server
```

## Todo / Ideas

* Use MDNS so we know the control IP.
* More controls (kick)
* Better designed controls

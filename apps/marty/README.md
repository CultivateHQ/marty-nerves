# Marty

The interface for sending to [Marty](https://robotical.io). Right now configured to send to 10.0.0.49, Marty's address on
our home network.

Send commdands through the `Marty` module. For example

```
iex> Marty.hello(false)
```

Commands are sent through TCP port 24

See `Marty.CommandDefinitions` for the list of currently implemented commands.

## Todo

- Find Marty's IP, eg through Marty's UDP multicast.
- Use Macros to generate the command generation code (in `Marty.Commands`) from command definitions

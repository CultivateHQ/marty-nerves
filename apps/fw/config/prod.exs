use Mix.Config

config :logger, :level, :info

config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

config :nerves_firmware_ssh,
  authorized_keys: [
    File.read!(Path.join(System.user_home!(), ".ssh/id_rsa.pub"))
  ]

config :nerves_init_gadget, mdns_domain: System.get_env("MDNS_DOMAIN") || "marty.local"

#   ifname: "wlan0",
#   address_method: :dhcp,
#   node_name: nil

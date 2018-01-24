use Mix.Config

config :marty, :gen_tcp_impl, NetTransport.FakeGenTcp
config :marty, :gen_udp_impl, NetTransport.FakeGenUdp

import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :metro_cdmx_api, MetroCdmxApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "zW2UeAZusekiJbYuBvTfU4c1eJliK68vz7ezYrFHF/OGTPdDMCcztAspQAsVJL+8",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :mini_risk_manager, MiniRiskManager.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "mini_risk_manager_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :mini_risk_manager, MiniRiskManager.Ports.ModelPort,
  adapter: MiniRiskManager.Ports.ModelPortMock

config :mini_risk_manager, MiniRiskManager.Ports.BalanceBlokerPort,
  adapter: MiniRiskManager.Ports.BalanceBlokerPortMock

config :tesla, adapter: TeslaMock

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mini_risk_manager, MiniRiskManagerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "3UubJm4psDuUnFK3euBHUfcvawU6KLon5HETr/d1bxifeMz/zTNQPa31fglwzF+o",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Configures Oban
config :mini_risk_manager, Oban, testing: :manual

config :ex_unit, capture_log: true

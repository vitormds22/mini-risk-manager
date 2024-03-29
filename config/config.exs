# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :mini_risk_manager,
  ecto_repos: [MiniRiskManager.Repo]

# Configures the endpoint
config :mini_risk_manager, MiniRiskManagerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: MiniRiskManagerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: MiniRiskManager.PubSub,
  live_view: [signing_salt: "YuZAMe+z"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :mini_risk_manager, MiniRiskManager.Ports.ModelPort,
  adapter: MiniRiskManagerAdapters.ModelPort.RiskAnalysis

config :mini_risk_manager, MiniRiskManager.Ports.BalanceBlokerPort,
  adapter: MiniRiskManagerAdapters.BalanceBlokerPort.Transfers

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Oban
config :mini_risk_manager, Oban,
  repo: MiniRiskManager.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10, balance_bloker: 3]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

defmodule MiniRiskManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      MiniRiskManager.Repo,
      # Start the Oban
      {Oban, Application.fetch_env!(:mini_risk_manager, Oban)},
      # Start the Telemetry supervisor
      MiniRiskManagerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MiniRiskManager.PubSub},
      # Start the Endpoint (http/https)
      MiniRiskManagerWeb.Endpoint
      # Start a worker by calling: MiniRiskManager.Worker.start_link(arg)
      # {MiniRiskManager.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MiniRiskManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MiniRiskManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

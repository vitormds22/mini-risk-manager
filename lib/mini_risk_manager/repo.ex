defmodule MiniRiskManager.Repo do
  use Ecto.Repo,
    otp_app: :mini_risk_manager,
    adapter: Ecto.Adapters.Postgres
end

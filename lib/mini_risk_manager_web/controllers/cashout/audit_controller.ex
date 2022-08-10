defmodule MiniRiskManagerWeb.Cashout.AuditController do
  @moduledoc false
  use MiniRiskManagerWeb, :controller
  action_fallback MiniRiskManagerWeb.FallbackController

  alias MiniRiskManager.Cashout.Commands.Validation

  def model_risk(conn, params) do
    Validation.run(params)
    |> case do
        {:ok, result} ->
          conn
          |> put_status(:ok)
          |> render("200.json", result: result)
        {:error, reason} ->
          {:error,reason}
    end

  end
end

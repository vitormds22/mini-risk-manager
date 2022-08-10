defmodule MiniRiskManagerWeb.Cashout.AuditController do
  @moduledoc false
  use MiniRiskManagerWeb, :controller
  action_fallback MiniRiskManagerWeb.FallbackController

  alias MiniRiskManager.Cashout.Commands.Validation

  @spec validate(Plug.Conn.t(), map()) :: map()
  def validate(conn, params) do
    case Validation.run(params) do
      {:ok, result} ->
        conn
        |> put_status(:ok)
        |> render("200.json", result: result)

      {:error, reason} ->
        {:error, reason}
    end
  end
end

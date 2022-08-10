defmodule MiniRiskManagerWeb.FallbackController do
  use MiniRiskManagerWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(MiniRiskManagerWeb.ErrorView)
    |> render("400.json", result: changeset)
  end

  def call(conn, {:error, result}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(MiniRiskManagerWeb.ErrorView)
    |> render("500.json", result: result)
  end
end

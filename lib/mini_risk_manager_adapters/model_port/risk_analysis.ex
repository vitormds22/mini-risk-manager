defmodule MiniRiskManagerAdapters.ModelPort.RiskAnalysis do
  @moduledoc """
  Implements the behaviour of `MiniRiskManager.Ports.ModelPort` to the Risk Analysis.
  """
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://risk-analysis.risk-analysis/service/v1/models/cashout"
  plug Tesla.Middleware.JSON

  alias MiniRiskManager.Ports.Types.ModelResponse
  # alias MiniRiskManager.Ports.Types.ModelInput

  @behaviour MiniRiskManager.Ports.ModelPort

  @impl true

  @spec call_model(struct()) ::
          {:error, :bad_request | :internal_server_error}
          | {:ok, ModelResponse.t()}

  def call_model(payload) when is_struct(payload) do
    "http://risk-analysis.risk-analysis/service/v1/models/cashout"
    |> post(payload)
    |> handle_post()
  end

  defp handle_post({:ok, %Tesla.Env{status: 200, body: ModelResponse}}),
    do: {:ok, ModelResponse}

  defp handle_post({:ok, %Tesla.Env{status: 400}}), do: {:error, :bad_request}
  defp handle_post({:ok, %Tesla.Env{status: 500}}), do: {:error, :internal_server_error}
end

defmodule MiniRiskManagerAdapters.ModelPort.RiskAnalysis do
  @moduledoc """
  Implements the behaviour of `MiniRiskManager.Ports.ModelPort` to the Risk Analysis.
  """
  use Tesla
  require Logger

  plug Tesla.Middleware.BaseUrl, "http://risk-analysis.risk-analysis"
  plug Tesla.Middleware.JSON

  alias MiniRiskManager.Ports.Types.ModelResponse
  alias MiniRiskManager.Ports.Types.ModelInput

  @behaviour MiniRiskManager.Ports.ModelPort

  @impl true
  def call_model(%ModelInput{} = payload) do
    "/service/v1/models/cashout"
    |> post(payload)
    |> handle_post()
  end

  defp handle_post({:ok, %Tesla.Env{status: 200, body: body}}) do
    {:ok,
     %ModelResponse{
       is_valid: Map.fetch!(body, "is_valid"),
       metadata: Map.fetch!(body, "metadata")
     }}
  end

  defp handle_post({:ok, %Tesla.Env{status: status, body: body}}) do
    Logger.error("#{__MODULE__}.handle_post status=#{inspect(status)} body=#{inspect(body)}")
    {:error, :request_failed}
  end

  defp handle_post({:error, reason}) do
    Logger.error("#{__MODULE__}.handle_post error=#{inspect(reason)}")
    {:error, :request_failed}
  end
end

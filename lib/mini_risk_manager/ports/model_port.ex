defmodule MiniRiskManager.Ports.ModelPort do
  @moduledoc """
  Port for call fraud model
  """

  alias MiniRiskManager.Ports.Types.ModelInput
  alias MiniRiskManager.Ports.Types.ModelResponse

  @type call_model_response() :: {:ok, ModelResponse.t()} | {:error, :request_failed}

  @callback call_model(ModelInput.t()) :: call_model_response()

  @spec call_model(ModelInput.t()) :: call_model_response()
  def call_model(model_input) do
    adapter().call_model(model_input)
  end

  defp adapter do
    :mini_risk_manager
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:adapter)
  end
end

defmodule MiniRiskManager.Ports.ModelPort do
  @moduledoc """
  Port for call fraud model
  """

  @callback call_model(ModelInput.t()) ::
              {:ok, ModelResponse.t() | {:error, :bad_request | :request_failed}}

  def call_model(params) do
    adapter().call_model(params)
  end

  defp adapter() do
    :mini_risk_manager
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:adapter)
  end
end

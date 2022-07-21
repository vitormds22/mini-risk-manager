defmodule MiniRiskManager.Ports.BalanceBlokerPort do
  @moduledoc """
  Behaviour/Port for block any malicious transfer
  """
  @callback call_transfers(any()) :: any()

  @spec call_transfers(any()) :: any()

  def call_transfers(model_response) do
    adapter().call_transfers(model_response)
  end

  defp adapter() do
    :mini_risk_manager
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:adapter)
  end
end

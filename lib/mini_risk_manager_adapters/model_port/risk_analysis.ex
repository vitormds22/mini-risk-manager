defmodule MiniRiskManagerAdapters.ModelPort.RiskAnalysis do
  @behaviour MiniRiskManager.Ports.ModelPort

  @impl true
  def call_model(params) do
    params
  end
end

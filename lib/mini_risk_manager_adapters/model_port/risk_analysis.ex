defmodule MiniRiskManagerAdapters.ModelPort.RiskAnalysis do
  @moduledoc """
  Implements the behaviour of `MiniRiskManager.Ports.ModelPort` to the Risk Analysis.
  """
  @behaviour MiniRiskManager.Ports.ModelPort

  @impl true
  def call_model(params) do
    params
  end
end

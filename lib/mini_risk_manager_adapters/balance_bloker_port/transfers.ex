defmodule MiniRiskManagerAdapters.BalanceBlokerPort.Transfers do
  @moduledoc """
  Implements the behaviour of `MiniRiskManager.Ports.BalanceBlokerPort` to the Transfers
  """

  use MiniRiskManagerAdapters.Tesla, "http://transfers.transfers"

  @behaviour MiniRiskManager.Ports.ModelPort

  @impl true
  def call_model(%ModelInput{} = payload) do
    "/service/v1/accounts/#{payload.operation_type}/block_balance"
    |> post(payload)
  end
end

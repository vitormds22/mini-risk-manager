defmodule MiniRiskManager.Cashout.Commands.BalanceBloker do
  @moduledoc """
  Command for `MiniRiskManager.Ports.BalanceBlokerPort` account
  """

  alias MiniRiskManager.Ports.BalanceBlokerPort
  alias MiniRiskManager.Ports.Types.BalanceBlokerInput

  @spec run(BalanceBlokerInput.t()) :: :ok | :request_failed
  def run(balance_bloker_input) do
    balance_bloker_input
    |> BalanceBlokerPort.block_balance()
  end
end

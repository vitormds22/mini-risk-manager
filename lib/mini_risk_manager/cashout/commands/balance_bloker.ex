defmodule MiniRiskManager.Cashout.Commands.BalanceBloker do
  @moduledoc """
  Command for `MiniRiskManager.Ports.BalanceBlokerPort` account
  """

  alias MiniRiskManager.Ports.BalanceBlokerPort
  alias MiniRiskManager.Ports.Types.BalanceBlokerInput

  @spec run(BalanceBlokerInput.t()) :: :ok | {:error, :request_failed}
  def run(balance_bloker_input) do
    BalanceBlokerPort.block_balance(balance_bloker_input)
  end
end

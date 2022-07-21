defmodule MiniRiskManagerAdapters.BalanceBlokerPort.Transfers do
  @moduledoc """
  Implements the behaviour of `MiniRiskManager.Ports.BalanceBlokerPort` to the Transfers
  """

  use MiniRiskManagerAdapters.Tesla, "http://transfers.transfers"

  @behaviour MiniRiskManager.Ports.BalanceBlokerPort

  @impl true
 def call_transfers() do
  # post for url /service/v1/accounts/:account_id/block_balance
 end
end

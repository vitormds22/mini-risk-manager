defmodule MiniRiskManager.Cashout.Jobs.BalanceBlokerJob do
  @moduledoc false

  use Oban.Worker, queue: :balance_bloker

  alias MiniRiskManager.Cashout.Commands.BalanceBloker
  alias MiniRiskManager.Ports.Types.BalanceBlokerInput

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{
          "operation_id" => operation_id,
          "operation_type" => operation_type,
          "amount" => amount,
          "account_id" => account_id
        }
      }) do
    balance_bloker_input = %BalanceBlokerInput{
      operation_id: operation_id,
      operation_type: String.to_existing_atom(operation_type),
      amount: amount,
      account_id: account_id
    }

    BalanceBloker.run(balance_bloker_input)
  end
end

defmodule MiniRiskManager.Cashout.Jobs.BalanceBlokerJob do
  use Oban.Worker, queue: :balance_bloker
  require Logger

  alias MiniRiskManager.Ports.Types.BalanceBlokerInput
  alias MiniRiskManager.Cashout.Commands.BalanceBloker

  @impl Oban.Worker

  def perform(%Oban.Job{args: %BalanceBlokerInput{} = balance_bloker_input}) do
    BalanceBloker.run(balance_bloker_input)
  end
end

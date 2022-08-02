defmodule MiniRiskManager.Cashout.Jobs.BalanceBlokerJob do
  @moduledoc false

  use Oban.Worker, queue: :balance_bloker

  alias MiniRiskManager.Cashout.Commands.BalanceBloker
  alias MiniRiskManager.Ports.Types.BalanceBlokerInput

  require Logger
  @impl Oban.Worker
  def perform(%Oban.Job{args: %BalanceBlokerInput{} = balance_bloker_input}) do
    BalanceBloker.run(balance_bloker_input)
  end
end

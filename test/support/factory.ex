defmodule MiniRiskManager.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: MiniRiskManager.Repo

  use MiniRiskManager.Factory.Cashout.AuditsFactory
  use MiniRiskManager.Factory.Ports.BalanceBlokerFactory
end

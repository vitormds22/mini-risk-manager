defmodule MiniRiskManager.Factory do
  use ExMachina.Ecto, repo: MiniRiskManager.Repo

  use MiniRiskManager.Factory.Cashout.AuditsFactory
end

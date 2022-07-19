defmodule MiniRiskManager.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: MiniRiskManager.Repo

  use MiniRiskManager.Factory.Cashout.AuditsFactory
end

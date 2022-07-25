defmodule MiniRiskManager.Cashout.Models.Audit.InputParams.Account do
  @moduledoc """
  Defines the desired structure and validations
  for account params for input params validation
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:id, Ecto.UUID)
    field(:balance, :integer)
  end
end

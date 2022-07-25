defmodule MiniRiskManager.Cashout.Models.Audit.InputParams.Target do
  @moduledoc """
  Defines the desired structure and validations
  for input params for audit validation
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:document, :string)
    field(:account_code, :string)
    field(:account_type, Ecto.Enum, values: [:CC, :PP, :PG])
  end

  def create_changeset(audit \\ %__MODULE__{}, attrs) do
    audit
    |> cast(attrs, [:document, :account_code, :account_type])
  end
end

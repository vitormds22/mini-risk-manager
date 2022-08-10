defmodule MiniRiskManager.Cashout.Models.Audit.InputParams.Target do
  @moduledoc """
  Defines the desired structure and validations
  for target params for input params validation
  """
  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{
          document: String.t(),
          account_code: String.t(),
          account_type: String.t()
        }

  @primary_key false
  embedded_schema do
    field(:document, :string)
    field(:account_code, :string)
    field(:account_type, Ecto.Enum, values: [:CC, :PP, :PG])
  end

  @spec create_changeset(struct(), map()) :: Ecto.Changeset.t()
  def create_changeset(module \\ %__MODULE__{}, attrs) do
    module
    |> cast(attrs, [:document, :account_code, :account_type])
    |> validate_required(:document)
  end
end

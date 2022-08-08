defmodule MiniRiskManager.Cashout.Models.Audit.InputParams do
  @moduledoc """
  Defines the desired structure and validations
  for input params for audit validation
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias MiniRiskManager.Cashout.Models.Audit.InputParams.Account
  alias MiniRiskManager.Cashout.Models.Audit.InputParams.Target

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          operation_id: Ecto.UUID.t(),
          operation_type: String.t(),
          amount: integer(),
          account: Account.t(),
          target: Target.t()
        }

  embedded_schema do
    field(:operation_type, Ecto.Enum, values: [:inbound_pix_payment, :inbound_external_transfer])
    field(:operation_id, Ecto.UUID)
    field(:amount, :integer)
    embeds_one(:account, Account)
    embeds_one(:target, Target)
  end

  @spec create_changeset(struct(), map()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def create_changeset(module \\ %__MODULE__{}, attrs) do
    module
    |> cast(attrs, [:operation_type, :operation_id, :amount])
    |> cast_embed(:account, with: &Account.create_changeset/2)
    |> cast_embed(:target, with: &Target.create_changeset/2)
    |> validate_required([:operation_type, :operation_id, :amount, :account, :target])
    |> apply_action(:insert)
  end

  @spec load_for_audit(struct(), map()) :: Ecto.Changeset.t()
  def load_for_audit(module \\ %__MODULE__{}, attrs) do
    module
    |> cast(attrs, [:operation_type, :operation_id, :amount])
    |> cast_embed(:account, with: &Account.create_changeset/2)
    |> cast_embed(:target, with: &Target.create_changeset/2)
    |> validate_required([:operation_type, :operation_id, :amount, :account, :target])
  end
end

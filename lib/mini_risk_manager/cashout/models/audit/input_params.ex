defmodule MiniRiskManager.Cashout.Models.InputParams do
  @moduledoc """
  Defines the desired structure and validations
  for input params for audit validation
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias MiniRiskManager.Cashout.Models.Audit.InputParams.Account
  alias MiniRiskManager.Cashout.Models.Audit.InputParams.Target

  embedded_schema do
    field(:operation_type, Ecto.Enum, values: [:inbound_pix_payment, :inbound_external_transfer])
    field(:operation_id, Ecto.UUID)
    field(:amount, :integer)
    embeds_one(:account, Account)
    embeds_one(:target, Target)
  end
end

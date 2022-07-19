defmodule MiniRiskManager.Ports.Types.ModelInput do
  @type t() :: %__MODULE__{
    id: Ecto.UUID.t(),
    operation_type: Ecto.Enum, values: [:inbound_pix_payment, :inbound_external_transfer],
    amount: integer(),
    balance: integer(),
    account_type: Ecto.Enum, values: [:CC, :PP, :PG] | nil,
    sum_amount_last_24h: integer()
  }

  defstruct ~w(operation_type amount balance account_type sum_amount_last_24h)a
end

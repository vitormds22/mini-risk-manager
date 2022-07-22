defmodule MiniRiskManager.Ports.Types.BalanceBlokerInput do
  @derive Jason.Encoder

  @type t() :: %__MODULE__{
          operation_id: Ecto.UUID.t(),
          operation_type: :inbound_pix_payment | :inbound_external_transfer,
          amount: integer(),
          internal_reason: String.t(),
          account_id: Ecto.UUID.t()
        }

  defstruct [:operation_id, :operation_type, :amount, :account_id, internal_reason: "high risk"]
end

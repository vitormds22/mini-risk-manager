defmodule MiniRiskManager.Ports.Types.RequestInputParams do
  @derive Jason.Encoder

  @type t() :: %__MODULE__{
          operation_id: Ecto.UUID.t(),
          operation_type: :inbound_pix_payment | :inbound_external_transfer,
          amount: integer(),
          account:
            {[
               id: Ecto.UUID.t(),
               balance: integer()
             ]},
          target:
            {[
               document: String.t(),
               account_code: String.t() | nil,
               account_type: :CC | :PP | :PG | nil
             ]}
        }

  defstruct ~w(operation_id operation_type amount account target)a
end

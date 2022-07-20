defmodule MiniRiskManager.Ports.Types.ModelInput do
  @type t() :: %__MODULE__{
          operation_type: String.t(),
          amount: integer(),
          balance: integer(),
          account_type: String.t() | nil,
          sum_amount_last_24h: integer()
        }

  defstruct ~w(operation_type amount balance account_type sum_amount_last_24h)a
end

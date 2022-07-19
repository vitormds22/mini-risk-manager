defmodule MiniRiskManager.Ports.Types.ModelResponse do

  @type t() :: %__MODULE__{
    id: Ecto.UUID.t(),
    is_valid: boolean(),
    metadata: map()
  }

  defstruct ~w(is_valid metadata)a
end

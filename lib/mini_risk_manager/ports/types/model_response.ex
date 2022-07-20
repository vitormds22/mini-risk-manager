defmodule MiniRiskManager.Ports.Types.ModelResponse do

  @derive Jason.Encoder

  @type t() :: %__MODULE__{
          is_valid: boolean(),
          metadata: map()
        }

  defstruct ~w(is_valid metadata)a
end

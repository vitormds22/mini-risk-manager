defmodule MiniRiskManager.Cashout.Models.Audit do
  @moduledoc """
  Model for table Audits in DB.
  Storage all calls made for the model
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
    id: Ecto.UUID.t(),
    input_params: map(),
    model_input: ModelInput.t(),
    model_response: ModelResponse.t(),
    is_valid: String.t(),
  }

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @required_keys ~w(input_params model_input model_response is_valid)a

  schema "audits" do
    field :input_params, :map
    field :model_input, :map
    field :model_response, :map
    field :is_valid, :boolean

    timestamps(updated_at: false)
  end

  @spec create_changeset(map()) :: Ecto.Changeset.t()
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required_keys)
    |> validate_required(@required_keys)
  end
end

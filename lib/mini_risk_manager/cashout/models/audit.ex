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
          model_input: map(),
          model_response: map(),
          is_valid: String.t(),
          inserted_at: NaiveDateTime.t()
        }

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @required_keys ~w(input_params model_input model_response is_valid)a

  schema "audits" do
    field :input_params, :map
    field :operation_id, :string
    field :operation_type, :string
    field :model_input, :map
    field :model_response, :map
    field :is_valid, :boolean

    timestamps(updated_at: false)
  end

  @spec create_changeset(map()) :: Ecto.Changeset.t()
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required_keys)
    |> IO.inspect(label: "CAST PARAMS")
    |> validate_required(@required_keys)
    |> IO.inspect(label: "VALIDATE PARAMS")
    |> put_operation()
    |> unique_constraint([:operation_id, :operation_type])
    |> IO.inspect(label: "UNIQUE PARAMS")
  end

  defp put_operation(x) do
    IO.inspect(x, label: "PUT PARAMS")
  end
end

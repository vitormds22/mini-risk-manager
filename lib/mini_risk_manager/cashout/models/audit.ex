defmodule MiniRiskManager.Cashout.Models.Audit do
  @moduledoc """
  Model for table Audits in DB.
  Storage all calls made for the model
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias MiniRiskManager.Cashout.Models.Audit.InputParams

  @type t() :: %__MODULE__{
          id: Ecto.UUID.t(),
          operation_id: Ecto.UUID.t(),
          operation_type: String.t(),
          input_params: map(),
          model_input: map(),
          model_response: map(),
          is_valid: String.t(),
          inserted_at: NaiveDateTime.t()
        }

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "audits" do
    field :operation_id, :string
    field :operation_type, Ecto.Enum, values: [:inbound_pix_payment, :inbound_external_transfer]
    field :model_input, :map
    field :model_response, :map
    field :is_valid, :boolean
    embeds_one(:input_params, InputParams)

    timestamps(updated_at: false)
  end

  @spec create_changeset(map()) :: Ecto.Changeset.t()
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:model_input, :model_response, :is_valid])
    |> cast_embed(:input_params, with: &InputParams.create_changeset/2)
    |> put_operation()
    |> validate_required([:input_params, :model_input, :model_response, :is_valid])
    |> unique_constraint([:operation_id, :operation_type])
  end

  defp put_operation(changeset) do
    case get_field(changeset, :input_params) do
      nil ->
        changeset

      %{operation_type: operation_type, operation_id: operation_id} ->
        changeset
        |> force_change(:operation_type, operation_type)
        |> force_change(:operation_id, operation_id)
    end
  end
end

defmodule MiniRiskManager.Cashout.Models.Audit do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @required_keys ~w(input_params model_input model_response is_valid)a

  schema "audits" do
    field :input_params, :map
    field :model_input, :map
    field :model_response, :map
    field :is_valid, :boolean

    timestamps(updated_at: false)
  end

  def create_changeset(audit, attrs) do
    audit
    |> cast(attrs, @required_keys)
    |> validate_required(@required_keys)
  end
end

defmodule MiniRiskManager.Repo.Migrations.AddAuditTable do
  use Ecto.Migration

  def change do
    create table(:audits, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :input_params, :map, null: false
      add :operation_id, :string, null: false
      add :operation_type, :string, null: false
      add :model_input, :map, null: false
      add :model_response, :map, null: false
      add :is_valid, :boolean, null: false

      timestamps(updated_at: false)
    end

    create unique_index(:audits, [:operation_id, :operation_type])
  end
end

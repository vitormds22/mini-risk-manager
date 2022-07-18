defmodule MiniRiskManager.Repo.Migrations.AddAuditTable do
  use Ecto.Migration

  def change do
    create table(:audits, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :input_params, :map, null: false
      add :model_input, :map, null: false
      add :model_response, :map, null: false
      add :is_valid, :boolean, null: false

      timestamps(updated_at: false)
    end
  end
end

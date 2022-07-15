defmodule MiniRiskManager.Repo.Migrations.AddAuditTable do
  use Ecto.Migration

  def change do
    create table(:audits, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :input_params, :map, null: true
      add :model_input, :map, null: true
      add :is_valid, :boolean
    end
  end
end

defmodule MiniRiskManager.Repo.Migrations.AddAuditTable do
  use Ecto.Migration

  def change do
    create table(:audits, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :input_risk_analysis, :map, null: true
      add :input_transfers, :map, null: true
      add :input_mini_risk_manager, :map, null: true
    end
  end
end

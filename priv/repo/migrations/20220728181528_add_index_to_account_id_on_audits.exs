defmodule MiniRiskManager.Repo.Migrations.AddIndexToAccountIdOnAudits do
  use Ecto.Migration

  def change do
    create index(:audits, ["(input_params->'account'->>'id')", "inserted_at desc"])
  end
end

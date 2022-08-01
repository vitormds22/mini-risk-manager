defmodule MiniRiskManager.Cashout.Aggregates.AuditAggregate do
  @moduledoc """
  This Aggregates module takes care of Audit lifecycles
  """

  alias MiniRiskManager.Cashout.Models.Audit
  alias MiniRiskManager.Repo

  @spec create_audit(map()) :: Audit.t()
  def create_audit(audit_params) do
    audit_params
    |> Audit.create_changeset()
    |> Repo.insert()
  end
end

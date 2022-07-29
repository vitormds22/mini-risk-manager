defmodule MiniRiskManager.Cashout.Repositories.AuditRepository do
  @moduledoc """
  The repository for the Bank Domicile audits context.
  """
  import Ecto.Query

  alias MiniRiskManager.Cashout.Models.Audit
  alias MiniRiskManager.Repo

  def find(audit_id) do
    Audit
    |> Repo.get(audit_id)
    |> case do
      nil ->
        {:error, :audit_not_found}

      audit ->
        {:ok, audit}
    end
  end

  def sum_amount_last_24h(account_id, start_date_time, end_date_time) when is_bitstring(account_id) do
    query =
      from a in Audit,
        where:
          a.input_params["account"]["id"] == ^account_id and
            fragment("?", a.inserted_at >= ^start_date_time) and
            fragment("?", a.inserted_at <= ^end_date_time),
        select: sum(fragment("(input_params->>'amount')::integer"))

    Repo.one(query)
  end
end
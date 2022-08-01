defmodule MiniRiskManager.Cashout.Repositories.AuditRepository do
  @moduledoc """
  The repository for the Bank Domicile audits context.
  """
  import Ecto.Query

  alias MiniRiskManager.Cashout.Models.Audit
  alias MiniRiskManager.Repo

  @spec find(Ecto.UUID.t()) :: {:ok, Audit.t()}
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

  @spec sum_amount_last_24h(Ecto.UUID.t(), NaiveDateTime.t()) :: integer()
  def sum_amount_last_24h(account_id, end_date_time) when is_bitstring(account_id) do
    start_date_time = NaiveDateTime.add(end_date_time, -86_400)

    Audit
    |> select(
      fragment("(input_params->>'amount')::integer")
      |> sum()
      |> coalesce(0)
    )
    |> where(
      fragment(
        "(input_params->'account'->>'id') = ? AND inserted_at >= ? AND inserted_at <= ?",
        ^account_id,
        ^start_date_time,
        ^end_date_time
      )
    )
    |> Repo.one()
  end
end

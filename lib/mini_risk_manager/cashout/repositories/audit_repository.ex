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

  @spec sum_amount_last_24h(Ecto.UUID.t()) :: integer()
  def sum_amount_last_24h(account_id) when is_bitstring(account_id) do
    end_date_time = NaiveDateTime.utc_now()
    start_date_time = NaiveDateTime.add(end_date_time, -86_400)

    Audit
    |> select(
      "(input_params->>'amount')::integer"
      |> fragment()
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

  @spec get_audit_by_operation_id_and_operation_type(Ecto.UUID.t(), String.t()) :: boolean()
  def get_audit_by_operation_id_and_operation_type(operation_id, operation_type) do
    Audit
    |> where(operation_id: ^operation_id)
    |> where(operation_type: ^operation_type)
    |> Repo.one!()
  end
end

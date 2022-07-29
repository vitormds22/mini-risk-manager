defmodule MiniRiskManager.Cashout.Repositories.AuditRepositoryTest do
  use MiniRiskManager.DataCase, async: true

  alias MiniRiskManager.Cashout.Models.Audit
  alias MiniRiskManager.Cashout.Repositories.AuditRepository

  setup do
    params = string_params_for(:mini_risk_manager_audit)

    {:ok, %Audit{} = audit} =
      params
      |> Audit.create_changeset()
      |> Repo.insert()

    %{audit: audit, params: params}
  end

  describe "find/1" do
    test "with valid account_id return a tuple of ok and struct", %{audit: audit} do
      assert {:ok, audit} = AuditRepository.find(audit.id)
    end

    test "with invalid account_id return a tuple of error and reason" do
      audit_id = Ecto.UUID.generate()

      assert {:error, :audit_not_found} = AuditRepository.find(audit_id)
    end

    test "with account_id is nill return a tuple of error and reason", %{params: %{"id" => id} = params} do
      params = Map.put(params, "id", nil)
      assert {:error, :audit_not_found} = AuditRepository.find(id)
    end
  end

  describe "sum_amount_last_24h/3" do
    test "with valid account_id and timestamps return the sum of all amounts at last 24h", %{audit: %{input_params: input_params} = audit} do
      start_date_time = NaiveDateTime.add(audit.inserted_at, -86400)
      assert 80 == AuditRepository.sum_amount_last_24h(input_params.account.id, start_date_time, audit.inserted_at)
    end
  end
end

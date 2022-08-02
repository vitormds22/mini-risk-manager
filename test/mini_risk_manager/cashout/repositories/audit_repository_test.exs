defmodule MiniRiskManager.Cashout.Repositories.AuditRepositoryTest do
  use MiniRiskManager.DataCase, async: true

  alias MiniRiskManager.Cashout.Repositories.AuditRepository

  setup do
    params = string_params_for(:mini_risk_manager_audit)

    audit = insert(:mini_risk_manager_audit)

    %{audit: audit, params: params}
  end

  describe "find/1" do
    test "with valid account_id return a tuple of ok and struct", %{audit: audit} do
      assert {:ok, _} = AuditRepository.find(audit.id)
    end

    test "with invalid account_id return a tuple of error and reason" do
      audit_id = Ecto.UUID.generate()

      assert {:error, :audit_not_found} = AuditRepository.find(audit_id)
    end

    test "with account_id is nill return a tuple of error and reason", %{
      params: %{"id" => id} = params
    } do
      Map.put(params, "id", nil)
      assert {:error, :audit_not_found} = AuditRepository.find(id)
    end
  end

  describe "sum_amount_last_24h/3" do
    test "return the sum of all amounts at last 24h when have the same and different account_id", %{
      audit: %{input_params: input_params}
    } do
      insert(:mini_risk_manager_audit)
      insert(:mini_risk_manager_audit)
      insert(:mini_risk_manager_audit)
      insert(:mini_risk_manager_audit)
      insert(:mini_risk_manager_audit)

      amount1 = input_params.amount
      amount2 = Enum.random(1..100)

      input_params = Map.put(input_params, :amount, amount2)

      insert(:mini_risk_manager_audit, %{input_params: input_params})

      assert amount1 + amount2 ==
               AuditRepository.sum_amount_last_24h(input_params.account.id)
    end

    test "with valid account_id but date time out of the range 24h", %{
      audit: %{input_params: input_params} = audit
    } do
      amount1 = input_params.amount
      amount2 = Enum.random(1..100)

      inserted_at1 = audit.inserted_at
      inserted_at2 = NaiveDateTime.add(inserted_at1, -100)
      inserted_at3 = NaiveDateTime.add(inserted_at1, -86_500)
      inserted_at4 = NaiveDateTime.add(inserted_at1, 1000)

      input_params2 = Map.put(input_params, :amount, amount2)

      insert(:mini_risk_manager_audit, %{input_params: input_params2})
      insert(:mini_risk_manager_audit, %{inserted_at: inserted_at2})
      insert(:mini_risk_manager_audit, %{input_params: input_params2, inserted_at: inserted_at3})
      insert(:mini_risk_manager_audit, %{input_params: input_params2, inserted_at: inserted_at4})

      assert amount1 + amount2 ==
               AuditRepository.sum_amount_last_24h(input_params.account.id)
    end

    test "with valid account_id and timestamps but haven't register in db" do
      account_id = Ecto.UUID.generate()

      assert 0 == AuditRepository.sum_amount_last_24h(account_id)
    end
  end
end

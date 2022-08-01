defmodule MiniRiskManager.Cashout.Repositories.AuditRepositoryTest do
  use MiniRiskManager.DataCase, async: true

  alias MiniRiskManager.Cashout.Repositories.AuditRepository

  setup do
    params = string_params_for(:mini_risk_manager_audit)

    first_audit = insert(:mini_risk_manager_audit_insert)
    second_audit = insert(:mini_risk_manager_audit_insert)

    %{second_audit: second_audit, first_audit: first_audit, params: params}
  end

  describe "find/1" do
    test "with valid account_id return a tuple of ok and struct", %{first_audit: first_audit} do
      assert {:ok, first_audit} = AuditRepository.find(first_audit.id)
    end

    test "with invalid account_id return a tuple of error and reason" do
      audit_id = Ecto.UUID.generate()

      assert {:error, :audit_not_found} = AuditRepository.find(audit_id)
    end

    test "with account_id is nill return a tuple of error and reason", %{
      params: %{"id" => id} = params
    } do
      params = Map.put(params, "id", nil)
      assert {:error, :audit_not_found} = AuditRepository.find(id)
    end
  end

  describe "sum_amount_last_24h/3" do
    test "with valid account_id and timestamps return the sum of all amounts at last 24h", %{
      second_audit: %{input_params: input_params} = second_audit
    } do
      assert 160 ==
               AuditRepository.sum_amount_last_24h(
                 input_params.account.id,
                 second_audit.inserted_at
               )
    end

    test "with valid account_id and timestamps but haven't register in deb" do
      end_date_time = ~N[2022-07-28 17:47:16]

      assert 0 ==
               AuditRepository.sum_amount_last_24h(
                 "e3a33b8e-721c-414a-a9d2-58d172a95625",
                 end_date_time
               )
    end
  end
end

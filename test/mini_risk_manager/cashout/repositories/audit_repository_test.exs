defmodule MiniRiskManager.Cashout.Repositories.AuditRepositoryTest do
  use MiniRiskManager.DataCase, async: true

  alias MiniRiskManager.Cashout.Models.Audit
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

      first_amount = input_params.amount

      second_amount = Enum.random(1..100)

      input_params = Map.put(input_params, :amount, second_amount)

      %Audit{input_params: ^input_params} =
        insert(:mini_risk_manager_audit, %{input_params: input_params})

      assert first_amount + second_amount ==
               AuditRepository.sum_amount_last_24h(input_params.account.id)
    end

    test "with valid account_id but date time out of the range 24h", %{
      audit: %{input_params: input_params} = audit
    } do
      first_amount = input_params.amount
      second_amount = Enum.random(1..100)

      first_date_time = audit.inserted_at
      second_date_time = NaiveDateTime.add(first_date_time, -100)

      third_date_time = NaiveDateTime.add(first_date_time, -86_500)
      fourth_date_time = NaiveDateTime.add(first_date_time, 1000)

      input_params = Map.put(input_params, :amount, second_amount)

      %Audit{input_params: ^input_params} =
        insert(:mini_risk_manager_audit, %{input_params: input_params})

      audit = Map.put(audit, :inserted_at, second_date_time)

      %Audit{} = insert(:mini_risk_manager_audit, %{inserted_at: second_date_time})

      audit = Map.put(audit, :inserted_at, third_date_time)
      %Audit{} = insert(:mini_risk_manager_audit, %{inserted_at: third_date_time})

      audit = Map.put(audit, :inserted_at, fourth_date_time)
      %Audit{} = insert(:mini_risk_manager_audit, %{inserted_at: fourth_date_time})

      refute audit.inserted_at == first_date_time

      assert first_amount + second_amount ==
               AuditRepository.sum_amount_last_24h(input_params.account.id)
    end

    test "with valid account_id and timestamps but haven't register in db" do
      account_id = Ecto.UUID.generate()

      assert 0 == AuditRepository.sum_amount_last_24h(account_id)
    end
  end
end

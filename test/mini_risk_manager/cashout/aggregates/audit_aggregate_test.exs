defmodule MiniRiskManager.Cashout.Aggregates.AuditAggregateTest do
  @moduledoc false
  use MiniRiskManager.DataCase, async: true
  alias MiniRiskManager.Cashout.Aggregates.AuditAggregate
  alias MiniRiskManager.Cashout.Models.Audit

  describe "create_audit/1" do
    test "when pass a valid map returns a tuple ok and changeset" do
      params = params_for(:mini_risk_manager_audit)

      assert {:ok, %Audit{}} = AuditAggregate.create_audit(params)
    end

    test "when pass a invalid map returns a tuple of error and invalid changeset" do
      params =
        params_for(
          :mini_risk_manager_audit,
          input_params: nil,
          model_input: nil,
          model_response: nil,
          operation_type: nil,
          operation_id: nil
        )

      assert {:error, %Ecto.Changeset{valid?: false}} = AuditAggregate.create_audit(params)
    end
  end
end

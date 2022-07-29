defmodule MiniRiskManager.Cashout.Models.Audit.InputParamsTest do
  @moduledoc false

  use MiniRiskManager.DataCase, async: true

  alias MiniRiskManager.Cashout.Models.Audit.InputParams
  alias MiniRiskManager.Cashout.Models.Audit.InputParams.Account
  alias MiniRiskManager.Cashout.Models.Audit.InputParams.Target

  @err_cant_be_blank "can't be blank"

  setup do
    params = params_for(:mini_risk_manager_audit_input_params)
    %{params: params}
  end

  describe "create_changeset/2" do
    test "when missing required attrs return a invalid changeset" do
      changeset = InputParams.create_changeset(%{})

      assert errors_on(changeset) == %{
               account: [@err_cant_be_blank],
               amount: [@err_cant_be_blank],
               operation_id: [@err_cant_be_blank],
               operation_type: [@err_cant_be_blank],
               target: [@err_cant_be_blank]
             }
    end

    test "when passed all required attrs return a valid changeset", %{params: params} do
      assert %Ecto.Changeset{changes: changes, valid?: true} = InputParams.create_changeset(params)

      assert changes.account.changes == params.account
      assert changes.target.changes == params.target
      assert changes.amount == params.amount
      assert changes.operation_id == params.operation_id
      assert changes.operation_type == params.operation_type

      assert %Account{} = changes.account.data
      assert %Target{} = changes.target.data
    end

    test "with invalid types" do
      params = %{
        account: "integer",
        operation_id: "string",
        operation_type: "string",
        target: "string",
        amount: "string"
      }

      changeset = InputParams.create_changeset(params)

      assert errors_on(changeset) == %{
               account: ["is invalid"],
               operation_id: ["is invalid"],
               operation_type: ["is invalid"],
               target: ["is invalid"],
               amount: ["is invalid"]
             }
    end
  end
end

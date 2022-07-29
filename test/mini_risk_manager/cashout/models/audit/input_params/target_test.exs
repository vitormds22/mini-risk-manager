defmodule MiniRiskManager.Cashout.Models.Audit.TargetTest do
  @moduledoc false

  use MiniRiskManager.DataCase, async: true
  alias MiniRiskManager.Cashout.Models.Audit.InputParams.Target

  @err_cant_be_blank "can't be blank"
  setup do
    params = params_for(:mini_risk_manager_audit_target_params)
    %{params: params}
  end

  describe "create_changeset/2" do
    test "when missing required attrs return a invalid changeset" do
      changeset = Target.create_changeset(%{})

      assert errors_on(changeset) == %{
               document: [@err_cant_be_blank]
             }
    end

    test "when passed all required attrs return a valid changeset", %{params: params} do
      assert %Ecto.Changeset{changes: changes, valid?: true} = Target.create_changeset(params)

      assert changes.account_code == params.account_code
      assert changes.account_type == params.account_type
      assert changes.document == params.document
    end

    test "with invalid types" do
      params = %{
        document: 111,
        account_code: 111,
        account_type: "string"
      }

      changeset = Target.create_changeset(params)

      assert errors_on(changeset) == %{
               document: ["is invalid"],
               account_code: ["is invalid"],
               account_type: ["is invalid"]
             }
    end
  end
end

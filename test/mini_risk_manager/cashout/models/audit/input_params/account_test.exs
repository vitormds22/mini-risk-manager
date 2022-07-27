defmodule MiniRiskManager.Cashout.Models.Audit.InputParams.AccountTest do
  @moduledoc false
  use MiniRiskManager.DataCase, async: true
  alias MiniRiskManager.Cashout.Models.Audit.InputParams.Account

  @err_cant_be_blank "can't be blank"
  setup do
    params = params_for(:mini_risk_manager_audit_account_params)
    %{params: params}
  end

  describe "create_changeset/2" do
    test "when missing required attrs return a invalid changeset" do
      changeset = Account.create_changeset(%{})
      assert errors_on(changeset) == %{
        id: [@err_cant_be_blank],
        balance: [@err_cant_be_blank],
      }
    end

    test "when passed all required attrs return a valid changeset", %{params: params} do
      assert %Ecto.Changeset{changes: changes, valid?: true} =
               Account.create_changeset(params)

      assert changes.id == params.id
      assert changes.balance == params.balance
    end

    test "with invalid types" do
      params = %{
        id: 111,
        balance: "string"
      }

      changeset = Account.create_changeset(params)

      assert errors_on(changeset) == %{
        id: ["is invalid"],
        balance: ["is invalid"],
      }
    end
  end
end

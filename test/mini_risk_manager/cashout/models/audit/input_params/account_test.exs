defmodule MiniRiskManager.Cashout.Models.Audit.InputParams.AccountTest do
  @moduledoc false
  use MiniRiskManager.DataCase, async: true
  alias MiniRiskManager.Cashout.Models.Audit.InputParams.Account

  @err_cant_be_blank "can't be blank"
  setup do
    params = string_params_for(:mini_risk_manager_audit)

    invalid_params =
      string_params_for(
        :mini_risk_manager_audit_account_params,
        id: nil,
        balance: nil
      )

    %{invalid_params: invalid_params, params: params}
  end

  describe "create_changeset/2" do
    test "When passed all required attrs return a valid changeset", %{params: params} do
      assert %Ecto.Changeset{valid?: true} =
               Account.create_changeset(params["input_params"]["account"])
    end

    test "When missing required attrs return a invalid changeset", %{invalid_params: invalid_params} do
      assert %Ecto.Changeset{
               valid?: false,
               errors: [
                 id: {@err_cant_be_blank, [validation: :required]},
                 balance: {@err_cant_be_blank, [validation: :required]}
               ]
             } = Account.create_changeset(invalid_params)
    end
  end
end

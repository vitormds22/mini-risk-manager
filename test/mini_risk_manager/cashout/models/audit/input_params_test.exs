defmodule MiniRiskManager.Cashout.Models.Audit.InputParamsTest do
  @moduledoc false

  use MiniRiskManager.DataCase, async: true
  alias MiniRiskManager.Cashout.Models.Audit.InputParams

  @err_cant_be_blank "can't be blank"
  setup do
    params = string_params_for(:mini_risk_manager_audit)

    invalid_params =
      string_params_for(
        :mini_risk_manager_audit_input_params,
        operation_id: nil,
        operation_type: nil,
        amount: nil,
        account: nil,
        target: nil
      )

    %{invalid_params: invalid_params, params: params}
  end

  describe "create_changeset/2" do
    test "When passed all required attrs return a valid changeset", %{params: params} do
      assert %Ecto.Changeset{valid?: true} = InputParams.create_changeset(params["input_params"])
    end

    test "When missing required attrs return a invalid changeset", %{invalid_params: invalid_params} do
      assert %Ecto.Changeset{
               valid?: false,
               errors: [
                 operation_type: {@err_cant_be_blank, [validation: :required]},
                 operation_id: {@err_cant_be_blank, [validation: :required]},
                 amount: {@err_cant_be_blank, [validation: :required]},
                 account: {@err_cant_be_blank, [validation: :required]},
                 target: {@err_cant_be_blank, [validation: :required]}
               ]
             } = InputParams.create_changeset(invalid_params)
    end
  end
end

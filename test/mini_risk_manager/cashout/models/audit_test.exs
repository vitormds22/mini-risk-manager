defmodule MiniRiskManager.Cashout.Models.AuditTest do
  @moduledoc false

  use MiniRiskManager.DataCase, async: true
  alias MiniRiskManager.Cashout.Models.Audit

  @err_cant_be_blank "can't be blank"

  setup do
    params = string_params_for(:mini_risk_manager_audit)

    invalid_params =
      string_params_for(
        :mini_risk_manager_audit,
        input_params: nil,
        model_input: nil,
        model_response: nil,
        operation_type: nil,
        operation_id: nil
      )

    invalid_params_operation =
      string_params_for(
        :mini_risk_manager_audit,
        input_params: nil,
        operation_type: nil,
        operation_id: nil
      )

    %{invalid_params_operation: invalid_params_operation, invalid_params: invalid_params, params: params}
  end

  describe "create_changeset/1" do
    test "When missing required attrs return a invalid changeset", %{invalid_params: invalid_params} do
      assert %Ecto.Changeset{
               valid?: false,
               errors: [
                 operation_id: {@err_cant_be_blank, [validation: :required]},
                 operation_type: {@err_cant_be_blank, [validation: :required]},
                 input_params: {@err_cant_be_blank, [validation: :required]},
                 model_input: {@err_cant_be_blank, [validation: :required]},
                 model_response: {@err_cant_be_blank, [validation: :required]}
               ]
             } = Audit.create_changeset(invalid_params)
    end

    test "When passed all required attrs return a valid changeset", %{params: params} do
      assert %Ecto.Changeset{valid?: true} = Audit.create_changeset(params)
    end

    test "When pass a changeset without input params and operations data return a invalid changeset", %{invalid_params_operation: invalid_params_operation} do
      assert %Ecto.Changeset{
        valid?: false,
        errors: [
          operation_id: {@err_cant_be_blank, [validation: :required]},
          operation_type: {@err_cant_be_blank, [validation: :required]},
          input_params: {@err_cant_be_blank, [validation: :required]}
        ]
      } = Audit.create_changeset(invalid_params_operation)
    end
  end
end

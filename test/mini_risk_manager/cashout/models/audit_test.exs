defmodule MiniRiskManager.Cashout.Models.AuditTest do
  @moduledoc false

  use MiniRiskManager.DataCase, async: true
  alias MiniRiskManager.Cashout.Models.Audit

  @err_cant_be_blank "can't be blank"

  describe "create_changeset/1" do
    test "When missing required attrs return a invalid changeset" do
      audit =
        params_for(
          :mini_risk_manager_audit,
          input_params: nil,
          model_input: nil,
          model_response: nil
        )

      assert %Ecto.Changeset{
               valid?: false,
               errors: [
                 input_params: {@err_cant_be_blank, [validation: :required]},
                 model_input: {@err_cant_be_blank, [validation: :required]},
                 model_response: {@err_cant_be_blank, [validation: :required]}
               ]
             } = Audit.create_changeset(audit)
    end

    test "When passed all required attrs return a valid changeset" do
      audit = params_for(:mini_risk_manager_audit)

      assert %Ecto.Changeset{valid?: true} = Audit.create_changeset(audit)
    end
  end
end

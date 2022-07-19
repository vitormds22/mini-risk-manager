defmodule MiniRiskManager.Cashout.Models.AuditTest do
  @moduledoc """
  Tests for model Audit
  """

  use MiniRiskManager.DataCase, async: true
  import MiniRiskManager.Factory.Cashout.AuditsFactory

  alias MiniRiskManager.Cashout.Models.Audit
  @err_cant_be_blank "can't be blank"

  describe "create_changeset/1" do
    test "When missing required attrs return a invalid changeset" do
      # audit = params_for(:cashout_audit, input_params: nil, model_input: nil, model_response: nil)
      audit = %{is_valid: true}

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
      audit = %{
        input_params: %{},
        model_input: %{},
        model_response: %{},
        is_valid: true
      }

      assert %Ecto.Changeset{
               valid?: true,
               changes: %{
                  input_params: %{},
                  is_valid: true,
                  model_input: %{},
                  model_response: %{}
               },
             } = Audit.create_changeset(audit)
    end
  end
end

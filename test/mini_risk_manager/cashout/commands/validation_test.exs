defmodule MiniRiskManager.Cashout.Commands.ValidationTest do
  @moduledoc false
  use MiniRiskManager.DataCase, async: true
  import Mox

  alias MiniRiskManager.Cashout.Commands.Validation
  alias MiniRiskManager.Ports.Types.BalanceBlokerInput
  alias MiniRiskManager.Ports.Types.ModelInput

  describe "run/1" do
    test "when port response is valid returns ok and is_valid true" do
      input = string_params_for(:mini_risk_manager_audit_input_params)
      output = build(:mini_risk_manager_model_response, metadata: nil)

      expect(
        MiniRiskManager.Ports.ModelPortMock,
        :call_model,
        fn %ModelInput{
             operation_type: operation_type,
             amount: amount,
             balance: balance
           } ->
          assert input["operation_type"] == operation_type
          assert input["amount"] == amount
          assert input["account"]["balance"] == balance

          {:ok, output}
        end
      )

      assert output == Validation.run(input)
    end

    test "when port response is valid returns ok and is_valid false" do
      audit = build(:mini_risk_manager_audit)

      input_params =
        string_params_for(:mini_risk_manager_audit_input_params,
          operation_id: audit.input_params.operation_id,
          operation_type: audit.input_params.operation_type,
          amount: audit.input_params.amount,
          account: %{
            id: audit.input_params.account.id,
            balance: audit.input_params.account.balance
          },
          target: %{
            account_code: audit.input_params.target.account_code,
            account_type: audit.input_params.target.account_type,
            document: audit.input_params.target.document
          }
        )

      output = build(:mini_risk_manager_model_response, is_valid: false, metadata: nil)

      expect(
        MiniRiskManager.Ports.BalanceBlokerPortMock,
        :block_balance,
        fn %BalanceBlokerInput{
             operation_type: operation_type,
             amount: amount
           } ->
          assert input_params["operation_type"] == operation_type
          assert input_params["amount"] == amount

          :ok
        end
      )

      expect(
        MiniRiskManager.Ports.ModelPortMock,
        :call_model,
        fn %ModelInput{
             operation_type: operation_type,
             amount: amount,
             account_type: account_type
           } ->
          assert input_params["operation_type"] == operation_type
          assert input_params["amount"] == amount
          assert input_params["target"]["account_type"] == account_type

          {:ok, output}
        end
      )

      assert output == Validation.run(input_params)
    end

    test "when port response is invalid returns error and reason" do
      input =
        string_params_for(:mini_risk_manager_audit_input_params,
          operation_id: :error_test,
          operation_type: :error_test,
          amount: "error_test",
          account: %{
            id: "error_test",
            balance: nil
          },
          target: %{
            account_type: nil
          }
        )

      expect(
        MiniRiskManager.Ports.ModelPortMock,
        :call_model,
        fn %ModelInput{
             operation_type: operation_type,
             amount: amount,
             balance: balance
           } ->
          assert input["operation_type"] == operation_type
          assert input["amount"] == amount
          assert input["account"]["balance"] == balance

          {:error, :request_failed}
        end
      )

      assert {:error, :request_failed} == Validation.run(input)
    end
  end
end

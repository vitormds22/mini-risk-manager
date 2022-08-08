defmodule MiniRiskManager.Cashout.Commands.ValidationTest do
  @moduledoc false
  use MiniRiskManager.DataCase, async: true
  import Mox

  alias MiniRiskManager.Cashout.Commands.Validation
  alias MiniRiskManager.Ports.Types.ModelInput


  setup do
    audit = build(:mini_risk_manager_audit)
    false_output = %{is_valid: false}
    true_output = %{is_valid: true}

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

    assert [] = all_enqueued()
    %{input_params: input_params, false_output: false_output, true_output: true_output, audit: audit}
  end

  describe "run/1" do
    test "when the port response is valid returns ok and is_valid true", %{true_output: true_output} do
      input = string_params_for(:mini_risk_manager_audit_input_params)

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

          {:ok, true_output}
        end
      )

      assert true_output == Validation.run(input)
      assert MiniRiskManager.Repo.aggregate(MiniRiskManager.Cashout.Models.Audit, :count, :id) == 1

    end

    test "when the port response is false returns map with is_valid false", %{input_params: input_params, false_output: false_output} do
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

          {:ok, false_output}
        end
      )

      assert false_output == Validation.run(input_params)
      assert MiniRiskManager.Repo.aggregate(MiniRiskManager.Cashout.Models.Audit, :count, :id) == 1

    end

    test "when the port response is false, the job is enqueued", %{input_params: input_params, false_output: false_output} do
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

          {:ok, false_output}
        end
        )

      assert false_output == Validation.run(input_params)

      assert_enqueued(
        worker: MiniRiskManager.Cashout.Jobs.BalanceBlokerJob,
        args: %{
          "operation_id" => input_params["operation_id"],
          "operation_type" => input_params["operation_type"],
          "amount" => input_params["amount"],
          "account_id" => input_params["account"]["id"]
        }
      )

      assert MiniRiskManager.Repo.aggregate(MiniRiskManager.Cashout.Models.Audit, :count, :id) == 1
    end

    test "when the port response is error and request failed", %{input_params: input_params} do
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

          {:error, :request_failed}
        end
        )

      assert {:error, :request_failed} == Validation.run(input_params)
    end

    test "with invalid input_params returns error and invalid changeset" do
      assert {:error, %Ecto.Changeset{valid?: false}} = Validation.run(%{})
    end

  end
end

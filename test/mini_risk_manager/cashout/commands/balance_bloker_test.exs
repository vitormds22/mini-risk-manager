defmodule MiniRiskManager.Cashout.Commands.BalanceBlokerTest do
  @moduledoc false
  use MiniRiskManager.DataCase, async: true
  import Mox

  alias MiniRiskManager.Cashout.Commands.BalanceBloker
  alias MiniRiskManager.Ports.Types.BalanceBlokerInput

  describe "run/1" do
    test "with valid input" do
      input = build(:mini_risk_manager_balance_bloker)

      expect(MiniRiskManager.Ports.BalanceBlokerPortMock, :block_balance, fn %BalanceBlokerInput{
                                                                               operation_id:
                                                                                 operation_id,
                                                                               operation_type:
                                                                                 operation_type,
                                                                               amount: amount,
                                                                               account_id:
                                                                                 account_id
                                                                             } ->
        assert input.operation_id == operation_id
        assert input.operation_type == operation_type
        assert input.amount == amount
        assert input.account_id == account_id

        :ok
      end)

      assert :ok == BalanceBloker.run(input)
    end

    test "with invalid input" do
      expect(MiniRiskManager.Ports.BalanceBlokerPortMock, :block_balance, fn _ ->
        {:error, :request_failed}
      end)

      assert {:error, :request_failed} == BalanceBloker.run("test")
    end
  end
end

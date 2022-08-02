defmodule MiniRiskManager.Cashout.Jobs.BalanceBlokerJobTest do
  @moduledoc false

  use MiniRiskManager.DataCase, async: true
  import Mox

  alias MiniRiskManager.Cashout.Jobs.BalanceBlokerJob

  setup do
    input = build(:mini_risk_manager_balance_bloker)

    %{input: input}
  end

  describe "perform/1" do
    test "with valid input", %{input: input} do
      expect(MiniRiskManager.Ports.BalanceBlokerPortMock, :block_balance, fn _ ->
        :ok
      end)

      assert BalanceBlokerJob.perform(%Oban.Job{args: input}) == :ok
    end

    test "should raise an exception when params are invalid" do
      assert_raise(FunctionClauseError, fn ->
        BalanceBlokerJob.perform(%Oban.Job{args: :error})
      end)
    end
  end
end

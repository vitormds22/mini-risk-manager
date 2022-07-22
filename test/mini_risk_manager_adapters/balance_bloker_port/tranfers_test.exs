defmodule MiniRiskManagerAdapters.BalanceBlokerPort.TransfersTest do
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  alias MiniRiskManager.Ports.Types.BalanceBlokerInput
  alias MiniRiskManagerAdapters.BalanceBlokerPort.Transfers

  def balance_bloker_input do
    %BalanceBlokerInput{
      operation_id: Ecto.UUID.generate(),
      operation_type: :inbound_pix_payment,
      amount: 20,
      account_id: Ecto.UUID.generate()
    }
  end

  def invalid_balance_bloker_input do
    %BalanceBlokerInput{
      operation_id: nil,
      operation_type: nil,
      amount: nil,
      account_id: nil
    }
  end

  setup do
    payload = balance_bloker_input()
    invalid_payload = invalid_balance_bloker_input()

    %{payload: payload, invalid_payload: invalid_payload}
  end

  describe "block_balance/1" do
    test "when post a valid payload to a valid url return a tuple of success", %{payload: payload} do
      expect(TeslaMock, :call, fn env, _ ->
        assert env.url ==
                 "http://transfers.transfers/service/v1/accounts/#{payload.account_id}/block_balance"

        {:ok, %Tesla.Env{status: 204}}
      end)

      assert Transfers.block_balance(payload) == :ok
    end

    test "when post a invalid payload to a valid url return a tuple of error and request failed", %{
      invalid_payload: invalid_payload
    } do
      expect(TeslaMock, :call, fn env, _ ->
        assert env.url ==
                 "http://transfers.transfers/service/v1/accounts/#{invalid_payload.account_id}/block_balance"

        {:ok, %Tesla.Env{status: 400}}
      end)

      assert Transfers.block_balance(invalid_payload) ==
               {:error, :request_failed}
    end

    test "when post a invalid payload to a valid url return a tuple of error and reason", %{
      invalid_payload: invalid_payload
    } do
      expect(TeslaMock, :call, fn env, _ ->
        assert env.url ==
                 "http://transfers.transfers/service/v1/accounts/#{invalid_payload.account_id}/block_balance"

        assert env.body == Jason.encode!(invalid_payload)

        {:error, :timeout}
      end)

      assert Transfers.block_balance(invalid_payload) ==
               {:error, :request_failed}
    end
  end
end

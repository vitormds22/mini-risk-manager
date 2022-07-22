defmodule MiniRiskManagerAdapters.ModelPort.RiskAnalysisTest do
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  alias MiniRiskManager.Ports.Types.ModelInput
  alias MiniRiskManager.Ports.Types.ModelResponse
  alias MiniRiskManagerAdapters.ModelPort.RiskAnalysis

  @valid_base_url "http://risk-analysis.risk-analysis/service/v1/models/cashout"

  def model_input do
    %ModelInput{
      operation_type: "inbound_pix_payment",
      amount: 50,
      balance: 10,
      account_type: "CC",
      sum_amount_last_24h: 60
    }
  end

  def invalid_model_input do
    %ModelInput{
      operation_type: nil,
      amount: nil,
      balance: nil,
      account_type: nil,
      sum_amount_last_24h: nil
    }
  end

  def model_output_body do
    %{
      "is_valid" => true,
      "metadata" => %{"test" => "teste"}
    }
  end

  def invalid_model_output_body do
    %{
      "reason" => "invalid_params"
    }
  end

  setup do
    payload = model_input()
    body = model_output_body()

    invalid_payload = invalid_model_input()
    invalid_body = invalid_model_output_body()

    %{payload: payload, body: body, invalid_payload: invalid_payload, invalid_body: invalid_body}
  end

  describe "call_model/1" do
    test "when post a valid payload to a valid url return success and attr is_valid true", %{
      payload: payload,
      body: body
    } do
      expect(TeslaMock, :call, fn env, _ ->
        assert env.url == @valid_base_url
        assert env.body == Jason.encode!(payload)

        {:ok, %Tesla.Env{status: 200, body: body}}
      end)

      assert RiskAnalysis.call_model(payload) ==
               {:ok, %ModelResponse{is_valid: true, metadata: %{"test" => "teste"}}}
    end

    test "when post a invalid paylod to a valid url return a tuple error and request_failed", %{
      invalid_payload: invalid_payload,
      invalid_body: invalid_body
    } do
      expect(TeslaMock, :call, fn env, _ ->
        assert env.url == @valid_base_url
        assert env.body == Jason.encode!(invalid_payload)

        {:ok, %Tesla.Env{status: 400, body: invalid_body}}
      end)

      assert RiskAnalysis.call_model(invalid_payload) == {:error, :request_failed}
    end

    test "when post a invalid paylod to a valid url return a tuple error and reason", %{
      invalid_payload: invalid_payload
    } do
      expect(TeslaMock, :call, fn env, _ ->
        assert env.url == @valid_base_url
        assert env.body == Jason.encode!(invalid_payload)

        {:error, :timeout}
      end)

      assert RiskAnalysis.call_model(invalid_payload) == {:error, :request_failed}
    end
  end
end

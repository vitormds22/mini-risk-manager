defmodule MiniRiskManagerAdapters.ModelPort.RiskAnalysisTest do
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  alias MiniRiskManagerAdapters.ModelPort.RiskAnalysis
  alias MiniRiskManager.Ports.Types.ModelResponse
  alias MiniRiskManager.Ports.Types.ModelInput

  @valid_base_url "http://risk-analysis.risk-analysis/service/v1/models/cashout"
  @invalid_base_url "http://risk-analysis.risk-analysis/service/v1/models/cash"

  def model_input() do
    %ModelInput{
      operation_type: "inbound_pix_payment",
      amount: 50,
      balance: 10,
      account_type: "CC",
      sum_amount_last_24h: 60
    }
  end

  def model_output_body() do
    %{
      "is_valid" => true,
      "metadata" => %{"test" => "teste"}
    }
  end

  describe "call_model/1" do
    test "when post a valid payload to a valid url return success and attr is_valid true" do
      payload = model_input()
      body = model_output_body()

      expect(TeslaMock, :call, fn env, _ ->
        assert env.url == @valid_base_url
        assert env.body == Jason.encode!(payload)

        {:ok, %Tesla.Env{status: 200, body: body}}
      end)

      assert RiskAnalysis.call_model(payload) == {:ok, %ModelResponse{is_valid: true, metadata: %{"test" => "teste"}}}
    end
  end
end

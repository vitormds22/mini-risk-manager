defmodule MiniRiskManagerAdapters.ModelPort.RiskAnalysisTest do
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  alias MiniRiskManagerAdapters.ModelPort.RiskAnalysis
  alias MiniRiskManager.Ports.Types.ModelResponse
  alias MiniRiskManager.Ports.Types.ModelInput

  @valid_base_url "http://risk-analysis.risk-analysis/service/v1/models/cashout"
  @invalid_base_url "http://risk-analysis.risk-analysis/service/v1/models/cash"

  def model_input_body() do
    %ModelInput{
      operation_type: "inbound_pix_payment",
      amount: 50,
      balance: 10,
      account_type: "CC",
      sum_amount_last_24h: 60
    }
  end

  describe "call_model/1" do
    test "when post a valid payload to a valid url return success and attr is_valid true" do
      payload = model_input_body()

      expect(TeslaMock, :call, fn env, _ ->
        assert env.url == @valid_base_url

        {:ok, %Tesla.Env{status: 200, body: payload}}
      end)

      response = RiskAnalysis.call_model(payload)

      expected_response = {:ok, %ModelResponse{is_valid: true, metadata: %{test: "test"}}}

      assert response = expected_response
    end
  end
end

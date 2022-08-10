defmodule MiniRiskManager.Factory.Ports.ModelFactory do
  @moduledoc false

  # credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks
  defmacro __using__(_opts) do
    quote location: :keep do
      alias MiniRiskManager.Ports.Types.ModelInput
      alias MiniRiskManager.Ports.Types.ModelResponse

      def mini_risk_manager_model_input_factory do
        %ModelInput{
          operation_type: :inbound_external_transfer,
          amount: Enum.random(1..200),
          balance: Enum.random(1..200),
          account_type: :CC,
          sum_amount_last_24h: Enum.random(1..200)
        }
      end

      def mini_risk_manager_model_response_factory do
        %ModelResponse{
          is_valid: true,
          metadata: %{}
        }
      end
    end
  end
end

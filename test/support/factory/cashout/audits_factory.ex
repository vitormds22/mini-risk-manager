defmodule MiniRiskManager.Factory.Cashout.AuditsFactory do
  @moduledoc false

  # credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks

  defmacro __using__(_opts) do
    quote location: :keep do
      alias MiniRiskManager.Cashout.Models.Audit

      def mini_risk_manager_audit_factory do
        %Audit{
          id: Ecto.UUID.generate(),
          input_params: %{
            operation_id: Ecto.UUID.generate(),
            operation_type: :inbound_pix_payment,
            amount: 20,
            account: %{
              id: Ecto.UUID.generate(),
              balance: 20
            },
            target: %{
              document: "Teste Factory",
              account_code: "XPTO-0",
              account_type: :CC
            }
          },
          model_input: %{
            operation_type: :inbound_pix_payment,
            amount: 20,
            balance: 20,
            account_type: :CC,
            sum_amount_last_24h: 40
          },
          model_response: %{
            is_valid: true,
            metadata: %{test: "Teste Factory"}
          },
          is_valid: true
        }
      end
    end
  end
end

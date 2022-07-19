defmodule MiniRiskManager.Factory.Cashout.AuditsFactory do
  @moduledoc false

  # credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks

  defmacro __using__(_opts) do
    quote location: :keep do
      alias MiniRiskManager.Cashout.Models.Audit

      def mini_risk_manager_audit_factory do
        %Audit{
          id: Ecto.UUID.generate(),
          input_params: %{},
          model_input: %{},
          model_response: %{},
          is_valid: "true",
        }
      end
    end
  end
end

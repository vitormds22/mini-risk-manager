defmodule MiniRiskManager.Factory.Ports.BalanceBlokerFactory do
  @moduledoc false

  # credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks
  defmacro __using__(_opts) do
    quote location: :keep do
      alias MiniRiskManager.Ports.Types.BalanceBlokerInput

      def mini_risk_manager_balance_bloker_factory() do
        %BalanceBlokerInput{
          operation_id: Ecto.UUID.generate(),
          operation_type: :inbound_external_transfer,
          amount: Enum.random(1..200),
          account_id: Ecto.UUID.generate()
        }
      end
    end
  end
end

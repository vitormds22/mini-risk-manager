defmodule MiniRiskManager.Factory.Cashout.AuditsFactory do
  @moduledoc false

  # credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks
  defmacro __using__(_opts) do
    quote location: :keep do
      alias MiniRiskManager.Cashout.Models.Audit
      alias MiniRiskManager.Cashout.Models.Audit.InputParams
      alias MiniRiskManager.Cashout.Models.Audit.InputParams.Account
      alias MiniRiskManager.Cashout.Models.Audit.InputParams.Target

      def mini_risk_manager_audit_factory(params \\ %{}) do
        merge_attributes(
          %Audit{
            id: Ecto.UUID.generate(),
            input_params: mini_risk_manager_audit_input_params_factory(),
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
          },
          params
        )
      end

      def mini_risk_manager_audit_input_params_factory(params \\ %{}) do
        merge_attributes(
          %InputParams{
            operation_id: Ecto.UUID.generate(),
            operation_type: :inbound_pix_payment,
            amount: 20,
            account: mini_risk_manager_audit_account_params_factory(),
            target: mini_risk_manager_audit_target_params_factory()
          },
          params
        )
      end

      def mini_risk_manager_audit_account_params_factory(params \\ %{}) do
        merge_attributes(
          %Account{
            id: Ecto.UUID.generate(),
            balance: 20
          },
          params
        )
      end

      def mini_risk_manager_audit_target_params_factory(params \\ %{}) do
        merge_attributes(
          %Target{
            document: "Teste Factory",
            account_code: "XPTO-0",
            account_type: :CC
          },
          params
        )
      end
    end
  end
end

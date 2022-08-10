defmodule MiniRiskManager.Cashout.Commands.Validation do
  @moduledoc """
  Command for risk validation
  """

  alias Ecto.Multi
  alias MiniRiskManager.Cashout.Aggregates.AuditAggregate
  alias MiniRiskManager.Cashout.Jobs.BalanceBlokerJob
  alias MiniRiskManager.Cashout.Models.Audit.InputParams
  alias MiniRiskManager.Cashout.Repositories.AuditRepository
  alias MiniRiskManager.Ports.ModelPort
  alias MiniRiskManager.Ports.Types.ModelInput
  alias MiniRiskManager.Repo

  require Logger

  @spec run(map()) ::
          {:ok, boolean()} | {:error, :request_failed | :save_failed | Ecto.Changeset.t()}
  def run(params) do
    params
    |> InputParams.validate()
    |> case do
      {:ok, input_params} -> call_model(input_params)
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp call_model(input_params) do
    model_input = %ModelInput{
      operation_type: input_params.operation_type,
      amount: input_params.amount,
      balance: input_params.account.balance,
      account_type: input_params.target.account_type,
      sum_amount_last_24h: AuditRepository.sum_amount_last_24h(input_params.account.id)
    }

    model_input
    |> ModelPort.call_model()
    |> case do
      {:ok, %{is_valid: true} = response} ->
        create_audit_input(model_input, input_params, response)

        {:ok, true}

      {:ok, %{is_valid: false} = response} ->
        multi =
          Multi.new()
          |> Multi.run(:audit, fn _, _ ->
            create_audit_input(model_input, input_params, response)
          end)
          |> Multi.run(:job, fn _, %{audit: audit} -> create_balance_blok_job(audit) end)

        case Repo.transaction(multi) do
          {:ok, _transaction} ->
            {:ok, false}

          {:error, :audit, invalid_changeset, _} ->
            duplicated_audit =
              AuditRepository.get_audit_by_operation_id_and_operation_type(
                invalid_changeset.changes.operation_id,
                invalid_changeset.changes.operation_type
              )

            {:ok, duplicated_audit.model_response["is_valid"]}

          err ->
            Logger.error("#{__MODULE__}.run save failed. Error: #{inspect(err)}")
            {:error, :save_failed}
        end

      {:error, :request_failed} ->
        {:error, :request_failed}
    end
  end

  defp create_audit_input(model_input, input_params, model_response) do
    AuditAggregate.create_audit(%{
      model_input: model_input,
      model_response: model_response,
      is_valid: model_response.is_valid,
      input_params: %{
        account: Map.from_struct(input_params.account),
        amount: input_params.amount,
        operation_id: input_params.operation_id,
        operation_type: input_params.operation_type,
        target: Map.from_struct(input_params.target)
      }
    })
  end

  defp create_balance_blok_job(params) do
    %{
      operation_id: params.operation_id,
      operation_type: params.operation_type,
      amount: params.input_params.amount,
      account_id: params.input_params.account.id
    }
    |> BalanceBlokerJob.new()
    |> Oban.insert()
  end
end

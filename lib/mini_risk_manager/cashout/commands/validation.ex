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
        create_audit_and_job(model_input, input_params, response)

      {:error, :request_failed} ->
        {:error, :request_failed}
    end
  end

  defp create_audit_and_job(model_input, input_params, response) do
    Multi.new()
    |> Multi.run(:audit, &create_audit_input(&1, &2, model_input, input_params, response))
    |> Multi.run(:job, &create_balance_blok_job(&1, &2))
    |> Repo.transaction()
    |> case do
      {:ok, _transaction} ->
        {:ok, false}

      {:error, :audit,
       %Ecto.Changeset{
         errors: [
           operation_id:
             {"has already been taken",
              [
                constraint: :unique,
                constraint_name: "audits_operation_id_operation_type_index"
              ]}
         ]
       }, _} ->
        duplicated_audit =
          AuditRepository.get_audit_by_operation_id_and_operation_type(
            input_params.operation_id,
            input_params.operation_type
          )

        {:ok, duplicated_audit.model_response["is_valid"]}

      err ->
        Logger.error("#{__MODULE__}.run save failed. Error: #{inspect(err)}")
        {:error, :save_failed}
    end
  end

  defp create_audit_input(_, _, model_input, input_params, model_response) do
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

  defp create_balance_blok_job(_, %{audit: audit}) do
    %{
      operation_id: audit.operation_id,
      operation_type: audit.operation_type,
      amount: audit.input_params.amount,
      account_id: audit.input_params.account.id
    }
    |> BalanceBlokerJob.new()
    |> Oban.insert()
  end
end

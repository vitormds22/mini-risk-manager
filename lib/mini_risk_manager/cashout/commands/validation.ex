defmodule MiniRiskManager.Cashout.Commands.Validation do
  @moduledoc """
  Command for `MiniRiskManager.Ports.ModelPort` account
  """

  alias Ecto.Multi
  alias MiniRiskManager.Cashout.Aggregates.AuditAggregate
  alias MiniRiskManager.Cashout.Jobs.BalanceBlokerJob
  alias MiniRiskManager.Cashout.Repositories.AuditRepository
  alias MiniRiskManager.Ports.ModelPort
  alias MiniRiskManager.Ports.Types.ModelInput
  alias MiniRiskManager.Ports.Types.ModelResponse
  alias MiniRiskManager.Repo

  @spec run(map()) ::
          {:ok, ModelResponse.t()} | {:error, :request_failed}
  def run(
        %{
          "operation_type" => operation_type,
          "amount" => amount,
          "account" => %{"id" => account_id, "balance" => balance},
          "target" => %{
            "account_type" => account_type
          }
        } = input_params
      ) do
    model_input = %ModelInput{
      operation_type: operation_type,
      amount: amount,
      balance: balance,
      account_type: account_type,
      sum_amount_last_24h: AuditRepository.sum_amount_last_24h(account_id)
    }

    model_input
    |> ModelPort.call_model()
    |> case do
      {:ok, %ModelResponse{is_valid: true} = model_response} ->
        AuditAggregate.create_audit(create_audit_input(model_input, input_params, model_response))

        %ModelResponse{is_valid: true}

      {:ok, %ModelResponse{is_valid: false} = model_response} ->
        multi =
          Multi.new()
          |> Multi.run(:audit, fn _, _ ->
            AuditAggregate.create_audit(
              create_audit_input(model_input, input_params, model_response)
            )
          end)
          |> Multi.run(:job, fn _, %{audit: audit} ->
            job_params = create_job_params(audit)

            job_params
            |> BalanceBlokerJob.new()
            |> Oban.insert()
          end)

        case Repo.transaction(multi) do
          {:ok, _transaction} ->
            %ModelResponse{is_valid: false}

          {:error, changeset} ->
            {:error, changeset}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec create_audit_input(ModelInput.t(), map(), ModelResponse.t()) :: map()
  def create_audit_input(model_input, input_params, model_response) do
    %{
      operation_id: input_params["operation_id"],
      operation_type: input_params["operation_type"],
      model_input: model_input,
      model_response: model_response,
      is_valid: model_response.is_valid,
      input_params: input_params
    }
  end

  @spec create_job_params(MiniRiskManager.Cashout.Models.Audit.t()) :: map()
  def create_job_params(params) do
    %{
      operation_id: params.operation_id,
      operation_type: params.operation_type,
      amount: params.input_params.amount,
      account_id: params.input_params.account.id
    }
  end
end

defmodule MiniRiskManagerAdapters.BalanceBlokerPort.Transfers do
  @moduledoc """
  Implements the behaviour of `MiniRiskManager.Ports.BalanceBlokerPort` to the Transfers
  """

  use MiniRiskManagerAdapters.Tesla, "http://transfers.transfers"
  plug Tesla.Middleware.PathParams

  @behaviour MiniRiskManager.Ports.BalanceBlokerPort
  alias MiniRiskManager.Ports.Types.BalanceBlokerInput

  @impl true
  def block_balance(%BalanceBlokerInput{account_id: account_id} = payload) do
    body = Map.take(payload, [:operation_id, :operation_type, :amount, :internal_reason])

    "/service/v1/accounts/:account_id/block_balance"
    |> post(body,
      opts: [
        path_params: [
          account_id: account_id
        ]
    ])
    |> handle_post()
  end

  defp handle_post({:ok, %Tesla.Env{status: 204}}), do: :ok

  defp handle_post({:ok, %Tesla.Env{status: status}}) do
    Logger.error("#{__MODULE__}.handle_post status=#{inspect(status)}")
    {:error, :request_failed}
  end

  defp handle_post({:error, reason}) do
    Logger.error("#{__MODULE__}.handle_post error=#{inspect(reason)}")
    {:error, :request_failed}
  end
end

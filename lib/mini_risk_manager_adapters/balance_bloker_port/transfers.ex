defmodule MiniRiskManagerAdapters.BalanceBlokerPort.Transfers do
  @moduledoc """
  Implements the behaviour of `MiniRiskManager.Ports.BalanceBlokerPort` to the Transfers
  """

  use MiniRiskManagerAdapters.Tesla, "http://transfers.transfers"

  @behaviour MiniRiskManager.Ports.BalanceBlokerPort

  @impl true
  def block_balance(payload) do
    "/service/v1/accounts/#{payload.account_id}/block_balance"
    |> post(payload)
    |> handle_post()
  end

  defp handle_post({:ok, %Tesla.Env{status: 204}}), do: {:ok, :status}

  defp handle_post({:ok, %Tesla.Env{status: status}}) do
    Logger.error("#{__MODULE__}.handle_post status=#{inspect(status)}")
    {:error, :request_failed}
  end

  defp handle_post({:error, reason}) do
    Logger.error("#{__MODULE__}.handle_post error=#{inspect(reason)}")
    {:error, :request_failed}
  end
end

defmodule MiniRiskManager.Ports.BalanceBlokerPort do
  @moduledoc """
  Behaviour/Port for block any malicious transfer
  """
  alias MiniRiskManager.Ports.Types.BalanceBlokerInput

  @type block_balance_response() :: :ok | {:error, :request_failed}

  @callback block_balance(BalanceBlokerInput.t()) ::
              block_balance_response()

  @spec block_balance(BalanceBlokerInput.t()) :: block_balance_response()
  def block_balance(block_balance_input) do
    adapter().block_balance(block_balance_input)
  end

  defp adapter do
    :mini_risk_manager
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:adapter)
  end
end

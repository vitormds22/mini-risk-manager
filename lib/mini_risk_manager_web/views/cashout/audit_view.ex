defmodule MiniRiskManagerWeb.Cashout.AuditView do
  use MiniRiskManagerWeb, :view

  @spec render(String.t(), map()) :: map()
  def render("200.json", %{result: result}), do: %{is_valid: result}
end
